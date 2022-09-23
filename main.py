import datetime
import json
from subprocess import Popen
from typing import Any, List, Tuple

import psycopg2
import tweepy


JST = datetime.timezone(datetime.timedelta(hours=+9), 'JST')


class Table:
    def __init__(self, columns: List[str], records: List[Tuple[Any]]) -> None:
        self.columns = columns
        self.records = records

    def __str__(self) -> str:  # temporary
        result = ' | '.join(self.columns) + '\n'
        for record in self.records:
            record: Tuple[Any]
            result += ' | '.join(map(str, record)) + '\n'
        return result
    
    def __repr__(self) -> str:
        return 'Table(columns=%s, records=%s)' % (repr(self.columns), repr(self.records))


def run_query(query: str) -> Table:
    with psycopg2.connect(dsn='postgresql://bot:bot@localhost:54321/sandbox?application_name=SQLgei') as conn:
        with conn.cursor() as cur:
            cur.execute(query + ';')
            result = Table(
                columns=[col.name for col in cur.description],
                records=cur.fetchall()
            )
        return result


def trim_by_line(text: str, max_len: int = 280, end: str = '...\n') -> str:
    def tweet_length(tweet_text: str) -> int:
        ascii_n = sum(c.isascii() for c in tweet_text)
        return ascii_n + 2 * (len(tweet_text) - ascii_n)
    
    result = ''
    for line in text.split('\n'):
        new_result = result + line + '\n'
        if tweet_length(new_result) >= max_len - len(end):
            return result + end
        result = new_result
    return result


def exec_sql_and_ret_str(text: str) -> str:
    try:
        result = str(run_query(text.replace('&lt;', '<').replace('&gt;', '>')))
    except Exception as e:
        result = str(e)
    return trim_by_line(result)

def exec_sql_and_ret_img(text: str) -> Tuple[str, str]:
    """
    画像形式で実行結果を返す
    (テキスト実行結果，実行結果の画像ファイル名)

    """
    try:
        result = str(run_query(text.replace('&lt;', '<').replace('&gt;', '>')))
    except Exception as e:
        result = str(e)
    result = '\n'.join(result.split('\n')[:50])
    filename = 'tmp/tmp' + str(hash(result))  # ハッシュを用いて一意なファイル名を決める
    with open(filename + '.txt', 'w') as f:
        f.write(result)
    popen = Popen('carbon-now -h -t %s %s.txt' % (filename, filename), shell=True)
    popen.wait()
    return (trim_by_line(result), filename + '.png')


def main():
    with open('credential.json', 'r') as f:
        credential = json.load(f)
    
    auth = tweepy.OAuthHandler(credential["API key"], credential["API Secret"])
    auth.set_access_token(credential["Token"], credential["Token Secret"])
    
    api = tweepy.API(auth)
    for timeline_tweet in api.home_timeline():
        tweet_dict = timeline_tweet._json
        created_at = datetime.datetime.strptime(tweet_dict['created_at'], '%a %b %d %H:%M:%S %z %Y')
        if datetime.datetime.now(JST) - created_at < datetime.timedelta(minutes=2):
            text = api.get_status(tweet_dict['id'], tweet_mode="extended").full_text
            print('Found: %s, %s, %s' % (created_at, tweet_dict['user']['screen_name'], text))
            if '#SQL芸' in text:
                print('has hashtag!')
                result = exec_sql_and_ret_img(text.replace('#SQL芸', ''))
                # result = exec_sql_and_ret_str(text.replace('#SQL芸', ''))
                api.update_with_media(
                    filename=result[1],
                    status=result[0],
                    attachment_url='https://twitter.com/%s/status/%s' % (tweet_dict['user']['screen_name'],tweet_dict['id'])
                )
                # api.update_status(
                #     status=result,
                #     attachment_url='https://twitter.com/%s/status/%s' % (tweet_dict['user']['screen_name'],tweet_dict['id']),
                # )
                print('tweeted.')


if __name__ == '__main__':
    # print(exec_sql("SELECT * FROM U16Seq;"))
    main()
    # exec_sql_and_ret_img("SELECT 'あ', '亜', 'a', '💩' FROM u8;")
