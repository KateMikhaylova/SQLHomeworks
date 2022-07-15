import sqlalchemy
from sqlalchemy.orm import sessionmaker
import json
from models import create_tables, Publisher, Book, Shop, Stock, Sale

if __name__ == '__main__':

    DSN = 'postgresql://postgres:postgres@localhost:5432/netology_db'
    engine = sqlalchemy.create_engine(DSN)

    create_tables(engine)

    Session = sessionmaker(bind=engine)
    session = Session()

    with open('tests_data.json') as f:
        info = json.load(f)

    models = {'publisher': Publisher,
              'book': Book,
              'shop': Shop,
              'stock': Stock,
              'sale': Sale
              }
    for element in info:
        session.add(models[element['model']](id=element['pk'], **element['fields']))
    session.commit()

    query = session.query(Shop)
    query = query.join(Stock, Stock.id_shop == Shop.id)
    query = query.join(Book, Book.id == Stock.id_book)
    query = query.join(Publisher, Publisher.id == Book.id_publisher)

    publ = input('Введите имя или идентификатор издателя: ')
    try:
        publ = int(publ)
        records = query.filter(Publisher.id == publ)
    except ValueError:
        records = query.filter(Publisher.name == publ)

    for shop in records:
        print(shop)

    session.close()
