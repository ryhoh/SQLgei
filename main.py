import asyncio
import datetime
import json
from subprocess import Popen
import sys
import time
from typing import Any, List, Tuple

from misskey import Misskey
import psycopg2
import tabulate
import tweepy
import websockets

import util


# Timezone を日本に合わせる
JST = datetime.timezone(datetime.timedelta(hours=+9), 'JST')

# 不適切なワードリスト
BAD_WORDS = set()

# レートリミット用
misskey_last_note_time = datetime.datetime.now(JST)


"""
SELECT文の実行結果テーブル

"""
class Table:
    COL_DELIMITER = ' | '  # カラム間の区切り文字
    ALLOWED_STYLE = set(('simple', 'orgtbl',))  # 許可されたテーブルスタイル

    """
    @param columns カラム名
    @param records データ

    """
    def __init__(self, columns: List[str], records: List[Tuple[Any]], style: str = 'simple') -> None:
        self.columns = columns
        self.records = records
        if style not in self.ALLOWED_STYLE:
            raise ValueError('Unknown style: %s' % style)
        self.style = style

    """
    テーブル文字列化関数
    1行目にカラムを、2行目以降にデータを、それぞれ' | 'で区切りながら出力する

    @return 文字列化した結果

    """
    def __str__(self) -> str:
        # 結果の出力
        if self.style == 'simple':
            return self.__show_simple()
        elif self.style == 'orgtbl':
            return self.__show_by_tabulate()
        else:
            raise ValueError('Unknown style: %s' % self.style)
    
    """
    @return デバッグ用文字列

    """
    def __repr__(self) -> str:
        return 'Table(columns=%s, records=%s)' % (repr(self.columns), repr(self.records))

    """
    @return もう一方のオブジェクトと等しいときTrue

    """
    def __eq__(self, other: "Table") -> bool:
        return self.columns == other.columns and self.records == other.records
    
    """
    シンプルな結果表示関数
    1行目にカラムを、2行目以降にデータを、それぞれ' | 'で区切りながら出力する
    
    @return 結果表示文字列
    """
    def __show_simple(self) -> str:
        result = self.COL_DELIMITER.join(self.columns) + '\n'
        for record in self.records:
            record: Tuple[Any]
            record_str = map(str, record)
            result += self.COL_DELIMITER.join(record_str) + '\n'
        return result
    
    """
    psqlの結果表示関数
    
    @return 結果表示文字列
    """
    def __show_by_tabulate(self) -> str:
        result = tabulate.tabulate(self.records, headers=self.columns, tablefmt=self.style)
        return result

    """
    SQLを実行して、結果テーブルを返す

    @param query 実行するSQL
    @param style 結果のテーブルスタイル
    @return 実行結果テーブル
    @note 複数の文を与えた場合、最後のSELECT文に対する結果を返す
    """
    @classmethod
    def from_select_stmt(self, sqls: str, style: str = 'simple') -> "Table":
        result = None
        with psycopg2.connect(dsn='postgresql://bot:bot@localhost:54321/sandbox?application_name=SQLgei') as conn:
            with conn.cursor() as cur:
                for sql in sqls.split(";"):
                    try:
                        cur.execute(sql)
                        if cur.description is not None:
                            result = Table(
                                columns=[col[0] for col in cur.description],
                                records=cur.fetchall(),
                                style=style,
                            )
                    except psycopg2.ProgrammingError as e:
                        if e.args[0] == "can't execute an empty query":
                            pass
                        else:
                            raise e
                conn.commit()
                if result is None:  # CREATE TABLE や INSERT のみなど、SELECTがない場合
                    result = Table(columns=[], records=[tuple()])
                return result

"""
不適切なワードを、ファイルから読み込んでsetに入れる
"""
def load_bad_words() -> None:
    with open('bad_words/Offensive.txt', 'r') as f:
        for line in f:
            BAD_WORDS.add(line.strip())
    with open('bad_words/Sexual.txt', 'r') as f:
        for line in f:
            BAD_WORDS.add(line.strip())

"""
SELECT文を実行して結果文字列を得る

@param text 実行するSELECT文
@param style 結果のテーブルスタイル
@return 実行結果文字列

"""
def db_run_select_stmt(text: str, style: str = 'simple') -> str:
    try:
        preprocessed = db_preprocess(text)
        result = str(Table.from_select_stmt(preprocessed, style))
    except Exception as e:
        result = str(e)  # 例外時はその内容を文字列化して返す
    return result

