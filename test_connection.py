from src.db_config import get_connection

try: 
    conn = get_connection()
    cur = conn.cursor()


    #Teste
    cur.execute('Select version();')
    version = cur.fetchone()

    print("Conexão com PostgreSQL bem sucedida!")
    print(f" Versão: {version[0][:80]}...")


    #Check no banco
    cur.execute("""
        SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = 'public';
                """)
    
    table_count = cur.fetchone()[0]
    print(f" Tabelas no banco: {table_count}")

    cur.close()
    conn.close()

except Exception as e:
    print(f" Erro na conexão: {e}")
    print("\n Verifique se:")
    print("   1. PostgreSQL está rodando: sudo systemctl status postgresql")
    print("   2. Usuário e senha estão corretos")
    print("   3. Banco 'ecoconsult_db' foi criado")