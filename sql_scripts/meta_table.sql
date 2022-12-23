DROP TABLE IF EXISTS "p3"."ENV_META_TABLE";
CREATE TABLE "p3"."ENV_META_TABLE" (
    "scheme_name" varchar(255) NOT NULL,
    "table_name" varchar(255) NOT NULL,
    "last_update_dt" DATE NOT NULL
);