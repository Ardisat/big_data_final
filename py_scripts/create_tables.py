def create_tables(db, sql_folder_name):
    tables_to_create = [
        "/stg_tables.sql",
        "/fact_tables.sql",
        "/hist_tables.sql",
        "/fraud_table.sql",
        "/meta_table.sql"
    ]

    print('0. Подготовка данных, очистка и создание таблиц')

    for file_name in tables_to_create:
        path = f"{sql_folder_name}/{file_name}"

        with open(path) as file:
            sql = file.read()
            db.post(sql)

    print()