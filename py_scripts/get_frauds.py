from Progress import Bar

def get_frauds(db, sql_folder_name, date):
    print('7. Поиск мошенических операций')
    print()

    types_amount = 2

    pb = Bar(types_amount)
    for i in range(1, types_amount + 1):
        sql = open(f'{sql_folder_name}/frauds/fraud_{i}.sql', encoding='utf-8').read()

        db.post(sql)
        pb.next()

    print()
    