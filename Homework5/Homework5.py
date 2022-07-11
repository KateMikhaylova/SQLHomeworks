import psycopg2


class Client:

    def __init__(self, id, name, surname, email, phone=None):
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.phones = []
        if phone:
            self.phones.append(phone)

    def insert_client(self, conn):
        with conn.cursor() as cursor:
            cursor.execute('''
            INSERT INTO clients(id, name, surname, email)
            VALUES (%s, %s, %s, %s) RETURNING id;
            ''', (self.id, self.name, self.surname, self.email))
            if self.phones:
                for number in self.phones:
                    cursor.execute('''
                    INSERT INTO phones(number, client_id)
                    VALUES (%s, %s) RETURNING id;
                    ''', (number, self.id))
            cursor.fetchone()

    def add_phone(self, number, conn):
        self.phones.append(number)
        with conn.cursor() as cursor:
            cursor.execute('''
            INSERT INTO phones(number, client_id)
            VALUES (%s, %s) RETURNING id;
            ''', (number, self.id))
            cursor.fetchone()

    def _change_name(self, new_name, conn):
        self.name = new_name
        with conn.cursor() as cursor:
            cursor.execute('''
            UPDATE clients
            SET name = %s
            WHERE id = %s RETURNING id;
            ''', (new_name, self.id))
            cursor.fetchone()

    def _change_surname(self, new_surname, conn):
        self.surname = new_surname
        with conn.cursor() as cursor:
            cursor.execute('''
            UPDATE clients
            SET surname = %s
            WHERE id = %s RETURNING id;
            ''', (new_surname, self.id))
            cursor.fetchone()

    def _change_email(self, new_email, conn):
        self.email = new_email
        with conn.cursor() as cursor:
            cursor.execute('''
            UPDATE clients
            SET email = %s
            WHERE id = %s RETURNING id;
            ''', (new_email, self.id))
            cursor.fetchone()

    def _change_phone(self, new_phone, conn):
        with conn.cursor() as cursor:
            cursor.execute('''
            SELECT number 
            FROM phones
            WHERE client_id = %s
            ''', (self.id,))
            print(f'\nВ базе есть следующие номера {self.name} {self.surname}:', cursor.fetchall())
            old_phone = input('Введите номер телефона, который будет заменен на новый: ')
            cursor.execute('''
            UPDATE phones
            SET number = %s
            WHERE number = %s RETURNING id;
            ''', (new_phone, old_phone))
            self.phones.remove(old_phone)
            self.phones.append(new_phone)
            cursor.fetchone()

    def change_client(self, conn, new_name=None, new_surname=None, new_email=None, new_phone=None):
        if new_name:
            self._change_name(new_name, conn)
        if new_surname:
            self._change_surname(new_surname, conn)
        if new_email:
            self._change_email(new_email, conn)
        if new_phone:
            self._change_phone(new_phone, conn)

    def delete_one_phone(self, conn):
        with conn.cursor() as cursor:
            cursor.execute('''
            SELECT number 
            FROM phones
            WHERE client_id = %s
            ''', (self.id,))
            print(f'\nВ базе есть следующие номера {self.name} {self.surname}:', cursor.fetchall())
            number = input('Введите номер телефона, который будет удален: ')
            cursor.execute('''
            DELETE FROM phones
            WHERE number = %s;
            ''', (number,))
            self.phones.remove(number)

    def delete_all_phones(self, conn):
        with conn.cursor() as cursor:
            cursor.execute('''
            DELETE FROM phones
            WHERE client_id = %s;
            ''', (self.id,))
            self.phones.clear()

    def delete_client(self, conn):
        with conn.cursor() as cursor:
            self.delete_all_phones(conn)
            cursor.execute('''
            DELETE FROM clients
            WHERE id = %s;
            ''', (self.id,))


def delete_phones_table(conn):
    with conn.cursor() as cursor:
        cursor.execute('''
        DROP TABLE phones;
        ''')


def delete_clients_table(conn):
    with conn.cursor() as cursor:
        cursor.execute('''
        DROP TABLE clients;
        ''')


