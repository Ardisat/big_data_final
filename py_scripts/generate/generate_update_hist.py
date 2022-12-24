def generate_update_hist_sql(hist_table_name, hist_table_fields, stg_table_name, stg_table_fields, date):

    hist_fields = ', '.join(hist_table_fields[:-3])
    stg_id      = stg_table_fields[0]
    hist_id     = hist_table_fields[0]
    select      = ', '.join(['t1.' + i for i in stg_table_fields]) + f", TO_TIMESTAMP('{date}', 'DD.MM.YYYY') effective_from"
    select_ins  = ', '.join(['t1.' + i for i in stg_table_fields])

    where = []

    for i in range(len(stg_table_fields)):
        if i == 0:
            continue

        stg_field = stg_table_fields[i]
        hist_field = hist_table_fields[i]

        row = f"(t1.{stg_field} <> t2.{hist_field} or (t1.{stg_field} is null and t2.{hist_field} is not null) or (t1.{stg_field} is not null and t2.{hist_field} is null))"
        where.append(row)

    where = " or\n".join(where)

    sql = f"""
update {hist_table_name} 
set
    effective_to = upd.effective_from - interval '1 minute'
from ( 
    select {select}
    from {stg_table_name} t1
    inner join {hist_table_name} t2
    on t1.{stg_id} = t2.{hist_id}
    where {where}
) upd
where {hist_table_name}.{hist_id} = upd.{stg_id};


insert into {hist_table_name} ({hist_fields})
select {select_ins}
from {stg_table_name} t1
inner join {hist_table_name} t2
on t1.{stg_id} = t2.{hist_id}
where {where};
    """
    return sql