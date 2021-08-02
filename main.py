import datetime
import json
from typing import Any, List, Tuple

import psycopg2
import tweepy


JST = datetime.timezone(datetime.timedelta(hours=+9), 'JST')


class Table:
    def __init__(self, columns: List[str], records: List[Tuple[Any]]) -> None:
        self.columns = columns
        self.records = records

    def __str__(self) -> str:  # temporary
        result = '| ' + ' | '.join(self.columns) + ' |\n'
        for record in self.records:
            record: Tuple[Any]
            result += '| ' + ' | '.join(map(str, record)) + ' |\n'
        return result
    
    def __repr__(self) -> str:
        return 'Table(columns=%s, records=%s)' % (repr(self.columns), repr(self.records))


def run_query(query: str) -> Table:
    with psycopg2.connect(dsn='postgresql://bot:bot@localhost/sandbox') as conn:
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


def exec_sql(text: str):
    try:
        result = str(run_query(text.replace('&lt;', '<').replace('&gt;', '>')))
    except Exception as e:
        result = str(e)
    return trim_by_line(result)


def main():
    with open('credential.json', 'r') as f:
        credential = json.load(f)
    
    auth = tweepy.OAuthHandler(credential["API key"], credential["API Secret"])
    auth.set_access_token(credential["Token"], credential["Token Secret"])
    
    api = tweepy.API(auth)
    for timeline_tweet in api.home_timeline():
        tweet_dict = timeline_tweet._json
        created_at = datetime.datetime.strptime(tweet_dict['created_at'], '%a %b %d %H:%M:%S %z %Y')
        if datetime.datetime.now(JST) - created_at < datetime.timedelta(minutes=5):
            text = api.get_status(tweet_dict['id'], tweet_mode="extended").full_text
            print('Found: %s, %s, %s' % (created_at, tweet_dict['user']['screen_name'], text))
            if '#SQL芸' in text:
                print('has hashtag!')
                result = exec_sql(text.replace('#SQL芸', ''))
                api.update_status(status=result, attachment_url='https://twitter.com/%s/status/%s' % (tweet_dict['user']['screen_name'], tweet_dict['id']))
                print('tweeted.')


if __name__ == '__main__':
    # print(exec_sql("SELECT * FROM U16Seq;"))
    main()
