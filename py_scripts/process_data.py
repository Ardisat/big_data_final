from config import *


def process_data(db):
    db.post(f'INSERT INTO {STG_DEL_TERMINALS} (id) select id from {STG_TERMINALS};')