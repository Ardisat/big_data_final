from config import *
from py_scripts.generate_hist import generate_hist_sql


def process_data(db, date):
    # Захват ключей для вычисления удаленных записей
    for table in TABLES['STG_DEL']:

        id           = TABLES['STG_DEL'][table]['fields'][0]
        stg_id       = TABLES['STG'][table]['fields'][0]
        stg_del_name = TABLES['STG_DEL'][table]['name']
        stg_name     = TABLES['STG'][table]['name']

        db.post(f"INSERT INTO {stg_del_name} ({id}) select {stg_id} from {stg_name};")
    
    # Запись данных в hist таблицы
    for table in TABLES['HIST']:
        hist_table_name = TABLES['HIST'][table]['name']
        hist_table_fields = TABLES['HIST'][table]['fields']

        stg_table_name = TABLES['STG'][table]['name']
        stg_table_fields = TABLES['STG'][table]['fields']

        hist_sql = generate_hist_sql(
            hist_table_name, 
            hist_table_fields, 
            stg_table_name,
            stg_table_fields,
            date
        )
        print()
        print(hist_sql)
        print()
        db.post(hist_sql)

    print()