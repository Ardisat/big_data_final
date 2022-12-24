

DROP TABLE IF EXISTS "p3"."ENV_META_TABLE";
CREATE TABLE "p3"."ENV_META_TABLE" (
    "scheme_name" varchar(255) NOT NULL,
    "table_name" varchar(255) NOT NULL,
    "last_update_dt" DATE NOT NULL
);



DROP TABLE IF EXISTS "p3"."ENV_REP_FRAUD";
CREATE TABLE "p3"."ENV_REP_FRAUD" (
    "event_dt" DATE NOT NULL,
    "passport" varchar(255) NOT NULL,
    "fio" varchar(255) NOT NULL,
    "phone" varchar(255) NOT NULL,
    "event_type" varchar(255) NOT NULL,
    "report_dt" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP
);



INSERT INTO "p3"."ENV_STG_PASSPORT_BLACKLIST" (entry_dt, passport_num) VALUES ('2021-03-01 00:00:00', '9933 106914'), ('2021-03-01 00:00:00', '6915 535193'), ('2021-03-01 00:00:00', '5385 691850'), ('2021-03-01 00:00:00', '8683 912237'), ('2021-03-01 00:00:00', '8340 525086'), ('2021-03-01 00:00:00', '3110 700486'), ('2021-03-01 00:00:00', '3384 214650')



INSERT INTO "p3"."ENV_STG_DEL_PASSPORT_BLACKLIST" (passport_num) select passport_num from "p3"."ENV_STG_PASSPORT_BLACKLIST";



INSERT INTO "p3"."ENV_STG_DEL_TERMINALS" (terminal_id) select terminal_id from "p3"."ENV_STG_TERMINALS";



INSERT INTO "p3"."ENV_STG_DEL_TRANSACTIONS" (trans_id) select trans_id from "p3"."ENV_STG_TRANSACTIONS";



INSERT INTO "p3"."ENV_STG_DEL_ACCOUNTS" (account) select account from "p3"."ENV_STG_ACCOUNTS";



INSERT INTO "p3"."ENV_STG_DEL_CARDS" (card_num) select card_num from "p3"."ENV_STG_CARDS";



INSERT INTO "p3"."ENV_STG_DEL_CLIENTS" (client_id) select client_id from "p3"."ENV_STG_CLIENTS";




INSERT INTO "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" (account_id, valid_to, client)
SELECT t1.account, t1.valid_to, t1.client
FROM "p3"."ENV_STG_ACCOUNTS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" t2
on t1.account = t2.account_id
where t2.account_id is null;
    




insert into "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" (account_id, valid_to, client, effective_from, deleted_flg)
select t1.account_id, t1.valid_to, t1.client, TO_TIMESTAMP('01.03.2021', 'DD.MM.YYYY'), 'Y'
from "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" t1
left join "p3"."ENV_STG_DEL_ACCOUNTS" t2
on t1.account_id = t2.account
where t1.effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') and t2.account is null and t1.deleted_flg = 'N';
    




INSERT INTO "p3"."ENV_DWH_DIM_CARDS_HIST" (card_num, account_num)
SELECT t1.card_num, t1.account
FROM "p3"."ENV_STG_CARDS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_CARDS_HIST" t2
on t1.card_num = t2.card_num
where t2.card_num is null;
    




insert into "p3"."ENV_DWH_DIM_CARDS_HIST" (card_num, account_num, effective_from, deleted_flg)
select t1.card_num, t1.account_num, TO_TIMESTAMP('01.03.2021', 'DD.MM.YYYY'), 'Y'
from "p3"."ENV_DWH_DIM_CARDS_HIST" t1
left join "p3"."ENV_STG_DEL_CARDS" t2
on t1.card_num = t2.card_num
where t1.effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') and t2.card_num is null and t1.deleted_flg = 'N';
    




update "p3"."ENV_DWH_DIM_CARDS_HIST"  tgt
set
    effective_to = TO_TIMESTAMP('01.03.2021', 'DD.MM.YYYY') - interval '1 minute'
where 
    1=1
    and effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') 
    and deleted_flg = 'N'
    and card_num in (
            select
                t1.card_num
            from "p3"."ENV_DWH_DIM_CARDS_HIST" t1
            left join "p3"."ENV_STG_DEL_CARDS" t2
            on t1.card_num = t2.card_num
            where t2.card_num is null );
    




