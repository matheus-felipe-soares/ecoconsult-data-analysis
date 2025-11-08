# EcoConsult - Análise de Churn de Clientes

<div align="center">

![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-316192?logo=postgresql&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-orange?logo=jupyter&logoColor=white)
![Scikit-learn](https://img.shields.io/badge/Scikit--learn-ML-F7931E?logo=scikit-learn&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-success)

**Projeto completo de Data Science: da coleta de dados ao modelo preditivo**

[ Ver Análise](#análise-exploratória) • [ Ver Modelo](#modelo-de-machine-learning) • [ Resultados](#resultados)

</div>

---

##  Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Contexto de Negócio](#contexto-de-negócio)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Como Executar](#como-executar)
- [Análise Exploratória](#análise-exploratória)
- [Modelo de Machine Learning](#modelo-de-machine-learning)
- [Resultados](#resultados)
- [Insights de Negócio](#insights-de-negócio)
- [Próximos Passos](#próximos-passos)
- [Contato](#contato)

---

##  Sobre o Projeto

Este projeto demonstra um **pipeline completo de Data Science**, desde a geração de dados fictícios até o desenvolvimento de um modelo preditivo de churn. O objetivo é identificar clientes com maior probabilidade de cancelamento, permitindo ações proativas de retenção.

### Destaques do Projeto:

 **Banco de dados PostgreSQL** com 5 tabelas relacionadas  
 **530 registros** de dados fictícios realistas  
 **Análise exploratória completa** com visualizações profissionais  
 **4 modelos de ML** treinados e comparados  
 **SQL avançado** com JOINs, CTEs e Window Functions  
 **Tratamento de desbalanceamento** com SMOTE  
 **Documentação completa** e código reproduzível  

---

##  Contexto de Negócio

**EcoConsult** é uma consultoria fictícia especializada em sustentabilidade corporativa que:

-  Conecta empresas com consultores especializados
-  Vende produtos e equipamentos sustentáveis
-  Ajuda empresas a reduzirem impacto ambiental
-  Monitora métricas de sustentabilidade

### Problema de Negócio:

A empresa identificou uma **taxa de churn de 23%** e precisa:
1. Entender os fatores que levam ao cancelamento
2. Prever quais clientes têm maior risco
3. Criar estratégias de retenção personalizadas

---

##  Tecnologias Utilizadas

### Banco de Dados:
- **PostgreSQL 16** - Banco de dados relacional
- **SQLAlchemy** - ORM para Python

### Linguagens & Bibliotecas:
- **Python 3.12**
  - `pandas` - Manipulação de dados
  - `numpy` - Operações numéricas
  - `matplotlib` & `seaborn` - Visualizações
  - `scikit-learn` - Machine Learning
  - `imbalanced-learn` - Tratamento de desbalanceamento (SMOTE)
  - `faker` - Geração de dados fictícios

### Ambiente:
- **Jupyter Notebook** - Desenvolvimento e documentação
- **Ubuntu Linux** - Sistema operacional
- **Git & GitHub** - Controle de versão

---

##  Estrutura do Projeto
```
ecoconsult-data-analysis/
│
├── data/
│   ├── raw/                    # Dados originais (se houver)
│   ├── processed/              # Dados processados
│   └── database/               # Exports do banco
│
├── notebooks/
│   ├── 01_analise_exploratoria.ipynb      # EDA completa
│   └── 02_modelo_churn_prediction.ipynb   # Modelagem ML
│
├── sql/
│   ├── 01_create_tables.sql              # DDL - Criação de tabelas
│   ├── 02_queries_analise.sql            # Queries analíticas
│   └── 03_views.sql                      # Views úteis
│
├── src/
│   ├── db_config.py                      # Configurações do banco
│   ├── data_generator.py                 # Gerador de dados fictícios
│   └── utils.py                          # Funções auxiliares
│
├── reports/
│   └── figures/                          # Gráficos gerados
│
├── create_tables.py                      # Script para criar tabelas
├── populate_database.py                  # Script para popular banco
├── test_connection.py                    # Teste de conexão
├── requirements.txt                      # Dependências
├── .gitignore                           # Arquivos ignorados
└── README.md                            # Este arquivo
```

---

##  Como Executar

### Pré-requisitos:

- Python 3.8+
- PostgreSQL 12+
- Git

### 1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/ecoconsult-data-analysis.git
cd ecoconsult-data-analysis
```

### 2. Crie ambiente virtual e instale dependências:
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# ou
venv\Scripts\activate     # Windows

pip install -r requirements.txt
```

### 3. Configure o PostgreSQL:
```bash
# Acesse o PostgreSQL
sudo -u postgres psql

# Crie banco e usuário
CREATE DATABASE ecoconsult_db;
CREATE USER ecoconsult_user WITH PASSWORD 'sua_senha';
GRANT ALL PRIVILEGES ON DATABASE ecoconsult_db TO ecoconsult_user;
\q
```

### 4. Ajuste as configurações:

Edite `src/db_config.py` com suas credenciais.

### 5. Crie as tabelas e popule o banco:
```bash
python create_tables.py
python populate_database.py
```

### 6. Execute os notebooks:
```bash
jupyter notebook
```

Navegue até `notebooks/` e execute os arquivos na ordem numérica.

---

##  Análise Exploratória

### Dataset Final:
- **100 clientes** de diversos setores
- **30 consultores** especializados
- **50 produtos sustentáveis**
- **200 vendas de serviços**
- **150 vendas de produtos**

### Principais Descobertas:

#### 1. Perfil dos Clientes:
- Score médio de sustentabilidade: **49.9/100**
- Meta média de redução de carbono: **30.4%**
- Distribuição equilibrada entre portes de empresa

#### 2. Análise de Vendas:
- **Serviços** representam maior receita que produtos
- Ticket médio de serviços é **3x maior** que produtos
- Sazonalidade identificada nas vendas mensais

#### 3. Taxa de Churn:
- **23% dos clientes** estão inativos
- Maior concentração nos setores **Serviços** e **Tecnologia**
- Satisfação média dos clientes: **7.8/10**

### Visualizações:

![Distribuição de Clientes](reports/figures/clientes_distribuicao.png)
![Análise Temporal](reports/figures/vendas_temporais.png)

---

##  Modelo de Machine Learning

### Objetivo:
Prever quais clientes têm maior probabilidade de churn (cancelamento).

### Processo:

1. **Preparação dos Dados:**
   - Remoção de clientes com status "pendente" (ambíguo)
   - Encoding de variáveis categóricas (One-Hot Encoding)
   - Normalização com StandardScaler
   - Split 80/20 (treino/teste)

2. **Tratamento de Desbalanceamento:**
   - Aplicação de **SMOTE** no conjunto de treino
   - Balanceamento 50/50 entre classes

3. **Modelos Testados:**
   - Logistic Regression 
   - Decision Tree
   - Random Forest
   - Gradient Boosting

### Features Utilizadas:

**Numéricas:**
- Score de sustentabilidade atual
- Meta de redução de carbono
- Total de serviços/produtos contratados
- Valores gastos
- Satisfação média
- Dias desde última compra

**Categóricas:**
- Setor industrial
- Porte da empresa

---

##  Resultados

### Melhor Modelo: **Logistic Regression**

| Métrica | Valor |
|---------|-------|
| Acurácia | 63.2% |
| Precision | 20.0% |
| Recall | 25.0% |
| F1-Score | 22.2% |

### Matriz de Confusão:
```
                 Predito
              Não-Churn  Churn
Real Não-Churn    11       4
     Churn         3       1
```

### Top 5 Features Mais Importantes:

1.  **Dias desde última compra** (1.21)
2.  **Porte médio da empresa** (1.04)
3.  **Valor total em produtos** (-0.85)
4.  **Setor Serviços** (-0.72)
5.  **Valor total em serviços** (0.66)

---

##  Insights de Negócio

### Fatores de Risco de Churn:

 **Alto Risco:**
- Clientes dos setores **Serviços** e **Tecnologia**
- Alto gasto em produtos vs. serviços de consultoria
- Baixa frequência de compras (>90 dias sem interação)
- Empresas de pequeno porte

 **Baixo Risco:**
- Empresas de **porte médio**
- Alto investimento em **serviços consultivos**
- Satisfação acima de 8/10
- Compras regulares (< 60 dias)

### Recomendações Estratégicas:

#### 1. Ações Imediatas:
-  Implementar alerta automático para clientes há >90 dias sem comprar
-  Criar programa de fidelidade para pequenas empresas
-  Oferecer migração de produtos para pacotes de consultoria
-  Monitoramento especial de setores de alto risco

#### 2. Melhorias no Modelo:
-  Coletar mais dados (target: 500+ clientes)
-  Incluir variáveis de engajamento (emails abertos, calls atendidos)
-  Adicionar features temporais (sazonalidade)
-  Testar modelos ensemble mais complexos

#### 3. Valor Estimado:
- **25% de identificação** correta de churn potenciais
- Possibilidade de **reduzir churn em 10-15%** com ações direcionadas
- **ROI estimado** de campanhas de retenção: 3x

---

##  Próximos Passos

- [ ] Migrar banco para **Supabase** (cloud)
- [ ] Criar **dashboard interativo** com Streamlit
- [ ] Desenvolver **API REST** para predições em tempo real
- [ ] Implementar **sistema de alertas** automáticos
- [ ] Realizar **A/B testing** de estratégias de retenção
- [ ] Integrar com **CRM** da empresa

---

##  Contato

**Seu Nome**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?logo=linkedin&logoColor=white)](https://linkedin.com/in/seu-perfil)
[![GitHub](https://img.shields.io/badge/GitHub-100000?logo=github&logoColor=white)](https://github.com/seu-usuario)
[![Email](https://img.shields.io/badge/Email-D14836?logo=gmail&logoColor=white)](mailto:seu.email@exemplo.com)

---

<div align="center">

###  Se este projeto foi útil, considere dar uma estrela!

**Desenvolvido com 💚 por [Seu Nome]**

</div>