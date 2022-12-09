from fastapi import FastAPI
from fastapi.concurrency import run_in_threadpool
import uvicorn
import difflib
from time import sleep
from replit import db
import parse

app = FastAPI()
types = ['phones']
all_products = {
    'phones': []
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
        all_products = {
            'phones': []
        }
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
def search(company=None, name='', price_from=None, price_to=None, type=None, sorting='price', count=10):
    global all_products
    try:
        rtn = []
        if type:
            return {'result': True, 'answer': 'SUCCESS', 'products': sorted(all_products.get(type, []), key=lambda x: similarity(x['name'], name))[::-1][:count]}
    except BaseException as e:
        return {'result': False, 'answer': f'{e}'}

@app.get("/")
def home():
    return {"artem": "krut"}


def runing():
    global all_products
    all_products = {
        'phones': []
    }
    for tipe in all_products:
        all_products[tipe].extend(db.get(tipe, []))


if __name__ == "__main__":
    runing()
    uvicorn.run(app, host="0.0.0.0", port=5000, log_level="info")