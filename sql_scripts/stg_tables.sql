DROP TABLE IF EXISTS "p3"."ENV_STG_PASSPORT_BLACKLIST";
CREATE TABLE "p3"."ENV_STG_PASSPORT_BLACKLIST" (
    "passport_num" varchar(255) NOT NULL,
    "entry_dt" DATE NOT NULL
);

DROP TABLE IF EXISTS "p3"."ENV_STG_TERMINALS";
CREATE TABLE "p3"."ENV_STG_TERMINALS" (
    "terminal_id" varchar(255) NOT NULL,
    "terminal_type" varchar(255) NOT NULL,
    "terminal_city" varchar(255) NOT NULL,
    "terminal_address" varchar(255) NOT NULL
);

DROP TABLE IF EXISTS "p3"."ENV_STG_TRANSACTIONS";
CREATE TABLE "p3"."ENV_STG_TRANSACTIONS" (
    "trans_id" varchar(255) NOT NULL,
    "trans_date" DATE NOT NULL,
    "card_num" varchar(255) NOT NULL,
    "oper_type" varchar(255) NOT NULL,
    "amt" DECIMAL NOT NULL,
    "oper_result" varchar(255) NOT NULL,
    "terminal" varchar(255) NOT NULL
);


DROP TABLE IF EXISTS "p3"."ENV_STG_DEL_PASSPORT_BLACKLIST";
CREATE TABLE "p3"."ENV_STG_DEL_PASSPORT_BLACKLIST" ("id" varchar(255) NOT NULL);

DROP TABLE IF EXISTS "p3"."ENV_STG_DEL_TERMINALS";
CREATE TABLE "p3"."ENV_STG_DEL_TERMINALS" ("id" varchar(255) NOT NULL);

DROP TABLE IF EXISTS "p3"."ENV_STG_DEL_TRANSACTIONS";
CREATE TABLE "p3"."ENV_STG_DEL_TRANSACTIONS" ("id" varchar(255) NOT NULL);



DROP TABLE IF EXISTS "p3"."ENV_STG_ACCOUNTS";
CREATE TABLE "p3"."ENV_STG_ACCOUNTS" AS SELECT account, valid_to, client FROM bank.accounts;

DROP TABLE IF EXISTS "p3"."ENV_STG_CARDS";
CREATE TABLE "p3"."ENV_STG_CARDS" AS SELECT card_num, account FROM bank.cards;

DROP TABLE IF EXISTS "p3"."ENV_STG_CLIENTS";
CREATE TABLE "p3"."ENV_STG_CLIENTS" AS SELECT client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone FROM bank.clients;


DROP TABLE IF EXISTS "p3"."ENV_STG_DEL_ACCOUNTS";
CREATE TABLE "p3"."ENV_STG_DEL_ACCOUNTS" ("id" varchar(255) NOT NULL);

DROP TABLE IF EXISTS "p3"."ENV_STG_DEL_CARDS";
CREATE TABLE "p3"."ENV_STG_DEL_CARDS" ("id" varchar(255) NOT NULL);

DROP TABLE IF EXISTS "p3"."ENV_STG_DEL_CLIENTS";
CREATE TABLE "p3"."ENV_STG_DEL_CLIENTS" ("id" varchar(255) NOT NULL);