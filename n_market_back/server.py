from fastapi import FastAPI
from fastapi.concurrency import run_in_threadpool
import uvicorn
import difflib
from time import sleep
from replit import db
import parse

app = FastAPI()
types = ['phones', 'monitory', 'audio', 'laptop']
all_products = {
    'phones': [],
    'monitory': [],
    'audio': [],
    'laptop': []
}
def similarity(s1, s2):
  normalized1 = s1.lower()
  normalized2 = s2.lower()
  matcher = difflib.SequenceMatcher(None, normalized1, normalized2)
  return matcher.ratio()


@app.get("/update")
async def update():
    global all_products
    try:
        print('start updating...')
        rst = await run_in_threadpool(parse.update)
        print('finished updating!')
        all_products = {}
        for i in types:
            all_products[i] = []
        for tipe in all_products:
            all_products[tipe].extend(db.get(tipe, []))
    except BaseException as e:
        return {'result': False, 'answer': f'{e}'}
    return {'result': True, 'answer': 'SUCCESS', 'products': all_products}

@app.get('/get_prod')
def get_prod(name=None):
    return {'result': None}

@app.get('/get_all')
def get_db(type=None, sorting='price'):
    global all_products
    return {'result': True, 'answer': 'SUCCESS', 'products': sorted(all_products.get(type, []), key = lambda x: x[sorting])}


@app.get("/search")
def search(company=None, name='', price_from=None, price_to=None, type=None, sorting='price', count=25):
    global all_products
    try:
        print()
        if not price_from:
            price_from = 0
        else:
            price_from = int(price_from)
        if not price_to:
            price_to = 999999999999999999999999999999
        else:
            price_to = int(price_to)
        if not company:
            company = None
            
        rtn = []
        if type:
            rtn = sorted(all_products.get(type, []), key=lambda x: similarity(x['name'], name))[::-1][:count]
            
        else:
            for type in all_products:
                rtn.extend(all_products.get(type, []))
            rtn.sort(key=lambda x: similarity(x['name'], name), reverse=True)
        print(price_from, price_to, company, type, name)
        rtn = list(filter(lambda x: price_from <= x['price'] <= price_to and (True if not company else x['company'] == company), rtn))
        return {'result': True, 'answer': 'SUCCESS', 'products': rtn}
    except BaseException as e:
        return {'result': False, 'answer': f'{e}'}

@app.get("/")
def home():
    return {"NIKITA": "krut"}


def runing():
    global all_products
    all_products = {}
    for i in types:
        all_products[i] = []
    for tipe in all_products:
        all_products[tipe].extend(db.get(tipe, []))


if __name__ == "__main__":
    runing()
    uvicorn.run(app, host="0.0.0.0", port=5000, log_level="info")