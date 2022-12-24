def generate_update_hist_sql(hist_table_name, hist_table_fields, stg_table_name, stg_table_fields, date):

    id     = hist_table_fields[0]
    stg_id = stg_table_fields[0]
    fields = ', '.join(hist_table_fields[:-2])
    select = ', '.join(['t1.' + i for i in stg_table_fields]) + f", '{date}'"

    return f"""
        update {hist_table_name} 
        set
            effective_to = '{date}' - interval '1 minute'
        from ( 
            select {select}
            from p3.XXXX_scd2_stg t1
            inner join p3.XXXX_scd2_hist t2
            on t1.id = t2.id
            where 
                t1.val <> t2.val or (t1.val is null and t2.val is not null) or (t1.val is not null and t2.val is null)
        ) upd
        where XXXX_scd2_hist.id = upd.id;

        insert into p3.XXXX_scd2_hist (id, val, effective_from)
        select
                t1.id,
                t1.val,
                t1.update_dt
        from p3.XXXX_scd2_stg t1
        inner join p3.XXXX_scd2_hist t2
        on t1.id = t2.id
        where 
        t1.val <> t2.val or (t1.val is null and t2.val is not null) or (t1.val is not null and t2.val is null);
    """