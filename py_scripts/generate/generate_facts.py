def generate_facts_sql(fact_name, stg_name, fact_table_fields, stg_table_fields):

    fact_fields = ", ".join(fact_table_fields)
    stg_fields = ", ".join(stg_table_fields)

    sql = f'''
INSERT INTO {fact_name} ({fact_fields})
SELECT {stg_fields} FROM {stg_name};
    '''
    return sql