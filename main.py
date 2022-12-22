from py_scripts import DataBase
from py_scripts import create_tables
from py_scripts import load_data
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

    dates = ['01.03.2021', '02.03.2021', '03.03.2021']

    create_tables(db, 'sql_scripts')
    load_data(db, 'data', dates)
    process_data(db)
 

if __name__ == "__main__":
    main()