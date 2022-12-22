import psycopg2

class DataBase:
    def __init__(self, host: str, port: int, database: str, user: str, password: str):
        self.__connection = psycopg2.connect(
            host=host, 
            port=port,
            database=database, 
            user=user,
            password=password
        )

    def get(self, sql):
        with self.__connection.cursor() as cursor:
            cursor.execute(sql)
            return cursor.fetchall()


    def post(self, sql):
        with self.__connection.cursor() as cursor:
            cursor.execute(sql)


    def postmany(self, sql, data):
        with self.__connection.cursor() as cursor:
            cursor.executemany(sql, data)


    def __del__(self):
        self.__connection.close()