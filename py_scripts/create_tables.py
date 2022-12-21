def create_tables(db, sql_folder_name):

    db.post('TRUNCATE "p3"."ENV_DWH_FACT_TERMINALS"')
    db.post('TRUNCATE "p3"."ENV_DWH_FACT_TRANSACTIONS"')
    db.post('TRUNCATE "p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST"')

    tables_to_create=(
        f"{sql_folder_name}/passport_blacklist.sql",
        f"{sql_folder_name}/terminals.sql",
        f"{sql_folder_name}/transactions.sql",
    )
    for path in tables_to_create:
        sql = open(path).read()
        db.post(sql)  