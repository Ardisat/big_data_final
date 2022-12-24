  update p3.tgss_meta
  set last_update_dt = coalesce((select max(create_dt) from p3.tgss_stg_accounts), (select last_update_dt from p3.tgss_meta where schema = 'p3' and table_name = 'tgss_dwh_dim_accounts_hist'))
  where schema = 'p3' and table_name = 'tgss_dwh_dim_accounts_hist';

   update p3.tgss_meta
  set last_update_dt = coalesce((select max(create_dt) from p3.tgss_stg_cards), (select last_update_dt from p3.tgss_meta where schema = 'p3' and table_name = 'tgss_dwh_dim_cards_hist'))
  where schema = 'p3' and table_name = 'tgss_dwh_dim_cards_hist';

   update p3.tgss_meta
  set last_update_dt = coalesce((select max(create_dt) from p3.tgss_stg_clients), (select last_update_dt from p3.tgss_meta where schema = 'p3' and table_name = 'tgss_dwh_dim_clients_hist'))
  where schema = 'p3' and table_name = 'tgss_dwh_dim_clients_hist';

    update p3.tgss_meta
  set last_update_dt = coalesce((select max(effective_from) from p3.tgss_dwh_dim_terminals_hist), (select last_update_dt from p3.tgss_meta where schema = 'p3' and table_name = 'tgss_dwh_dim_terminals_hist'))
  where schema = 'p3' and table_name = 'tgss_dwh_dim_terminals_hist';

   update p3.tgss_meta
  set last_update_dt = ( select max(entry_dt) from p3.tgss_stg_passport_blacklist )
  where schema = 'p3' and table_name = 'tgss_dwh_fact_passport_blacklist' and ( select max(entry_dt) from p3.tgss_dwh_fact_passport_blacklist ) is not null;


   update p3.tgss_meta
  set last_update_dt = ( select max(transaction_date) from p3.tgss_stg_transactions )
  where schema = 'p3' and table_name = 'tgss_dwh_fact_transactions' and ( select max(transaction_date) from p3.tgss_dwh_fact_transactions ) is not null;

