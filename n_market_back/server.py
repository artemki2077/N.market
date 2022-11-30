from typing import Union
from fastapi import FastAPI
import parser
import uvicorn
from threading import Thread
from time import sleep
from replit import db
import parse

app = FastAPI()
types = ['phones']
all_products = {
    'phones': []
}


@app.get("/update")
def update():
    try:
        parse.update()
        print('start updating...')
    except BaseException as e:
        return {'result': False, 'answer': f'{e}'}
    return {'result': True, 'answer': 'START UPDATEING...'}


@app.get('/get_db')
def get_db():
    try:
        all_products = {
            'phones': []
        }
        for tipe in all_products:
            all_products[tipe].extend(db.get(tipe, []))
    except BaseException as e:
        return {'result': False, 'answer': f'{e}'}
    print(all_products)
    return {'result': True, 'answer': 'SUCCESS', 'products': all_products}


@app.get("/search")
def search(company=None, name=None, price_from=None, price_to=None, type=''):
    return {"Hello": "World"}

@app.get("/")
def home():
    return {"artem": "krut"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5000, log_level="info")