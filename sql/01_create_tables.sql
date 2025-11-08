-- Tabela de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente SERIAL PRIMARY KEY,
    razao_social VARCHAR(200) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    setor_industria VARCHAR(100),
    porte_empresa VARCHAR(50),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    data_cadastro DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'ativo',
    score_sustentabilidade_atual INTEGER CHECK (score_sustentabilidade_atual BETWEEN 0 AND 100),
    meta_reducao_carbono DECIMAL(5,2)
);

-- Tabela de Consultores
CREATE TABLE IF NOT EXISTS consultores (
    id_consultor SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    especialidade VARCHAR(100),
    nivel_experiencia VARCHAR(50),
    certificacoes TEXT,
    avaliacao_media DECIMAL(3,2) CHECK (avaliacao_media BETWEEN 0 AND 5),
    total_projetos INTEGER DEFAULT 0,
    valor_hora DECIMAL(10,2),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    disponibilidade BOOLEAN DEFAULT TRUE
);

-- Tabela de Produtos Sustentáveis
CREATE TABLE IF NOT EXISTS produtos_sustentaveis (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(200) NOT NULL,
    categoria VARCHAR(100),
    id_fornecedor_parceiro INTEGER,
    preco DECIMAL(10,2),
    economia_energia_estimada DECIMAL(5,2),
    reducao_co2_kg_ano DECIMAL(10,2),
    tempo_roi_meses INTEGER,
    estoque INTEGER DEFAULT 0
);

-- Tabela de Vendas de Serviços (Consultoria)
CREATE TABLE IF NOT EXISTS vendas_servicos (
    id_venda SERIAL PRIMARY KEY,
    id_cliente INTEGER REFERENCES clientes(id_cliente),
    id_consultor INTEGER REFERENCES consultores(id_consultor),
    tipo_servico VARCHAR(100),
    data_contratacao DATE,
    data_conclusao DATE,
    duracao_horas INTEGER,
    valor_total DECIMAL(10,2),
    status_projeto VARCHAR(50),
    satisfacao_cliente INTEGER CHECK (satisfacao_cliente BETWEEN 0 AND 10)
);

-- Tabela de Vendas de Produtos
CREATE TABLE IF NOT EXISTS vendas_produtos (
    id_venda_produto SERIAL PRIMARY KEY,
    id_cliente INTEGER REFERENCES clientes(id_cliente),
    id_produto INTEGER REFERENCES produtos_sustentaveis(id_produto),
    quantidade INTEGER,
    data_venda DATE,
    valor_total DECIMAL(10,2),
    data_instalacao DATE,
    status_entrega VARCHAR(50)
);

-- Índices para melhorar performance
CREATE INDEX IF NOT EXISTS idx_clientes_cnpj ON clientes(cnpj);
CREATE INDEX IF NOT EXISTS idx_clientes_status ON clientes(status);
CREATE INDEX IF NOT EXISTS idx_vendas_servicos_cliente ON vendas_servicos(id_cliente);
CREATE INDEX IF NOT EXISTS idx_vendas_servicos_consultor ON vendas_servicos(id_consultor);
CREATE INDEX IF NOT EXISTS idx_vendas_produtos_cliente ON vendas_produtos(id_cliente);

-- Comentários nas tabelas
COMMENT ON TABLE clientes IS 'Empresas que contratam serviços de consultoria em sustentabilidade';
COMMENT ON TABLE consultores IS 'Profissionais especializados em diferentes áreas de sustentabilidade';
COMMENT ON TABLE produtos_sustentaveis IS 'Produtos e equipamentos sustentáveis comercializados';
COMMENT ON TABLE vendas_servicos IS 'Registro de serviços de consultoria prestados';
COMMENT ON TABLE vendas_produtos IS 'Registro de vendas de produtos sustentáveis';