DROP TABLE IF EXISTS "p3"."ENV_DWH_FACT_TRANSACTIONS";
CREATE TABLE "p3"."ENV_DWH_FACT_TRANSACTIONS" (
  "transaction_id" varchar(255) NOT NULL,
  "transaction_date" timestamp(6) NOT NULL,
  "amount" DECIMAL NOT NULL,
  "card_num" varchar(255) NOT NULL,
  "oper_type" varchar(255) NOT NULL,
  "oper_result" varchar(255) NOT NULL,
  "terminal" varchar(255) NOT NULL
);

DROP TABLE IF EXISTS "p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST";
CREATE TABLE "p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST" (
  "entry_dt" date NOT NULL,
  "passport_num" varchar(255) NOT NULL
);

insert into "p3"."ENV_META_TABLE" (scheme_name, table_name, last_update_dt) 
values ('p3', 'ENV_DWH_FACT_TRANSACTIONS', to_timestamp('1900-01-01', 'YYYY-MM-DD'));

insert into "p3"."ENV_META_TABLE" (scheme_name, table_name, last_update_dt) 
values ('p3', 'ENV_DWH_FACT_PASSPORT_BLACKLIST', to_timestamp('1900-01-01', 'YYYY-MM-DD'));