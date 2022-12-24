HOST     = '212.8.247.94'
PORT     = 5432
DATABASE = 'home'
USER     = 'student'
PASSWORD = 'qwerty'



SCHEME = 'p3'
PREFIX = 'ENV'


TABLES = {
    'STG': {
        'PASSPORT_BLACKLIST': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_PASSPORT_BLACKLIST"',
            'fields': ['passport_num', 'entry_dt']
        },
        'TERMINALS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_TERMINALS"',
            'fields': ['terminal_id', 'terminal_type', 'terminal_city', 'terminal_address']
        },
        'TRANSACTIONS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_TRANSACTIONS"',
            'fields': ['trans_id', 'trans_date', 'card_num', 'oper_type', 'amt', 'oper_result', 'terminal']
        },
        'ACCOUNTS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_ACCOUNTS"',
            'fields': ['account', 'valid_to', 'client']
        },
        'CARDS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_CARDS"',
            'fields': ['card_num', 'account']
        },
        'CLIENTS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_CLIENTS"',
            'fields': ['client_id', 'last_name', 'first_name', 'patronymic', 'date_of_birth', 'passport_num', 'passport_valid_to', 'phone']
        }
    },
    'STG_DEL': {
        'PASSPORT_BLACKLIST': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_DEL_PASSPORT_BLACKLIST"',
            'fields': ['passport_num']
        },
        'TERMINALS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_DEL_TERMINALS"',
            'fields': ['terminal_id']
        },
        'TRANSACTIONS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_DEL_TRANSACTIONS"',
            'fields': ['trans_id']
        },
        'ACCOUNTS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_DEL_ACCOUNTS"',
            'fields': ['account']
        },
        'CARDS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_DEL_CARDS"',
            'fields': ['card_num']
        },
        'CLIENTS': {
            'name': f'"{SCHEME}"."{PREFIX}_STG_DEL_CLIENTS"',
            'fields': ['client_id']
        }
    },
    'HIST': {
        'ACCOUNTS': {
            'name': f'"{SCHEME}"."{PREFIX}_DWH_DIM_ACCOUNTS_HIST"',
            'fields': ['account_id', 'valid_to', 'client', 'effective_from', 'effective_to', 'deleted_flg']
        },
        'CARDS': {
            'name': f'"{SCHEME}"."{PREFIX}_DWH_DIM_CARDS_HIST"',
            'fields': ['card_num', 'account_num', 'effective_from', 'effective_to', 'deleted_flg']
        },
        'TERMINALS': {
            'name': f'"{SCHEME}"."{PREFIX}_DWH_DIM_TERMINALS_HIST"',
            'fields': ['terminal_id', 'terminal_type', 'terminal_city', 'terminal_address', 'effective_from', 'effective_to', 'deleted_flg']
        },
        'CLIENTS': {
            'name': f'"{SCHEME}"."{PREFIX}_DWH_DIM_CLIENTS_HIST"',
            'fields': ['client_id', 'last_name', 'first_name', 'patronymic', 'date_of_birth', 'passport_num', 'passport_valid_to', 'phone', 'effective_from', 'effective_to', 'deleted_flg']
        }
    },
    'META': {
        'TABLE': {
            'name': f'"{SCHEME}"."{PREFIX}"',
            'fields': ['scheme_name', 'table_name', 'last_update_dt']
        }
    },
    'REP': {
        'FRAUD': {
            'name': f'"{SCHEME}"."{PREFIX}"',
            'fields': ['event_dt', 'passport', 'fio', 'phone', 'event_type', 'report_dt']
        }
    }
}


DWH_FACT_TRANSACTIONS       = '"p3"."ENV_DWH_FACT_TRANSACTIONS"'
DWH_FACT_PASSPORT_BLACKLIST = '"p3"."ENV_DWH_FACT_PASSPORT_BLACKLIST"'

ENV_META                    = '"p3"."ENV_META"'
ENV_REP_FRAUD               = '"p3"."ENV_REP_FRAUD"'     


EXCEL_FIELDS = {
    TABLES['STG']['TERMINALS']['name']:          'terminal_id, terminal_type, terminal_city, terminal_address',
    TABLES['STG']['PASSPORT_BLACKLIST']['name']: 'entry_dt, passport_num',
    TABLES['STG']['TRANSACTIONS']['name']:       'trans_id, trans_date, amt, card_num, oper_type, oper_result, terminal'
}