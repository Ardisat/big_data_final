from py_scripts import DataBase
from py_scripts import create_tables
from py_scripts import load_source_data
from py_scripts import process_data

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
        load_source_data(db, 'data', date)  # загрузка данных их файлов в базу
        process_data(db, date)              # операции с данными внутри базы
 

if __name__ == "__main__":
    main()