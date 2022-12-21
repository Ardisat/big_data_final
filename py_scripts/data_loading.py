import pandas as pd
from config import *
from Progress import Bar


def load_data(db, data_folder_name, dates):
    pb = Bar(len(dates))

    for date in dates:
        filename = "".join(date.split('.'))

        passport_blacklist_path = f"{data_folder_name}/passport_blacklist_{filename}.xlsx"
        terminals_path          = f"{data_folder_name}/terminals_{filename}.xlsx"
        transactions_path       = f"{data_folder_name}/transactions_{filename}.txt"

        post_passport_blacklist_from_excel(db, passport_blacklist_path)
        post_terminals_from_excel(db, terminals_path)
        post_transactions_from_txt(db, transactions_path)

        pb.next()
        break


def post_passport_blacklist_from_excel(db, passport_blacklist_path):
    df = pd.read_excel(passport_blacklist_path, engine='openpyxl')
    db.postmany(
        f"INSERT INTO {PASSPORT_BLACKLIST} (entry_dt, passport_num) VALUES (%s, %s)", 
        df.values.tolist()
    )


def post_terminals_from_excel(db, terminals_path):
    df = pd.read_excel(terminals_path, engine='openpyxl')
    db.postmany(
        f"INSERT INTO {TERMINALS} (terminal_id, terminal_type, terminal_city, terminal_address) VALUES (%s, %s, %s, %s)", 
        df.values.tolist()
    )

def post_transactions_from_txt(db, transactions_path):
    df = pd.read_csv(transactions_path, delimiter = ";")

    comma2dot = lambda x: x.replace(',', '.')
    df['amount'] = df['amount'].map(comma2dot)

    db.postmany(
        f"INSERT INTO {TRANSACTIONS} (trans_id, trans_date, amt, card_num, oper_type, oper_result, terminal) VALUES (%s, %s, %s, %s, %s, %s, %s)", 
        df.values.tolist()
    )