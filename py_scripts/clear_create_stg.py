def clear_create_stg(db, sql_folder_name):
    print('1. Очистка и создание таблиц STG')

    for file_name in ["stg_tables.sql"]:
        path = f"{sql_folder_name}/{file_name}"

        with open(path) as file:
            sql = file.read()
            db.post(sql)

    print()
