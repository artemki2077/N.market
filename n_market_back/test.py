from replit import db

print(db.keys())
for i in db.keys():
    print(db[i])