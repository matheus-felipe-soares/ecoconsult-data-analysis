import psycopg2
from sqlalchemy import create_engine


#Configurações do banco de dados
DB_CONFIG = {
    'host': 'localhost',
    'database': 'ecoconsult_db',
    'user': 'ecoconsult_user',
    'password': 'celular_2025',
    'port': '5432'
}

def get_connection_string():
    return f"postgresql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"

def get_engine():
    return create_engine(get_connection_string())

def get_connection():
    return psycopg2.connect(
        host=DB_CONFIG['host'],
        database=DB_CONFIG['database'],
        user=DB_CONFIG['user'],
        password=DB_CONFIG['password'],
        port=DB_CONFIG['port']
    )