"""
実行する文の前処理を行う

@param text 実行する文
@return 前処理後の文
"""
def db_preprocess(text: str) -> str:
    res = text.replace('#SQL芸', '')  # ハッシュタグは見ない
    res = res.replace('&lt;', '<').replace('&gt;', '>')  # HTMLエンティティを元に戻す
    res = res.strip(" \n\r\t")  # 前後の空白を削除
    
    # コードブロックが存在する場合は、コードブロック内のみをDBMSに渡す
    if res.count('```') >= 2:
        res = res[res.find('```') + 3:]
        res = '\n'.join(res.splitlines()[1:])  # コードブロックの最初の行を削除 (sql などの言語指定を削除)
        res = res[:res.find('```')]

    res = replace_bad_words(res)  # 不適切なワードを置換する
    return res

"""
文字列中の不適切なワードを、指定した文字列に置換する
"""
def replace_bad_words(text: str) -> str:
    for bad_word in BAD_WORDS:
        text = text.replace(bad_word, '*' * len(bad_word))
    return text

"""
    実行結果をテキストと画像形式で返す
    画像は、ファイルとして保存しパスを返す

    @param text 実行するSELECT文
    @param max_line_n 画像の方に表示する結果の行数制限
    @param style 結果のテーブルスタイル
    @return (実行結果文字列，実行結果の画像パス)

    """
def db_run_select_stmt_ret_img(
    text: str,
    max_line_n: int = 50,
    style: str = 'simple'
) -> Tuple[str, str]:
    result = db_run_select_stmt(text, style=style)
    result = '\n'.join(result.split('\n')[:max_line_n])
    filename = 'tmp/tmp' + str(hash(result))  # ハッシュを用いて一意なファイル名を決める
    with open(filename + '.txt', 'w') as f:
        f.write(result)
    popen = Popen('carbon-now -h -t %s %s.txt' % (filename, filename), shell=True)
    popen.wait()
    return (result, filename + '.png')


"""
ツイート用に文字数を考慮してテキストを切り詰める
行単位で切り詰めを行い、省略が発生する場合には ... を末尾につける

@param text 処理する文字列
@param max_len Twitter仕様に基づくツイートの文字数
@param dots 省略するとき末尾につけるドット
@return 処理後の文字列

"""
def twit_shorten_for_tweet(text: str, max_len: int = 280, dots: str = '...\n') -> str:
    """
    ツイッター基準の文字数カウント関数
    ※1ツイートで280文字まで書けるが、英数字記号以外は1文字で2文字としてカウントされる

    """
    def tweet_length(tweet_text: str) -> int:
        ascii_n = util.count_ascii(tweet_text)
        return ascii_n + 2 * (len(tweet_text) - ascii_n)
    
    result = ''
    for line in text.split('\n'):
        new_result = result + line + '\n'
        if tweet_length(new_result) >= max_len - len(dots):  # この行を足すと文字数オーバーになる？
            return result + dots  # なる場合、現在の結果に省略行をつけて返す
        result = new_result
    return result


"""
Twitter API を認証して利用できる状態にする

@return tweepyライブラリのAPIオブジェクト

"""
def twit_auth_ret_api():
    credential = util.load_credential()
    
    auth = tweepy.OAuthHandler(credential["API key"], credential["API Secret"])
    auth.set_access_token(credential["Token"], credential["Token Secret"])
    return tweepy.API(auth)

"""
Misskey API を認証して利用できる状態にする

@return (misskeyライブラリのオブジェクト, token)
"""
def msky_auth_ret_api():
    credential = util.load_credential()
    token = credential['misskey token']
    api = Misskey('misskey.io', i=token)
    return (api, token)

"""
Twitterメイン関数

"""
def twit_main():
    api = twit_auth_ret_api()
    for timeline_tweet in api.home_timeline():
        tweet_dict = timeline_tweet._json
        created_at = datetime.datetime.strptime(tweet_dict['created_at'], '%a %b %d %H:%M:%S %z %Y')
        if datetime.datetime.now(JST) - created_at < datetime.timedelta(minutes=2):
            text = api.get_status(tweet_dict['id'], tweet_mode="extended").full_text
            print('Found: %s, %s, %s' % (created_at, tweet_dict['user']['screen_name'], text))
            if '#SQL芸' in text:
                print('has hashtag!')
                result = db_run_select_stmt_ret_img(text)
                api.update_with_media(
                    filename=result[1],
                    status=twit_shorten_for_tweet(result[0]),
                    attachment_url='https://twitter.com/%s/status/%s' % (tweet_dict['user']['screen_name'],tweet_dict['id'])
                )
                print('tweeted.')
        else:
            break


