from config import *
from Progress import Bar

from py_scripts.generate.generate_hist import generate_hist_sql
from py_scripts.generate.generate_update_hist import generate_update_hist_sql
from py_scripts.generate.generate_del import generate_del_sql
from py_scripts.generate.generate_old_hist import generate_old_hist_sql


def process_data(db, date):
    logs = ''

    # Захват ключей для вычисления удаленных записей
    print('2. Захват ключей для вычисления удаленных записей')
    pb = Bar(len(TABLES['STG_DEL']))

    for table in TABLES['STG_DEL']:

        id           = TABLES['STG_DEL'][table]['fields'][0]
        stg_id       = TABLES['STG'][table]['fields'][0]
        stg_del_name = TABLES['STG_DEL'][table]['name']
        stg_name     = TABLES['STG'][table]['name']

        sql = f"INSERT INTO {stg_del_name} ({id}) select {stg_id} from {stg_name};"
        db.post(sql)
        logs += sql + "\n"
        pb.next()

    print()
    print(
        '3. Запись данных в hist таблицы\n',
        '  Обновление данных в детальном слое\n',
        '  Записываем удаленные записи\n',
        '  Апдейтим старые записи (закрываем актуальность)'
        )
    pb = Bar(len(TABLES['HIST']))

    for table in TABLES['HIST']:

        hist_table_name = TABLES['HIST'][table]['name']
        hist_table_fields = TABLES['HIST'][table]['fields']

        stg_table_name = TABLES['STG'][table]['name']
        stg_table_fields = TABLES['STG'][table]['fields']

        stg_del_table_name = TABLES['STG_DEL'][table]['name']
        stg_del_table_fields = TABLES['STG_DEL'][table]['fields']

        # Запись данных в hist таблицы
        hist_sql = generate_hist_sql(
            hist_table_name, 
            hist_table_fields, 
            stg_table_name,
            stg_table_fields,
            date
        )
        db.post(hist_sql)

        # Обновление данных в детальном слое
        update_hist_sql = generate_update_hist_sql(
            hist_table_name, 
            hist_table_fields, 
            stg_table_name,
            stg_table_fields,
            date
        )
        db.post(update_hist_sql)

        # Записываем удаленные записи
        del_sql = generate_del_sql(
            hist_table_name, 
            hist_table_fields, 
            stg_del_table_name,
            stg_del_table_fields,
            date
        )
        db.post(del_sql)

        # Апдейтим старые записи (закрываем актуальность)
        old_hist_sql = generate_old_hist_sql(
            hist_table_name, 
            hist_table_fields, 
            stg_del_table_name,
            stg_del_table_fields,
            date
        )
        db.post(old_hist_sql)

        pb.next()
        logs += hist_sql + '\n'
        logs += update_hist_sql + '\n'
        logs += del_sql + '\n'
        logs += old_hist_sql + '\n'
        logs += '\n\n\n\n\n'

    print()

    # Записть логов в файл
    fname = "-".join(date.split('.'))
    with open(f'sql_logs/{fname}.txt', 'w') as file:
        file.write(logs)