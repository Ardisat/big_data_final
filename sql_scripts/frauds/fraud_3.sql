INSERT INTO "p3"."ENV_REP_FRAUD"

SELECT DISTINCT ON (passport) event_dt, passport, fio, phone, event_type, report_dt FROM
(
	SELECT
		tr.transaction_date as event_dt,
		cl.passport_num as passport,
		concat_ws(' ', cl.last_name, cl.first_name, cl.patronymic) as fio,
		cl.phone as phone,
		'Совершение операций в разных городах в течение одного часа' as event_type,
		now() as report_dt,
		
		
		LAG(tr.transaction_date,  1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date) AS prev_time,
		tr.transaction_date,
		LEAD(tr.transaction_date, 1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date) AS next_time,
		
		LAG(te.terminal_city,     1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date) AS prev_city,
		te.terminal_city,
		LEAD(te.terminal_city,    1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date) AS next_city,
		
		CASE
			WHEN 
				(
					LAG(tr.transaction_date, 1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date) 
					IS NOT NULL AND 
					EXTRACT(
						HOUR FROM 
						tr.transaction_date 
						- 
						LAG(tr.transaction_date,  1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date)
					) < 1 AND 
					LAG(te.terminal_city, 1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date)
					<> 
					te.terminal_city
				) 
				OR 
				(
					LEAD(tr.transaction_date, 1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date) 
					IS NOT NULL AND 
					EXTRACT(
						HOUR FROM 
							LEAD(tr.transaction_date, 1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date)
							- 
							tr.transaction_date
					) < 1 AND 
					LEAD(te.terminal_city, 1) OVER(PARTITION BY tr.card_num ORDER BY tr.transaction_date) 
					<> 
					te.terminal_city
				) 
			THEN 'Fraud'
			ELSE 'Normal'
		END AS fraud_flag
		
	FROM 

		"p3"."ENV_DWH_FACT_TRANSACTIONS" AS tr,
		"p3"."ENV_DWH_DIM_TERMINALS_HIST" AS te,
		"p3"."ENV_DWH_DIM_CARDS_HIST" AS cr,
		"p3"."ENV_DWH_DIM_ACCOUNTS_HIST" AS ac,
		"p3"."ENV_DWH_DIM_CLIENTS_HIST" AS cl
		
	WHERE

		te.terminal_id = tr.terminal    AND
		
		cr.card_num    = tr.card_num    AND
		ac.account_id  = cr.account_num AND
		cl.client_id   = ac.client
) as data_table

WHERE fraud_flag = 'Fraud'