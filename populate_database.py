from src.db_config import get_engine
from src.data_generator import(
    gerar_clientes,
    gerar_consultores,
    gerar_produtos,
    gerar_vendas_produtos,
    gerar_vendas_servicos)

def popular_banco():
    print("Gerando dados fictícios...\n")

    clientes = gerar_clientes(100)
    consultores = gerar_consultores(30)
    produtos = gerar_produtos(50)

    print("Conectando ao banco de dados...\n")
    engine = get_engine()

    try:
        # Inserir dados nas tabelas (ordem importa por causa das FKs)
        print("Inserindo clientes...")
        clientes.to_sql('clientes', engine, if_exists='append', index=False)
        print(f"{len(clientes)} clientes inseridos")
        
        print(" Inserindo consultores...")
        consultores.to_sql('consultores', engine, if_exists='append', index=False)
        print(f"{len(consultores)} consultores inseridos")
        
        print(" Inserindo produtos...")
        produtos.to_sql('produtos_sustentaveis', engine, if_exists='append', index=False)
        print(f"{len(produtos)} produtos inseridos")
        
        # Gerar vendas (precisa dos IDs dos clientes, consultores e produtos)
        print("\n Gerando vendas...")
        vendas_servicos = gerar_vendas_servicos(clientes, consultores, 200)
        vendas_produtos_df = gerar_vendas_produtos(clientes, produtos, 150)
        
        print("Inserindo vendas de serviços...")
        vendas_servicos.to_sql('vendas_servicos', engine, if_exists='append', index=False)
        print(f"{len(vendas_servicos)} vendas de serviços inseridas")
        
        print("Inserindo vendas de produtos...")
        vendas_produtos_df.to_sql('vendas_produtos', engine, if_exists='append', index=False)
        print(f"{len(vendas_produtos_df)} vendas de produtos inseridas")
        
        print("\n" + "="*50)
        print(" BANCO DE DADOS POPULADO COM SUCESSO!")
        print("="*50)
        
        # Verificar registros
        print("\n RESUMO:")
        import pandas as pd
        
        for tabela in ['clientes', 'consultores', 'produtos_sustentaveis', 
                       'vendas_servicos', 'vendas_produtos']:
            query = f"SELECT COUNT(*) as total FROM {tabela}"
            resultado = pd.read_sql(query, engine)
            print(f"   {tabela}: {resultado['total'][0]} registros")
        
    except Exception as e:
        print(f"\n Erro ao popular banco: {e}")
    
    finally:
        engine.dispose()

if __name__ == "__main__":
    popular_banco()