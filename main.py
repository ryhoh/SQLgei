import datetime
import json
from typing import Any, List, Tuple

import psycopg2
import twitter


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


def trim_by_line(text: str, max_len: int = 280, end: str = '...') -> str:
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
        result = str(run_query(text))
    except Exception as e:
        result = str(e)
    return trim_by_line(result)


def main():
    with open('/home/pi/SQLgei/credential.json', 'r') as f:
        credential = json.load(f)
    
    auth = twitter.OAuth(consumer_key=credential["API key"],
        consumer_secret=credential["API Secret"],
        token=credential["Token"],
        token_secret=credential["Token Secret"])
    
    t = twitter.Twitter(auth=auth)
    for timeline_tweet in t.statuses.home_timeline():
        created_at = datetime.datetime.strptime(timeline_tweet['created_at'], '%a %b %d %H:%M:%S %z %Y')
        if datetime.datetime.now(JST) - created_at < datetime.timedelta(minutes=5):
            text = timeline_tweet['text']
            print('Found: %s, %s, %s' % (created_at, timeline_tweet['user'], text))
            if '#SQL芸' in text:
                print('has hashtag!')
                result = exec_sql(text.replace('#SQL芸', ''))
                t.statuses.update(status='%s\nhttps://twitter.com/%s/status/%s' %
                    (result, timeline_tweet['user']['screen_name'], timeline_tweet['id']))
                print('tweeted.')


if __name__ == '__main__':
    # print(exec_sql("SELECT * FROM U16Seq;"))
    main()