def create_client_table(conn):
    with conn.cursor() as cursor:
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS clients(
        id SERIAL PRIMARY KEY,
        name VARCHAR(40) NOT NULL,
        surname VARCHAR(40) NOT NULL,
        email VARCHAR(40) NOT NULL
        );
        ''')


def create_phone_table(conn):
    with conn.cursor() as cursor:
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS phones(
        id SERIAL PRIMARY KEY,
        number VARCHAR(20),
        client_id INTEGER NOT NULL REFERENCES clients(id)
        );
        ''')


def _search_by_name(conn, name):
    with conn.cursor() as cursor:
        cursor.execute('''
        SELECT * 
        FROM clients
        WHERE name = %s;
        ''', (name,))
        print(f'\nВ базе есть следующие клиенты с именем {name}:', cursor.fetchall())


def _search_by_surname(conn, surname):
    with conn.cursor() as cursor:
        cursor.execute('''
        SELECT * 
        FROM clients
        WHERE surname = %s;
        ''', (surname,))
        print(f'\nВ базе есть следующие клиенты с фамилией {surname}:', cursor.fetchall())


def _search_by_name_surname(conn, name, surname):
    with conn.cursor() as cursor:
        cursor.execute('''
        SELECT * 
        FROM clients
        WHERE name = %s AND surname = %s;
        ''', (name, surname))
        print(f'\nВ базе есть следующие клиенты с именем и фамилией {name} {surname}:', cursor.fetchall())


def _search_by_email(conn, email):
    with conn.cursor() as cursor:
        cursor.execute('''
        SELECT * 
        FROM clients
        WHERE email = %s;
        ''', (email,))
        print(f'\nВ базе есть следующие клиенты с электронной почтой {email}:', cursor.fetchall())


def _search_by_phone(conn, phone):
    with conn.cursor() as cursor:
        cursor.execute('''
        SELECT c.id, c.name, c.surname, c.email 
        FROM clients AS c
        INNER JOIN phones AS p
        ON c.id = p.client_id
        WHERE p.number = %s;
        ''', (phone,))
        print(f'\nВ базе есть следующие клиенты с телефоном {phone}:', cursor.fetchall())


def find_client(conn, name=None, surname=None, email=None, phone=None):
    if phone:
        _search_by_phone(conn, phone)
        return
    if email:
        _search_by_email(conn, email)
        return
    if name and surname:
        _search_by_name_surname(conn, name, surname)
        return
    if name:
        _search_by_name(conn, name)
        return
    if surname:
        _search_by_surname(conn, surname)
        return


with psycopg2.connect(database="netology_db", user="postgres", password="postgres") as conn:

    delete_phones_table(conn)
    delete_clients_table(conn)
    create_client_table(conn)
    create_phone_table(conn)
    conn.commit()

    ivan = Client(1, 'Иван', 'Иванов', 'ivan@gmail.com', '89119110000')
    ivan.insert_client(conn)
    petr = Client(2, 'Петр', 'Черненко', 'petr_and_anna@gmail.com')
    petr.insert_client(conn)
    anna = Client(3, 'Анна', 'Черненко', 'petr_and_anna@gmail.com')
    anna.insert_client(conn)
    anna2 = Client(4, 'Анна', 'Сидорова', 'sidorova@gmail.com')
    anna2.insert_client(conn)

    ivan.add_phone('89119111122', conn)
    ivan.add_phone('89119113344', conn)
    ivan.add_phone('89119115566', conn)
    ivan.add_phone('89119117788', conn)

    petr.add_phone('89219210001', conn)
    petr.add_phone('88122223413', conn)

    anna.add_phone('88129210002', conn)
    anna.add_phone('88122223413', conn)

    anna2.add_phone('89110000000', conn)
    anna2.add_phone('89111111111', conn)
    anna2.add_phone('89112222222', conn)

    find_client(conn, name='Анна')
    find_client(conn, surname='Черненко')
    find_client(conn, name='Анна', surname='Черненко')
    find_client(conn, phone='89110000000')
    find_client(conn, email='ivan@gmail.com')

    ivan.change_client(conn, new_name='John')
    ivan.change_client(conn, new_surname='Smith')
    ivan.change_client(conn, new_email='john@mail.ru')
    ivan.change_client(conn, new_phone='88122270339')
    # ivan.change_client(conn, new_name='John', new_surname='Smith', new_email='john@mail.ru', new_phone='88122270339')

    ivan.delete_one_phone(conn)
    anna2.delete_all_phones(conn)
    conn.commit()

    anna2.delete_client(conn)
    conn.commit()
