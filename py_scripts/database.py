import psycopg2

class DataBase:
    logs_path = 'logs.sql'

    def __init__(self, host: str, port: int, database: str, user: str, password: str):
        self.__connection = psycopg2.connect(
            host=host, 
            port=port,
            database=database, 
            user=user,
            password=password
        )
        open(self.logs_path, 'w')

    def get(self, sql):
        with self.__connection.cursor() as cursor:
            cursor.execute(sql)
            return cursor.fetchall()


    def post(self, sql):
        if len(sql) < 500:
            self.logs = open(self.logs_path, 'a', encoding='utf-8')
            self.logs.write('\n\n' + sql + '\n\n')
            self.logs.close()

        with self.__connection.cursor() as cursor:
            cursor.execute(sql)
            cursor.execute('commit;')


    def __del__(self):
        self.__connection.close()