from config import *


def process_data(db):
    db.post(f'INSERT INTO {STG_TERMINALS_DEL} (id) select id from {STG_TERMINALS};')