from bs4 import BeautifulSoup

with open('emojis.html', 'r') as f:
    html = f.read()

soup = BeautifulSoup(html, 'lxml')
names = soup.select('.name')
codes = [elm.contents[0] for elm in names]

infos = soup.select('.info')
infos = [elm.contents[0] if len(elm.contents) > 0 else "" for elm in infos]

print(len(codes), len(infos))

with open('emojis.csv', 'w') as f:
    f.write('id,code,info\n')
    for i in range(len(codes)):
        f.write('%s,%s,%s\n' % ((i+1),codes[i], infos[i]))
