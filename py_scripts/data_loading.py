import pandas as pd
from config import *
from py_scripts.generate.generate_insert import generate_sql



def load_source_data(db, data_folder_name, date):
    print('2. Загрузка данных из файлов в базу')

    filename = "".join(date.split('.'))                                                 # делаем имя файла из даты

    pbl_path  = f"{data_folder_name}/passport_blacklist_{filename}.xlsx"                # путь к passport blacklist
    term_path = f"{data_folder_name}/terminals_{filename}.xlsx"                         # путь к terminals
    tran_path = f"{data_folder_name}/transactions_{filename}.txt"                       # путь к transacions

    load_to_db(db, pd.read_excel(term_path, engine='openpyxl'), TABLES['STG']['TERMINALS']['name'])          # загружаем данные terminals в базу
    load_to_db(db, pd.read_excel(pbl_path, engine='openpyxl'), TABLES['STG']['PASSPORT_BLACKLIST']['name'])  # загружаем данные passport blacklist в базу

    df = pd.read_csv(tran_path, delimiter = ";")
    comma2dot = lambda x: x.replace(',', '.')                                           # меняем запятую на точку для формата decimal в базе
    df['amount'] = df['amount'].map(comma2dot)

    load_to_db(db, df, TABLES['STG']['TRANSACTIONS']['name'])                           # загружаем данные transacions в базу
    print()


def load_to_db(db, df, table):                                                          # загрузка в базу сгенерированного sql
    sql = generate_sql(
        f"INSERT INTO {table} ({EXCEL_FIELDS[table]}) VALUES", 
        df.values.tolist()
    )
    db.post(sql)