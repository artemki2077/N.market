import requests
from bs4 import BeautifulSoup as bs4
import multiprocessing
import json


class WishMaster:
    def __init__(self):
        pass

    def get_html(self, url):
        respons = requests.get(url)
        return bs4(respons.text, 'html.parser')

    def get_phones_pages(self, n):
        phones = []
        phones_pages = self.get_html(f'https://wishmaster.me/catalog/smartfony/?PAGEN_2={n}')
        phones_element = phones_pages.find_all('div', {'class': 'product-card'})
        company = ''
        name = ''
        for i in phones_element:
            try:
                company, *name = i.find('h3').text[8:].strip().split(' ')
                name = ' '.join(name).split('(')[0]

                price = i.find('span', {'class': 'product-card__content-price-actual'}).text.strip('\n')[5:]
                price = int(''.join(price.split()[:-1]))

                info = {}
                for li in i.find_all('li'):
                    key, value = li.text.strip('\n').split('\n')
                    info[key.strip()] = value.strip()
                phones.append({
                    'name': name,
                    'price': price,
                    'company': company,
                    'info': info
                })
            except BaseException as e:
                print(f'error, page: {n}, model: "{company} {name}": {e}')
        return phones

    def update(self):
        phones = []
        phones_pages = self.get_html('https://wishmaster.me/catalog/smartfony/')
        count_pages = int(phones_pages.find('span', {"class": "nums"}).find_all('a')[-1].text)
        with multiprocessing.Pool(53) as p:
            for i in p.map(self.get_phones_pages, list(range(1, count_pages+1))):
                phones += i
        json.dump(phones, open('test.json', 'w', encoding='utf8'), indent=4, ensure_ascii=False)


if __name__ == '__main__':
    WishMaster().update()