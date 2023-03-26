import csv

from bs4 import BeautifulSoup

prev_version_codes = set()
# 前バージョンのcsvファイルを読み込む
with open('emojis.csv', 'r', newline='') as f:
    spamreader = csv.reader(f, delimiter=',')
    _ = next(spamreader)  # skip header
    for row in spamreader:
        prev_version_codes.add(row[1])
        idx = int(row[0])

# htmlファイルを読み込む
with open('emojis.html', 'r') as f:
    html = f.read()

soup = BeautifulSoup(html, 'lxml')
names = soup.select('.name')
codes = [elm.contents[0] for elm in names]

infos = soup.select('.info')
infos = [elm.contents[0] if len(elm.contents) > 0 else "" for elm in infos]

print(len(codes), len(infos))

# csvに追記する
written_code = prev_version_codes
with open('emojis.csv', 'a') as f:
    for i in range(len(codes)):
        if codes[i] not in written_code:
            f.write('%s,%s,%s\n' % ((idx+1),codes[i], infos[i]))
            written_code.add(codes[i])
            idx += 1
