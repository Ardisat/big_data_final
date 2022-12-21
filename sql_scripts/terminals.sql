CREATE TABLE IF NOT EXISTS "p3"."ENV_DWH_FACT_TERMINALS" (
    "terminal_id" varchar(255) NOT NULL,
    "terminal_type" varchar(255) NOT NULL,
    "terminal_city" varchar(255) NOT NULL,
    "terminal_address" varchar(255) NOT NULL,
    CONSTRAINT "ENV_DWH_FACT_TERMINALS_pk" PRIMARY KEY ("terminal_id")
) WITH (
  OIDS=FALSE
);