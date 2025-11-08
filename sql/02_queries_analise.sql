-- ============================================
-- 1. ANÁLISE DE RECEITA POR TIPO DE VENDA
-- Técnicas: UNION ALL, Agregações
-- ============================================

SELECT 
    'Serviços' as tipo_venda,
    COUNT(*) as quantidade_vendas,
    SUM(valor_total) as receita_total,
    AVG(valor_total) as ticket_medio,
    MIN(valor_total) as menor_venda,
    MAX(valor_total) as maior_venda
FROM vendas_servicos
WHERE status_projeto = 'concluido'

UNION ALL

SELECT 
    'Produtos' as tipo_venda,
    COUNT(*) as quantidade_vendas,
    SUM(valor_total) as receita_total,
    AVG(valor_total) as ticket_medio,
    MIN(valor_total) as menor_venda,
    MAX(valor_total) as maior_venda
FROM vendas_produtos
WHERE status_entrega = 'entregue';


-- ============================================
-- 2. TOP 10 CLIENTES MAIS LUCRATIVOS
-- Técnicas: JOINs múltiplos, COALESCE, GROUP BY
-- ============================================

SELECT 
    c.id_cliente,
    c.razao_social,
    c.setor_industria,
    c.porte_empresa,
    c.status,
    COUNT(DISTINCT vs.id_venda) as total_servicos,
    COUNT(DISTINCT vp.id_venda_produto) as total_produtos,
    COALESCE(SUM(vs.valor_total), 0) as receita_servicos,
    COALESCE(SUM(vp.valor_total), 0) as receita_produtos,
    COALESCE(SUM(vs.valor_total), 0) + COALESCE(SUM(vp.valor_total), 0) as receita_total
FROM clientes c
LEFT JOIN vendas_servicos vs ON c.id_cliente = vs.id_cliente
LEFT JOIN vendas_produtos vp ON c.id_cliente = vp.id_cliente
GROUP BY c.id_cliente, c.razao_social, c.setor_industria, c.porte_empresa, c.status
ORDER BY receita_total DESC
LIMIT 10;


-- ============================================
-- 3. ANÁLISE DE SATISFAÇÃO POR CONSULTOR
-- Técnicas: Agregações, Filtros, Ordenação
-- ============================================

SELECT 
    cons.id_consultor,
    cons.nome,
    cons.especialidade,
    cons.nivel_experiencia,
    COUNT(vs.id_venda) as projetos_concluidos,
    SUM(vs.valor_total) as receita_gerada,
    AVG(vs.satisfacao_cliente) as satisfacao_media,
    MIN(vs.satisfacao_cliente) as menor_nota,
    MAX(vs.satisfacao_cliente) as maior_nota,
    ROUND(AVG(vs.duracao_horas), 2) as duracao_media_horas
FROM consultores cons
INNER JOIN vendas_servicos vs ON cons.id_consultor = vs.id_consultor
WHERE vs.status_projeto = 'concluido'
  AND vs.satisfacao_cliente IS NOT NULL
GROUP BY cons.id_consultor, cons.nome, cons.especialidade, cons.nivel_experiencia
HAVING COUNT(vs.id_venda) >= 3
ORDER BY satisfacao_media DESC, receita_gerada DESC;


-- ============================================
-- 4. ANÁLISE TEMPORAL DE VENDAS (MENSAL)
-- Técnicas: Date Functions, Agregações temporais
-- ============================================

SELECT 
    TO_CHAR(data_contratacao, 'YYYY-MM') as mes_ano,
    EXTRACT(YEAR FROM data_contratacao) as ano,
    EXTRACT(MONTH FROM data_contratacao) as mes,
    COUNT(*) as quantidade_vendas,
    SUM(valor_total) as receita_mensal,
    AVG(valor_total) as ticket_medio_mensal,
    COUNT(DISTINCT id_cliente) as clientes_unicos
FROM vendas_servicos
GROUP BY 
    TO_CHAR(data_contratacao, 'YYYY-MM'),
    EXTRACT(YEAR FROM data_contratacao),
    EXTRACT(MONTH FROM data_contratacao)
ORDER BY mes_ano;


-- ============================================
-- 5. PRODUTOS MAIS VENDIDOS COM IMPACTO AMBIENTAL
-- Técnicas: JOINs, Agregações, Cálculos
-- ============================================

SELECT 
    p.id_produto,
    p.nome_produto,
    p.categoria,
    p.preco,
    COUNT(vp.id_venda_produto) as vezes_vendido,
    SUM(vp.quantidade) as unidades_totais,
    SUM(vp.valor_total) as receita_total,
    p.economia_energia_estimada,
    p.reducao_co2_kg_ano,
    ROUND(SUM(vp.quantidade) * p.reducao_co2_kg_ano, 2) as impacto_co2_total_kg,
    ROUND((SUM(vp.quantidade) * p.reducao_co2_kg_ano) / 1000, 2) as impacto_co2_total_ton
FROM produtos_sustentaveis p
INNER JOIN vendas_produtos vp ON p.id_produto = vp.id_produto
GROUP BY p.id_produto, p.nome_produto, p.categoria, p.preco, 
         p.economia_energia_estimada, p.reducao_co2_kg_ano
