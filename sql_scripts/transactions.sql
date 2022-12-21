CREATE TABLE IF NOT EXISTS "p3"."ENV_DWH_FACT_TRANSACTIONS" (
    "trans_id" varchar(255) NOT NULL,
    "trans_date" DATE NOT NULL,
    "card_num" varchar(255) NOT NULL,
    "oper_type" varchar(255) NOT NULL,
    "amt" DECIMAL NOT NULL,
    "oper_result" varchar(255) NOT NULL,
    "terminal" varchar(255) NOT NULL
) WITH (
  OIDS=FALSE
);