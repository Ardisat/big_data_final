import pandas as pd
from config import *
from py_scripts.generate_sql import generate_sql


fields = {
    STG_TERMINALS:          'terminal_id, terminal_type, terminal_city, terminal_address',
    STG_PASSPORT_BLACKLIST: 'entry_dt, passport_num',
    STG_TRANSACTIONS:       'trans_id, trans_date, amt, card_num, oper_type, oper_result, terminal'
}


def load_data(db, data_folder_name, dates):
    for date in dates:
        filename = "".join(date.split('.'))

        pbl_path  = f"{data_folder_name}/passport_blacklist_{filename}.xlsx"
        term_path = f"{data_folder_name}/terminals_{filename}.xlsx"
        tran_path = f"{data_folder_name}/transactions_{filename}.txt"

        load_to_db(db, pd.read_excel(term_path, engine='openpyxl'), STG_TERMINALS)
        load_to_db(db, pd.read_excel(pbl_path, engine='openpyxl'), STG_PASSPORT_BLACKLIST)

        df = pd.read_csv(tran_path, delimiter = ";")
        comma2dot = lambda x: x.replace(',', '.')
        df['amount'] = df['amount'].map(comma2dot)
        load_to_db(db, df, STG_TRANSACTIONS)

        db.post('commit;')
        break


def load_to_db(db, df, table):
    sql = generate_sql(
        f"INSERT INTO {table} ({fields[table]}) VALUES", 
        df.values.tolist()
    )
    db.post(sql)