HAVING COUNT(vp.id_venda_produto) > 0
ORDER BY receita_total DESC;


-- ============================================
-- 6. ANÁLISE DE CHURN - CLIENTES EM RISCO
-- Técnicas: Date Math, CASE WHEN, Subqueries
-- ============================================

SELECT 
    c.id_cliente,
    c.razao_social,
    c.setor_industria,
    c.porte_empresa,
    c.status,
    c.score_sustentabilidade_atual,
    COUNT(vs.id_venda) as total_servicos_contratados,
    COALESCE(AVG(vs.satisfacao_cliente), 0) as satisfacao_media,
    MAX(vs.data_contratacao) as ultima_compra,
    CAST(CURRENT_DATE - MAX(vs.data_contratacao) AS INTEGER) as dias_sem_comprar,
    CASE 
        WHEN CAST(CURRENT_DATE - MAX(vs.data_contratacao) AS INTEGER) > 180 THEN 'Alto Risco'
        WHEN CAST(CURRENT_DATE - MAX(vs.data_contratacao) AS INTEGER) > 90 THEN 'Médio Risco'
        WHEN CAST(CURRENT_DATE - MAX(vs.data_contratacao) AS INTEGER) > 60 THEN 'Baixo Risco'
        ELSE 'Ativo'
    END as nivel_risco
FROM clientes c
LEFT JOIN vendas_servicos vs ON c.id_cliente = vs.id_cliente
WHERE c.status = 'ativo'
GROUP BY c.id_cliente, c.razao_social, c.setor_industria, c.porte_empresa, 
         c.status, c.score_sustentabilidade_atual
HAVING MAX(vs.data_contratacao) IS NOT NULL
ORDER BY dias_sem_comprar DESC;


-- ============================================
-- 7. ANÁLISE COMPARATIVA POR SETOR
-- Técnicas: Window Functions, CTEs
-- ============================================

WITH receita_por_setor AS (
    SELECT 
        c.setor_industria,
        COUNT(DISTINCT c.id_cliente) as total_clientes,
        COALESCE(SUM(vs.valor_total), 0) + COALESCE(SUM(vp.valor_total), 0) as receita_total,
        COALESCE(AVG(vs.satisfacao_cliente), 0) as satisfacao_media
    FROM clientes c
    LEFT JOIN vendas_servicos vs ON c.id_cliente = vs.id_cliente
    LEFT JOIN vendas_produtos vp ON c.id_cliente = vp.id_cliente
    GROUP BY c.setor_industria
)
SELECT 
    setor_industria,
    total_clientes,
    receita_total,
    satisfacao_media,
    ROUND((receita_total / SUM(receita_total) OVER ()) * 100, 2) as percentual_receita,
    RANK() OVER (ORDER BY receita_total DESC) as ranking_receita,
    RANK() OVER (ORDER BY satisfacao_media DESC) as ranking_satisfacao
FROM receita_por_setor
ORDER BY receita_total DESC;


-- ============================================
-- 8. PERFORMANCE DE VENDAS POR TRIMESTRE
-- Técnicas: Date Functions, CASE, Agregações
-- ============================================

SELECT 
    EXTRACT(YEAR FROM data_contratacao) as ano,
    CASE 
        WHEN EXTRACT(MONTH FROM data_contratacao) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN EXTRACT(MONTH FROM data_contratacao) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN EXTRACT(MONTH FROM data_contratacao) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END as trimestre,
    COUNT(*) as vendas_realizadas,
    SUM(valor_total) as receita_trimestral,
    AVG(valor_total) as ticket_medio,
    COUNT(DISTINCT id_cliente) as clientes_ativos
FROM vendas_servicos
GROUP BY 
    EXTRACT(YEAR FROM data_contratacao),
    CASE 
        WHEN EXTRACT(MONTH FROM data_contratacao) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN EXTRACT(MONTH FROM data_contratacao) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN EXTRACT(MONTH FROM data_contratacao) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END
ORDER BY ano, trimestre;


-- ============================================
-- 9. MATRIZ RFM SIMPLIFICADA (Recência, Frequência, Valor Monetário)
-- Técnicas: Múltiplas agregações, Segmentação
-- ============================================

SELECT 
    c.id_cliente,
    c.razao_social,
    c.setor_industria,
    CAST(CURRENT_DATE - MAX(vs.data_contratacao) AS INTEGER) as recencia_dias,
    COUNT(vs.id_venda) as frequencia,
    COALESCE(SUM(vs.valor_total), 0) as valor_monetario,
    CASE 
        WHEN CAST(CURRENT_DATE - MAX(vs.data_contratacao) AS INTEGER) <= 60 
             AND COUNT(vs.id_venda) >= 3 
             AND COALESCE(SUM(vs.valor_total), 0) > 50000 
        THEN 'VIP'
        WHEN CAST(CURRENT_DATE - MAX(vs.data_contratacao) AS INTEGER) <= 90 
             AND COUNT(vs.id_venda) >= 2 
        THEN 'Ativo'
        WHEN CAST(CURRENT_DATE - MAX(vs.data_contratacao) AS INTEGER) > 90 
        THEN 'Em Risco'
        ELSE 'Regular'
    END as segmento
FROM clientes c
LEFT JOIN