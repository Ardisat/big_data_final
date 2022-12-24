def generate_meta_sql(meta_table_name, h_table_name, stg_table_name, scheme, meta_type, date):

	table_name = h_table_name.replace(f'"{scheme}"."', '').replace('"', "")
  
	if meta_type == 'HIST':
		sql = f"""
update {meta_table_name}
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('{date}', 'DD.MM.YYYY')) from {stg_table_name}), 
	(select last_update_dt from {meta_table_name} where scheme_name = '{scheme}' and table_name = '{h_table_name}')
)
where scheme_name = '{scheme}' and table_name = '{table_name}';
		"""
	else:
		sql = f"""
update {meta_table_name}
set last_update_dt = (select max(TO_TIMESTAMP('{date}', 'DD.MM.YYYY')) from {stg_table_name})
where scheme_name = '{scheme}' and table_name = '{table_name}' and (select max('{date}') from {h_table_name}) is not null;
    """
	return sql