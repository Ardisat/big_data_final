DROP TABLE IF EXISTS "p3"."ENV_REP_FRAUD";
CREATE TABLE "p3"."ENV_REP_FRAUD" (
    "event_dt" DATE NOT NULL,
    "passport" varchar(255) NOT NULL,
    "fio" varchar(255) NOT NULL,
    "phone" varchar(255) NOT NULL,
    "event_type" varchar(255) NOT NULL,
    "report_dt" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP
);