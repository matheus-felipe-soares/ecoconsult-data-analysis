import pandas as pd
import numpy as np
from faker import Faker
from datetime import datetime, timedelta
import random

#Configuração do Faker
fake = Faker('pt_BR')
Faker.seed(42)
np.random.seed(42)
random.seed(42)

def gerar_clientes(n=100):

    setores = ['Tecnologia', 'Varejo', 'Manufatura', 'Serviços', 'Construção', 
               'Alimentos', 'Logística', 'Saúde', 'Educação', 'Financeiro']
    
    portes = ['Pequeno', 'Médio', 'Grande']
    status_list = ['ativo', 'inativo', 'pendente']
    
    clientes = []

    for _ in range(n):
        cliente = {
            'razao_social': fake.company(),
            'cnpj': fake.cnpj(),
            'setor_industria': random.choice(setores),
            'porte_empresa': random.choice(portes),
            'cidade': fake.city(),
            'estado': fake.estado_sigla(),
            'data_cadastro': fake.date_between(start_date='-2y', end_date='today'),
            'status': np.random.choice(status_list, p=[0.7, 0.2, 0.1]),
            'score_sustentabilidade_atual': random.randint(20, 85),
            'meta_reducao_carbono': round(random.uniform(10, 50), 2)
        }
        clientes.append(cliente)
    
    return pd.DataFrame(clientes)

def gerar_consultores(n=30):

    especialidades = ['Energia Renovável', 'Gestão de Resíduos', 'Pegada de Carbono', 
                      'Recursos Hídricos', 'Eficiência Energética', 'Economia Circular',
                      'ESG', 'Biodiversidade']
    
    niveis = ['Junior', 'Pleno', 'Senior']
    
    consultores = []

    for _ in range(n):
        consultor = {
            'nome': fake.name(),
            'especialidade': random.choice(especialidades),
            'nivel_experiencia': random.choice(niveis),
            'certificacoes': f"ISO 14001, {random.choice(['LEED', 'GRI', 'B Corp'])}",
            'avaliacao_media': round(random.uniform(3.5, 5.0), 2),
            'total_projetos': random.randint(5, 150),
            'valor_hora': round(random.uniform(150, 500), 2),
            'cidade': fake.city(),
            'estado': fake.estado_sigla(),
            'disponibilidade': random.choice([True, False])
        }
        consultores.append(consultor)
    
    return pd.DataFrame(consultores)

def gerar_produtos(n=50):
    
    categorias = {
        'Painel Solar': (5000, 15000),
        'Sistema Captação de Água': (3000, 8000),
        'Composteira Industrial': (2000, 6000),
        'Iluminação LED': (500, 2000),
        'Turbina Eólica': (20000, 50000),
        'Sistema de Tratamento de Água': (8000, 25000),
        'Isolamento Térmico': (3000, 10000)
    }
    
    produtos = []
    
    for i in range(n):
        categoria = random.choice(list(categorias.keys()))
        preco_min, preco_max = categorias[categoria]
        
        produto = {
            'nome_produto': f"{categoria} - Modelo {fake.bothify(text='??###')}",
            'categoria': categoria,
            'id_fornecedor_parceiro': random.randint(1, 10),
            'preco': round(random.uniform(preco_min, preco_max), 2),
            'economia_energia_estimada': round(random.uniform(15, 60), 2),
            'reducao_co2_kg_ano': round(random.uniform(500, 5000), 2),
            'tempo_roi_meses': random.randint(12, 60),
            'estoque': random.randint(0, 100)
        }
        produtos.append(produto)
    
    return pd.DataFrame(produtos)

def gerar_vendas_servicos(clientes_df, consultores_df, n=200):
    """Gera dados fictícios de vendas de serviços"""
    
    tipos_servico = ['Auditoria Ambiental', 'Implementação ISO 14001', 
                     'Treinamento ESG', 'Monitoramento Contínuo', 
                     'Relatório de Sustentabilidade', 'Consultoria Carbono Zero']
    
    status_projeto = ['em_andamento', 'concluido', 'cancelado']
    
    vendas = []
    
    for _ in range(n):
        data_contratacao = fake.date_between(start_date='-1y', end_date='today')
        duracao = random.randint(20, 200)
        
        # Se projeto finalizado, tem data conclusão
        status = np.random.choice(status_projeto, p=[0.3, 0.6, 0.1])
        
        if status == 'concluido':
            data_conclusao = data_contratacao + timedelta(days=duracao//8)
            satisfacao = random.randint(6, 10)
        elif status == 'cancelado':
            data_conclusao = data_contratacao + timedelta(days=random.randint(10, 50))
            satisfacao = random.randint(1, 5)
        else:
            data_conclusao = None
            satisfacao = None
        
        consultor_id = random.choice(consultores_df.index) + 1
        valor_hora = consultores_df.loc[consultores_df.index[consultor_id-1], 'valor_hora']
        
        venda = {
            'id_cliente': random.choice(clientes_df.index) + 1,
            'id_consultor': consultor_id,
            'tipo_servico': random.choice(tipos_servico),
            'data_contratacao': data_contratacao,
            'data_conclusao': data_conclusao,
            'duracao_horas': duracao,
            'valor_total': round(duracao * valor_hora, 2),
            'status_projeto': status,
            'satisfacao_cliente': satisfacao
        }
        vendas.append(venda)
    
    return pd.DataFrame(vendas)


def gerar_vendas_produtos(clientes_df, produtos_df, n=150):
    """Gera dados fictícios de vendas de produtos"""
    
    status_entrega = ['entregue', 'em_transito', 'pendente']
    
    vendas = []
    
    for _ in range(n):
        data_venda = fake.date_between(start_date='-1y', end_date='today')
        quantidade = random.randint(1, 10)
        
        produto_id = random.choice(produtos_df.index) + 1
        preco_unitario = produtos_df.loc[produtos_df.index[produto_id-1], 'preco']
        
        status = random.choice(status_entrega)
        
        if status == 'entregue':
            data_instalacao = data_venda + timedelta(days=random.randint(7, 30))
        else:
            data_instalacao = None
        
        venda = {
            'id_cliente': random.choice(clientes_df.index) + 1,
            'id_produto': produto_id,
            'quantidade': quantidade,
            'data_venda': data_venda,
            'valor_total': round(quantidade * preco_unitario, 2),
            'data_instalacao': data_instalacao,
            'status_entrega': status
        }
        vendas.append(venda)
    
    return pd.DataFrame(vendas)


if __name__ == "__main__":
    print("Gerando dados fictícios...")
    
    clientes = gerar_clientes(100)
    consultores = gerar_consultores(30)
    produtos = gerar_produtos(50)
    vendas_servicos = gerar_vendas_servicos(clientes, consultores, 200)
    vendas_produtos = gerar_vendas_produtos(clientes, produtos, 150)
    
    print(f"{len(clientes)} clientes gerados")
    print(f"{len(consultores)} consultores gerados")
    print(f"{len(produtos)} produtos gerados")
    print(f"{len(vendas_servicos)} vendas de serviços geradas")
    print(f"{len(vendas_produtos)} vendas de produtos geradas")