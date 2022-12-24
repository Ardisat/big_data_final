from Progress import Bar


def generate_sql(sql_base: str, values: tuple):
    pb = Bar(len(values))

    values_length = len(values)
    for i, row in enumerate(values):
        sql_base += " ("

        length = len(row)
        for j, value in enumerate(row):

            if j + 1 == length:
                if i + 1 == values_length:
                    sql_base += f"'{value}')"
                else:
                    sql_base += f"'{value}'),"
            else:
                sql_base += f"'{value}', "
        
        pb.next()

    return sql_base