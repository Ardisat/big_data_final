from py_scripts import *
from config import *


def main():
    db = DataBase(
        host=HOST, 
        port=PORT,
        database=DATABASE, 
        user=USER, 
        password=PASSWORD,
    )  

    create_tables(db, 'sql_scripts')

    dates = ['01.03.2021', '02.03.2021', '03.03.2021']  

    for date in dates:
        print('-'*50)
        print()
        print("Дата:", date)
        print()

        clear_create_stg(db, 'sql_scripts')          # очистка STG слоя
        load_source_data(db, 'data', date)           # загрузка данных их файлов в базу
        process_data(db, date)                       # операции с данными внутри базы
        get_frauds(db, 'sql_scripts', date)          # мошенические операции
 

if __name__ == "__main__":
    main()