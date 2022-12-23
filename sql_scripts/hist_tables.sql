DROP TABLE IF EXISTS "p3"."ENV_DWH_DIM_ACCOUNTS_HIST";
CREATE TABLE "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" (
  "account_id" varchar(255) NOT NULL,
  "valid_to" date NOT NULL,
  "client" varchar(255) NOT NULL,
  "effective_from" timestamp(6) DEFAULT to_timestamp('1901-01-01'::text, 'YYYY-MM-DD'::text),
  "effective_to" timestamp(6) DEFAULT to_timestamp('2999-12-31'::text, 'YYYY-MM-DD'::text),
  "deleted_flg" bool NOT NULL DEFAULT false
);

DROP TABLE IF EXISTS "p3"."ENV_DWH_DIM_CARDS_HIST";
CREATE TABLE "p3"."ENV_DWH_DIM_CARDS_HIST" (
  "card_num" varchar(255) NOT NULL,
  "account_num" varchar(255) NOT NULL,
  "effective_from" timestamp(6) DEFAULT to_timestamp('1900-01-01'::text, 'YYYY-MM-DD'::text),
  "effective_to" timestamp(6) NOT NULL DEFAULT to_timestamp('2999-12-31'::text, 'YYYY-MM-DD'::text),
  "deleted_flg" bool NOT NULL DEFAULT false
);

DROP TABLE IF EXISTS "p3"."ENV_DWH_DIM_TERMINALS_HIST";
CREATE TABLE "p3"."ENV_DWH_DIM_TERMINALS_HIST" (
  "terminal_id" varchar(255) NOT NULL,
  "terminal_type" varchar(255) NOT NULL,
  "terminal_city" varchar(255) NOT NULL,
  "terminal_address" varchar(255) NOT NULL,
  "effective_from" timestamp(6) DEFAULT to_timestamp('1900-01-01'::text, 'YYYY-MM-DD'::text),
  "effective_to" timestamp(6) NOT NULL DEFAULT to_timestamp('2999-12-31'::text, 'YYYY-MM-DD'::text),
  "deleted_flg" bool NOT NULL DEFAULT false
);

DROP TABLE IF EXISTS "p3"."ENV_DWH_DIM_CLIENTS_HIST";
CREATE TABLE "p3"."ENV_DWH_DIM_CLIENTS_HIST" (
  "client_id" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "first_name" varchar(255) NOT NULL,
  "patronymic" varchar(255) NOT NULL,
  "date_of_birth" date NOT NULL,
  "passport_num" varchar(255) NOT NULL,
  "passport_valid_to" date,
  "phone" varchar(255) NOT NULL,
  "effective_from" timestamp(6),
  "effective_to" timestamp(6) NOT NULL DEFAULT to_timestamp('2999-12-31'::text, 'YYYY-MM-DD'::text),
  "deleted_flg" bool NOT NULL DEFAULT false
);