INSERT INTO "p3"."ENV_DWH_DIM_TERMINALS_HIST" (terminal_id, terminal_type, terminal_city, terminal_address)
SELECT t1.terminal_id, t1.terminal_type, t1.terminal_city, t1.terminal_address
FROM "p3"."ENV_STG_TERMINALS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_TERMINALS_HIST" t2
on t1.terminal_id = t2.terminal_id
where t2.terminal_id is null;
    




INSERT INTO "p3"."ENV_DWH_DIM_CLIENTS_HIST" (client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone)
SELECT t1.client_id, t1.last_name, t1.first_name, t1.patronymic, t1.date_of_birth, t1.passport_num, t1.passport_valid_to, t1.phone
FROM "p3"."ENV_STG_CLIENTS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_CLIENTS_HIST" t2
on t1.client_id = t2.client_id
where t2.client_id is null;
    




INSERT INTO "p3"."ENV_DWH_FACT_TRANSACTIONS" (transaction_id, transaction_date, card_num, oper_type, amount, oper_result, terminal)
SELECT trans_id, trans_date, card_num, oper_type, amt, oper_result, terminal FROM "p3"."ENV_STG_TRANSACTIONS";
    




INSERT INTO "p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST" (passport_num, entry_dt)
SELECT passport_num, entry_dt FROM "p3"."ENV_STG_PASSPORT_BLACKLIST";
    




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('01.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_ACCOUNTS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_ACCOUNTS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_ACCOUNTS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('01.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_CARDS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_CARDS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_CARDS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('01.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_TERMINALS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_TERMINALS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_TERMINALS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('01.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_CLIENTS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_CLIENTS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_CLIENTS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = (select max(TO_TIMESTAMP('01.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_TRANSACTIONS")
where scheme_name = 'p3' and table_name = 'ENV_DWH_FACT_TRANSACTIONS' and (select max('01.03.2021') from "p3"."ENV_DWH_FACT_TRANSACTIONS") is not null;
    




update "p3"."ENV_META_TABLE"
set last_update_dt = (select max(TO_TIMESTAMP('01.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_PASSPORT_BLACKLIST")
where scheme_name = 'p3' and table_name = 'ENV_DWH_FACT_PASSPORT_BLACKLIST' and (select max('01.03.2021') from "p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST") is not null;
    



INSERT INTO "p3"."ENV_STG_DEL_PASSPORT_BLACKLIST" (passport_num) select passport_num from "p3"."ENV_STG_PASSPORT_BLACKLIST";



INSERT INTO "p3"."ENV_STG_DEL_TERMINALS" (terminal_id) select terminal_id from "p3"."ENV_STG_TERMINALS";



INSERT INTO "p3"."ENV_STG_DEL_TRANSACTIONS" (trans_id) select trans_id from "p3"."ENV_STG_TRANSACTIONS";



INSERT INTO "p3"."ENV_STG_DEL_ACCOUNTS" (account) select account from "p3"."ENV_STG_ACCOUNTS";



INSERT INTO "p3"."ENV_STG_DEL_CARDS" (card_num) select card_num from "p3"."ENV_STG_CARDS";



INSERT INTO "p3"."ENV_STG_DEL_CLIENTS" (client_id) select client_id from "p3"."ENV_STG_CLIENTS";




INSERT INTO "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" (account_id, valid_to, client)
SELECT t1.account, t1.valid_to, t1.client
FROM "p3"."ENV_STG_ACCOUNTS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" t2
on t1.account = t2.account_id
where t2.account_id is null;
    




insert into "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" (account_id, valid_to, client, effective_from, deleted_flg)
select t1.account_id, t1.valid_to, t1.client, TO_TIMESTAMP('02.03.2021', 'DD.MM.YYYY'), 'Y'
from "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" t1
left join "p3"."ENV_STG_DEL_ACCOUNTS" t2
on t1.account_id = t2.account
where t1.effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') and t2.account is null and t1.deleted_flg = 'N';
    




INSERT INTO "p3"."ENV_DWH_DIM_CARDS_HIST" (card_num, account_num)
SELECT t1.card_num, t1.account
FROM "p3"."ENV_STG_CARDS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_CARDS_HIST" t2
on t1.card_num = t2.card_num
where t2.card_num is null;
    




insert into "p3"."ENV_DWH_DIM_CARDS_HIST" (card_num, account_num, effective_from, deleted_flg)
select t1.card_num, t1.account_num, TO_TIMESTAMP('02.03.2021', 'DD.MM.YYYY'), 'Y'
from "p3"."ENV_DWH_DIM_CARDS_HIST" t1
left join "p3"."ENV_STG_DEL_CARDS" t2
on t1.card_num = t2.card_num
where t1.effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') and t2.card_num is null and t1.deleted_flg = 'N';
    




update "p3"."ENV_DWH_DIM_CARDS_HIST"  tgt
set
    effective_to = TO_TIMESTAMP('02.03.2021', 'DD.MM.YYYY') - interval '1 minute'
where 
    1=1
    and effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') 
    and deleted_flg = 'N'
    and card_num in (
            select
                t1.card_num
            from "p3"."ENV_DWH_DIM_CARDS_HIST" t1
            left join "p3"."ENV_STG_DEL_CARDS" t2
            on t1.card_num = t2.card_num
            where t2.card_num is null );
    




INSERT INTO "p3"."ENV_DWH_DIM_TERMINALS_HIST" (terminal_id, terminal_type, terminal_city, terminal_address)
SELECT t1.terminal_id, t1.terminal_type, t1.terminal_city, t1.terminal_address
FROM "p3"."ENV_STG_TERMINALS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_TERMINALS_HIST" t2
on t1.terminal_id = t2.terminal_id
where t2.terminal_id is null;
    




INSERT INTO "p3"."ENV_DWH_DIM_CLIENTS_HIST" (client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone)
SELECT t1.client_id, t1.last_name, t1.first_name, t1.patronymic, t1.date_of_birth, t1.passport_num, t1.passport_valid_to, t1.phone
FROM "p3"."ENV_STG_CLIENTS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_CLIENTS_HIST" t2
on t1.client_id = t2.client_id
where t2.client_id is null;
    




INSERT INTO "p3"."ENV_DWH_FACT_TRANSACTIONS" (transaction_id, transaction_date, card_num, oper_type, amount, oper_result, terminal)
SELECT trans_id, trans_date, card_num, oper_type, amt, oper_result, terminal FROM "p3"."ENV_STG_TRANSACTIONS";
    




INSERT INTO "p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST" (passport_num, entry_dt)
SELECT passport_num, entry_dt FROM "p3"."ENV_STG_PASSPORT_BLACKLIST";
    




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('02.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_ACCOUNTS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_ACCOUNTS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_ACCOUNTS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('02.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_CARDS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_CARDS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_CARDS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('02.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_TERMINALS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_TERMINALS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_TERMINALS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('02.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_CLIENTS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_CLIENTS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_CLIENTS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = (select max(TO_TIMESTAMP('02.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_TRANSACTIONS")
where scheme_name = 'p3' and table_name = 'ENV_DWH_FACT_TRANSACTIONS' and (select max('02.03.2021') from "p3"."ENV_DWH_FACT_TRANSACTIONS") is not null;
    




update "p3"."ENV_META_TABLE"
set last_update_dt = (select max(TO_TIMESTAMP('02.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_PASSPORT_BLACKLIST")
where scheme_name = 'p3' and table_name = 'ENV_DWH_FACT_PASSPORT_BLACKLIST' and (select max('02.03.2021') from "p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST") is not null;
    



INSERT INTO "p3"."ENV_STG_DEL_PASSPORT_BLACKLIST" (passport_num) select passport_num from "p3"."ENV_STG_PASSPORT_BLACKLIST";



INSERT INTO "p3"."ENV_STG_DEL_TERMINALS" (terminal_id) select terminal_id from "p3"."ENV_STG_TERMINALS";



INSERT INTO "p3"."ENV_STG_DEL_TRANSACTIONS" (trans_id) select trans_id from "p3"."ENV_STG_TRANSACTIONS";



INSERT INTO "p3"."ENV_STG_DEL_ACCOUNTS" (account) select account from "p3"."ENV_STG_ACCOUNTS";



INSERT INTO "p3"."ENV_STG_DEL_CARDS" (card_num) select card_num from "p3"."ENV_STG_CARDS";



INSERT INTO "p3"."ENV_STG_DEL_CLIENTS" (client_id) select client_id from "p3"."ENV_STG_CLIENTS";




INSERT INTO "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" (account_id, valid_to, client)
SELECT t1.account, t1.valid_to, t1.client
FROM "p3"."ENV_STG_ACCOUNTS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" t2
on t1.account = t2.account_id
where t2.account_id is null;
    




insert into "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" (account_id, valid_to, client, effective_from, deleted_flg)
select t1.account_id, t1.valid_to, t1.client, TO_TIMESTAMP('03.03.2021', 'DD.MM.YYYY'), 'Y'
from "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" t1
left join "p3"."ENV_STG_DEL_ACCOUNTS" t2
on t1.account_id = t2.account
where t1.effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') and t2.account is null and t1.deleted_flg = 'N';
    




INSERT INTO "p3"."ENV_DWH_DIM_CARDS_HIST" (card_num, account_num)
SELECT t1.card_num, t1.account
FROM "p3"."ENV_STG_CARDS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_CARDS_HIST" t2
on t1.card_num = t2.card_num
where t2.card_num is null;
    




insert into "p3"."ENV_DWH_DIM_CARDS_HIST" (card_num, account_num, effective_from, deleted_flg)
select t1.card_num, t1.account_num, TO_TIMESTAMP('03.03.2021', 'DD.MM.YYYY'), 'Y'
from "p3"."ENV_DWH_DIM_CARDS_HIST" t1
left join "p3"."ENV_STG_DEL_CARDS" t2
on t1.card_num = t2.card_num
where t1.effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') and t2.card_num is null and t1.deleted_flg = 'N';
    




update "p3"."ENV_DWH_DIM_CARDS_HIST"  tgt
set
    effective_to = TO_TIMESTAMP('03.03.2021', 'DD.MM.YYYY') - interval '1 minute'
where 
    1=1
    and effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') 
    and deleted_flg = 'N'
    and card_num in (
            select
                t1.card_num
            from "p3"."ENV_DWH_DIM_CARDS_HIST" t1
            left join "p3"."ENV_STG_DEL_CARDS" t2
            on t1.card_num = t2.card_num
            where t2.card_num is null );
    




INSERT INTO "p3"."ENV_DWH_DIM_TERMINALS_HIST" (terminal_id, terminal_type, terminal_city, terminal_address)
SELECT t1.terminal_id, t1.terminal_type, t1.terminal_city, t1.terminal_address
FROM "p3"."ENV_STG_TERMINALS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_TERMINALS_HIST" t2
on t1.terminal_id = t2.terminal_id
where t2.terminal_id is null;
    




INSERT INTO "p3"."ENV_DWH_DIM_CLIENTS_HIST" (client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone)
SELECT t1.client_id, t1.last_name, t1.first_name, t1.patronymic, t1.date_of_birth, t1.passport_num, t1.passport_valid_to, t1.phone
FROM "p3"."ENV_STG_CLIENTS" t1
LEFT JOIN "p3"."ENV_DWH_DIM_CLIENTS_HIST" t2
on t1.client_id = t2.client_id
where t2.client_id is null;
    




INSERT INTO "p3"."ENV_DWH_FACT_TRANSACTIONS" (transaction_id, transaction_date, card_num, oper_type, amount, oper_result, terminal)
SELECT trans_id, trans_date, card_num, oper_type, amt, oper_result, terminal FROM "p3"."ENV_STG_TRANSACTIONS";
    




INSERT INTO "p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST" (passport_num, entry_dt)
SELECT passport_num, entry_dt FROM "p3"."ENV_STG_PASSPORT_BLACKLIST";
    




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('03.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_ACCOUNTS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_ACCOUNTS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_ACCOUNTS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('03.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_CARDS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_CARDS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_CARDS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('03.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_TERMINALS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_TERMINALS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_TERMINALS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = coalesce(
	(select max(TO_TIMESTAMP('03.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_CLIENTS"), 
	(select last_update_dt from "p3"."ENV_META_TABLE" where scheme_name = 'p3' and table_name = '"p3"."ENV_DWH_DIM_CLIENTS_HIST"')
)
where scheme_name = 'p3' and table_name = 'ENV_DWH_DIM_CLIENTS_HIST';
		




update "p3"."ENV_META_TABLE"
set last_update_dt = (select max(TO_TIMESTAMP('03.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_TRANSACTIONS")
where scheme_name = 'p3' and table_name = 'ENV_DWH_FACT_TRANSACTIONS' and (select max('03.03.2021') from "p3"."ENV_DWH_FACT_TRANSACTIONS") is not null;
    




update "p3"."ENV_META_TABLE"
set last_update_dt = (select max(TO_TIMESTAMP('03.03.2021', 'DD.MM.YYYY')) from "p3"."ENV_STG_PASSPORT_BLACKLIST")
where scheme_name = 'p3' and table_name = 'ENV_DWH_FACT_PASSPORT_BLACKLIST' and (select max('03.03.2021') from "p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST") is not null;
    

