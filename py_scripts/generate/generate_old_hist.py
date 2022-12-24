def generate_old_hist_sql(hist_table_name, hist_table_fields, stg_del_table_name, stg_del_table_fields):

    stg_del_id = stg_del_table_fields[0]
    hist_id = hist_table_fields[0]

    return f"""
update {hist_table_name}  tgt
set
    effective_to = now() - interval '1 minute'
where 
    1=1
    and effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') 
    and deleted_flg = 'N'
    and {hist_id} in (
            select
                t1.{hist_id}
            from {hist_table_name} t1
            left join {stg_del_table_name} t2
            on t1.{hist_id} = t2.{stg_del_id}
            where t2.{stg_del_id} is null );
    """