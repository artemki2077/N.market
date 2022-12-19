import requests
from bs4 import BeautifulSoup as bs4
import multiprocessing
import json
from replit import db

count_process = 13


class WishMaster:

    def __init__(self):
        pass

    def get_html(self, url):
        respons = requests.get(url)
        return bs4(respons.text, 'html.parser')

    def get_pages(self, args):
        n, link = args
        phones = []
        phones_pages = self.get_html(f'{link}?PAGEN_2={n}')
        phones_element = phones_pages.find_all('div',
                                               {'class': 'product-card'})
        company = ''
        name = ''
        for i in phones_element:
            try:
                company, *name = i.find('h3').text[8:].strip().split(' ')
                name = ' '.join(name).split('(')[0]

                price = i.find('span', {
                    'class': 'product-card__content-price-actual'
                }).text.strip('\n')[5:]
                price = int(''.join(price.split()[:-1]))

                info = {}
                for li in i.find_all('li'):
                    key, value = li.text.strip('\n').split('\n')
                    info[key.strip()] = value.strip()
                div_link = i.find('a').get('href')
                img_src = i.find('img').get('src')
                phones.append({
                    'company': company,
                    'name': name,
                    'price': price,
                    'link': 'https://wishmaster.me' + div_link,
                    'shop': 'WishMaster',
                    'img_src': 'https://wishmaster.me' + img_src,
                    'info': info
                })
            except BaseException as e:
                print(f'error, page: {n}, model: "{company} {name}": {e}')
        return phones

    def get_all_from(self, link='https://wishmaster.me/catalog/smartfony/'):
        product = []
        product_pages = self.get_html(f'{link}')
        count_pages = int(
            product_pages.find('span', {
                "class": "nums"
            }).find_all('a')[-1].text)
        with multiprocessing.Pool(count_process) as p:
            for i in p.map(
                    self.get_pages,
                    list(
                        map(lambda x: [x, link],
                            list(range(1, count_pages + 1))))):
                product += i
        return product

    def get_phones(self):
        phones = []
        phones_pages = self.get_html(
            'https://wishmaster.me/catalog/smartfony/')
        count_pages = int(
            phones_pages.find('span', {
                "class": "nums"
            }).find_all('a')[-1].text)
        with multiprocessing.Pool(count_process) as p:
            for i in p.map(
                    self.get_pages,
                    list(map(lambda x: [
                        x,
                    ], list(range(1, count_pages + 1))))):
                phones += i
        return phones

    def get_monitory(self):
        monitory = []
        monitory_pages = self.get_html(
            'https://wishmaster.me/catalog/smartfony/')
        count_pages = int(
            monitory_pages.find('span', {
                "class": "nums"
            }).find_all('a')[-1].text)
        with multiprocessing.Pool(count_process) as p:
            for i in p.map(self.get_pages, list(range(1, count_pages + 1))):
                monitory += i
        return monitory

    def update(self):

        result = {
            'phones':
            self.get_all_from('https://wishmaster.me/catalog/smartfony/'),
            'monitory':
            self.get_all_from(
                'https://wishmaster.me/catalog/televizory_monitory/monitory/'),
            'audio':
            self.get_all_from('https://wishmaster.me/catalog/audio/'),
            'laptop':
            self.get_all_from('https://wishmaster.me/catalog/noutbuki/'),
        }
        # https://wishmaster.me/catalog/noutbuki/
        json.dump(result,
                  open('test.json', 'w', encoding='utf8'),
                  indent=4,
                  ensure_ascii=False)
        return result


def update():
    result = WishMaster().update()
    # print(result)
    for i in result:
        db[i] = result[i]


if __name__ == '__main__':
    update()
