def generate_hist_sql(hist_table_name, hist_table_fields, stg_table_name, stg_table_fields, date):

    id     = hist_table_fields[0]
    stg_id = stg_table_fields[0]
    fields = ', '.join(hist_table_fields[:-2])
    select = ', '.join(['t1.' + i for i in stg_table_fields]) + f", '{date}'"

    return f'''
INSERT INTO {hist_table_name} ({fields})
SELECT {select}
FROM {stg_table_name} t1
LEFT JOIN {hist_table_name} t2
on t1.{stg_id} = t2.{id}
where t2.{id} is null;
    '''