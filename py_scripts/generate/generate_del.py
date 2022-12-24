def generate_del_sql(hist_table_name, hist_table_fields, stg_del_table_name, stg_del_table_fields, date):

    hist_id     = hist_table_fields[0]
    stg_del_id  = stg_del_table_fields[0]
    hist_fields = ', '.join([i for i in hist_table_fields if i != 'effective_to'])
    select      = ', '.join(['t1.' + i for i in hist_table_fields[:-3]]) + f", TO_TIMESTAMP('{date}', 'DD.MM.YYYY'), 'Y'"

    return f"""
insert into {hist_table_name} ({hist_fields})
select {select}
from {hist_table_name} t1
left join {stg_del_table_name} t2
on t1.{hist_id} = t2.{stg_del_id}
where t1.effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') and t2.{stg_del_id} is null and t1.deleted_flg = 'N';
    """