from src.db_config import get_connection

def create_tables():
    with open('sql/01_create_tables.sql','r', encoding='utf-8') as file:
        sql_script = file.read()


    conn = get_connection()
    cur = conn.cursor()

    try:
        print("Criando tabelas no banco de dados...")
        cur.execute(sql_script)
        conn.commit()
        print("Tabelas criadas com sucesso")

        #Verifica tabelas criadas
        cur.execute(""" 
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'public'
            ORDER BY table_name;
                """)
        
        tables = cur.fetchall()
        print(f"\n Tabelas no banco ({len(tables)}):")
        for table in tables:
            print(f" - {table[0]}")

    except Exception as e:
        conn.rollback()
        print(f" Erro ao criar tabelas: {e}")

    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    create_tables()