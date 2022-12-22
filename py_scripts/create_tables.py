def create_tables(db, sql_folder_name):
    path = f"{sql_folder_name}/stg_tables.sql"

    with open(path) as file:
        sql = file.read()
        db.post(sql)