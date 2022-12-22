DROP TABLE IF EXISTS "p3"."ENV_DWH_FACT_TRANSACTIONS";
CREATE TABLE "p3"."ENV_DWH_FACT_TRANSACTIONS" (
  "transaction_id" varchar(255) NOT NULL,
  "transaction_date" timestamp(6) NOT NULL,
  "amount" numeric(255,0) NOT NULL,
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