"""
Misskeyメイン関数
"""
async def msky_main():
    api, token = msky_auth_ret_api()
    websocket_url = 'wss://misskey.io/streaming?i=' + token

    while True:
        try:
            async with websockets.connect(websocket_url) as ws:
                await ws.send(
                    json.dumps({
                        "type": "connect",
                        "body": {
                            "channel": "homeTimeline",
                            "id": "search_hashtag"
                        }
                    })
                )

                while True:
                    data = json.loads(await ws.recv())
                    print(data)
                    if data['type'] == 'channel':
                        if data['body']['type'] == 'note':
                            note = data['body']['body']
                            await on_note(api, note)
        except Exception as e:
            sys.stderr.write('[error] failed to connect to websocket.')
            sys.stderr.flush()
            logname = datetime.datetime.now().strftime('%Y%m%d%H%M%S') + '.log'
            with open(logname, 'w') as f:
                f.write(str(e))
            time.sleep(10)

# ノートを受け取ったときの処理
async def on_note(api: Misskey, note: json):
    text: str = note['text']
    if '#SQL芸' in text:
        # レートリミットを設ける
        # 最後にノートを作成してから15秒経過するまでは待つ
        global misskey_last_note_time
        while datetime.datetime.now(JST) - misskey_last_note_time < datetime.timedelta(seconds=15):
            time.sleep(1)
        
        print('has hashtag!')
        result = db_run_select_stmt_ret_img(text, style='orgtbl')

        image_needed = '画像' in text or 'image' in text

        if image_needed:  # 画像有効な場合
            # 先に画像をアップロード
            with open(result[1], 'rb') as f:
                img = api.drive_files_create(file=f)

        # 引用ノートを投稿
        api.notes_create(
            text=twit_shorten_for_tweet(result[0], max_len=1024),
            file_ids=[img['id']] if image_needed else None,  # 画像が必要な場合のみ画像を添付
            renote_id=note['id']
        )

        print('noted.')

        # 最後にノートを作成した時間を更新
        misskey_last_note_time = datetime.datetime.now(JST)

"""
Misskeyフォローバック関数
"""
async def msky_follow():
    api, token = msky_auth_ret_api()
    websocket_url = 'wss://misskey.io/streaming?i=' + token

    while True:
        try:
            async with websockets.connect(websocket_url) as ws:
                await ws.send(
                    json.dumps({
                        "type": "connect",
                        "body": {
                            "channel": "main",
                            "id": "follow_back"
                        }
                    })
                )

                while True:
                    data = json.loads(await ws.recv())
                    print(data)
                    if data['type'] == 'followed':
                        user = data['body']['body']
                        await on_follow(api, user)
        except Exception as e:
            sys.stderr.write('[error] failed to connect to websocket.')
            sys.stderr.flush()
            logname = datetime.datetime.now().strftime('%Y%m%d%H%M%S') + '.log'
            with open(logname, 'w') as f:
                f.write(str(e))
            time.sleep(10)

# フォローされたときの処理
async def on_follow(api: Misskey, user: json):
    try:
        api.following_create(user['id'])
        print('followed back.')
    except Exception as e:
        sys.stderr.write('[error] failed to follow back.')
        sys.stderr.flush()
        logname = datetime.datetime.now().strftime('%Y%m%d%H%M%S') + '.log'
        with open(logname, 'w') as f:
            f.write(str(e))


if __name__ == '__main__':
    load_bad_words()

    if sys.argv[1] == 'twitter':
        twit_main()
    elif sys.argv[1] == 'misskey':
        asyncio.get_event_loop().run_until_complete(msky_main())
    elif sys.argv[1] == 'misskey_sub':
        asyncio.get_event_loop().run_until_complete(msky_follow())
    else:
        print('Usage: python3 main.py [twitter|misskey|misskey_sub]')
        sys.exit(1)
