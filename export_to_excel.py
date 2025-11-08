import pandas as pd
from src.db_config import get_engine
import os

def exportar_para_excel():
    """Exporta todas as tabelas para arquivos Excel"""
    
    print("="*60)
    print(" EXPORTANDO DADOS PARA EXCEL")
    print("="*60)
    
    # Criar pasta se não existir
    os.makedirs('data/raw', exist_ok=True)
    
    engine = get_engine()
    
    # Tabelas para exportar
    tabelas = [
        'clientes',
        'consultores',
        'produtos_sustentaveis',
        'vendas_servicos',
        'vendas_produtos'
    ]
    
    for tabela in tabelas:
        print(f"\n Exportando {tabela}...")
        
        # Ler do banco
        df = pd.read_sql(f"SELECT * FROM {tabela}", engine)
        
        # Exportar para Excel
        arquivo = f'data/raw/{tabela}.xlsx'
        df.to_excel(arquivo, index=False, engine='openpyxl')
        
        print(f"    {len(df)} registros salvos em {arquivo}")
    
    print("\n" + "="*60)
    print(" TODOS OS DADOS EXPORTADOS COM SUCESSO!")
    print("="*60)
    print(f"\n Arquivos salvos em: data/raw/")
    
    engine.dispose()

if __name__ == "__main__":
    exportar_para_excel()