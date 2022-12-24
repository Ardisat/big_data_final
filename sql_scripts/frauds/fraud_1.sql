INSERT INTO "p3"."ENV_REP_FRAUD"

SELECT DISTINCT ON (client.passport_num)
    transactions.transaction_date as event_dt,
	client.passport_num as passport,
	concat_ws(' ', client.last_name, client.first_name, client.patronymic) as fio,
	client.phone as phone,
	'Совершение операции при просроченном или заблокированном паспорте' as event_type,
	now() as report_dt
FROM
    "p3"."ENV_DWH_FACT_TRANSACTIONS" AS transactions, 
    "p3"."ENV_DWH_DIM_ACCOUNTS_HIST" AS account, 
    "p3"."ENV_DWH_DIM_CLIENTS_HIST"  AS client, 
    "p3"."ENV_DWH_DIM_CARDS_HIST"    AS cards
WHERE
    (
		cards.card_num     = transactions.card_num  AND
		account.account_id = cards.account_num      AND
		client.client_id   = account.client         AND

		client.passport_valid_to < transactions.transaction_date
	) OR
	(
		cards.card_num     = transactions.card_num  AND
		account.account_id = cards.account_num      AND
		client.client_id   = account.client         AND

		client.passport_valid_to IS NULL
	)