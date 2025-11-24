-- =====================================================
-- CONSULTAS ANALÍTICAS - GOLD LAYER
-- Data Warehouse de Filmes - Star Schema
-- =====================================================

-- =====================================================
-- 1. EVOLUÇÃO DA RECEITA POR ANO
-- Objetivo: Analisar a evolução da receita total ao longo dos anos
-- =====================================================
SELECT 
    t.ano_lancamento,
    t.dec_inicio as decada,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    SUM(f.vlr_receita) as receita_total,
    SUM(f.vlr_orcamento) as orcamento_total,
    SUM(f.vlr_lucro) as lucro_total,
    AVG(f.pct_roi) as roi_medio,
    AVG(f.med_avaliacao) as avaliacao_media
FROM gold.fto_filme f
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
WHERE f.vlr_receita > 0
GROUP BY t.ano_lancamento, t.dec_inicio
ORDER BY t.ano_lancamento DESC;


-- =====================================================
-- 2. TOP 20 FILMES MAIS LUCRATIVOS DE TODOS OS TEMPOS
-- Objetivo: Identificar os filmes com maior lucro
-- =====================================================
SELECT 
    m.mov_titulo,
    m.mov_titulo_original,
    t.ano_lancamento,
    g.gnr_nome as genero,
    geo.geo_pais as pais,
    d.dir_nome as diretor,
    a.act_nome as ator_principal,
    f.vlr_orcamento,
    f.vlr_receita,
    f.vlr_lucro,
    f.pct_roi,
    f.med_avaliacao,
    f.qtd_votos
FROM gold.fto_filme f
JOIN gold.dim_filme m ON f.mov_fky = m.mov_srk
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
JOIN gold.dim_genero g ON f.gnr_fky = g.gnr_srk
JOIN gold.dim_geografia geo ON f.geo_fky = geo.geo_srk
JOIN gold.dim_diretor d ON f.dir_fky = d.dir_srk
JOIN gold.dim_ator a ON f.act_fky = a.act_srk
WHERE f.vlr_lucro > 0
ORDER BY f.vlr_lucro DESC
LIMIT 20;


-- =====================================================
-- 3. ANÁLISE DE DESEMPENHO POR GÊNERO
-- Objetivo: Comparar performance financeira entre gêneros
-- =====================================================
SELECT 
    g.gnr_nome as genero,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    SUM(f.vlr_receita) as receita_total,
    AVG(f.vlr_receita) as receita_media,
    SUM(f.vlr_lucro) as lucro_total,
    AVG(f.vlr_lucro) as lucro_medio,
    AVG(f.pct_roi) as roi_medio,
    AVG(f.med_avaliacao) as avaliacao_media,
    AVG(f.med_popularidade) as popularidade_media,
    SUM(f.qtd_votos) as total_votos,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters
FROM gold.fto_filme f
JOIN gold.dim_genero g ON f.gnr_fky = g.gnr_srk
WHERE f.vlr_receita > 0
GROUP BY g.gnr_nome
ORDER BY receita_total DESC;


-- =====================================================
-- 4. TOP 15 DIRETORES MAIS BEM-SUCEDIDOS (POR ROI)
-- Objetivo: Identificar diretores com melhor retorno sobre investimento
-- =====================================================
SELECT 
    d.dir_nome,
    d.dir_nome_completo,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    SUM(f.vlr_receita) as receita_total,
    SUM(f.vlr_lucro) as lucro_total,
    AVG(f.pct_roi) as roi_medio,
    AVG(f.med_avaliacao) as avaliacao_media,
    MAX(f.med_avaliacao) as melhor_avaliacao,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters
FROM gold.fto_filme f
JOIN gold.dim_diretor d ON f.dir_fky = d.dir_srk
WHERE f.vlr_receita > 0
GROUP BY d.dir_nome, d.dir_nome_completo
HAVING COUNT(DISTINCT f.mov_fky) >= 3  -- Pelo menos 3 filmes
ORDER BY roi_medio DESC
LIMIT 15;


-- =====================================================
-- 5. ANÁLISE DE BLOCKBUSTERS POR DÉCADA
-- Objetivo: Identificar tendências de blockbusters ao longo do tempo
-- =====================================================
SELECT 
    t.dec_inicio as decada,
    COUNT(DISTINCT f.mov_fky) as qtd_blockbusters,
    AVG(f.vlr_receita) as receita_media,
    AVG(f.vlr_orcamento) as orcamento_medio,
    AVG(f.med_avaliacao) as avaliacao_media,
    AVG(f.dur_minutos) as duracao_media,
    STRING_AGG(DISTINCT g.gnr_nome, ', ' ORDER BY g.gnr_nome) as generos_principais
FROM gold.fto_filme f
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
JOIN gold.dim_genero g ON f.gnr_fky = g.gnr_srk
WHERE f.flg_blockbuster = 'true'
GROUP BY t.dec_inicio
ORDER BY t.dec_inicio DESC;


-- =====================================================
-- 6. ANÁLISE GEOGRÁFICA - PRODUÇÃO POR PAÍS
-- Objetivo: Entender distribuição geográfica da produção cinematográfica
-- =====================================================
SELECT 
    geo.geo_pais as pais,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    SUM(f.vlr_receita) as receita_total,
    AVG(f.vlr_receita) as receita_media_filme,
    SUM(f.vlr_orcamento) as orcamento_total,
    SUM(f.vlr_lucro) as lucro_total,
    AVG(f.pct_roi) as roi_medio,
    AVG(f.med_avaliacao) as avaliacao_media,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters,
    ROUND(100.0 * SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_blockbusters
FROM gold.fto_filme f
JOIN gold.dim_geografia geo ON f.geo_fky = geo.geo_srk
WHERE f.vlr_receita > 0
GROUP BY geo.geo_pais
ORDER BY receita_total DESC
LIMIT 30;


-- =====================================================
-- 7. TOP 20 ATORES COM MELHOR DESEMPENHO FINANCEIRO
-- Objetivo: Identificar atores que participam de filmes mais lucrativos
-- =====================================================
SELECT 
    a.act_nome,
    a.act_nome_completo,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    SUM(f.vlr_receita) as receita_total,
    AVG(f.vlr_receita) as receita_media_filme,
    SUM(f.vlr_lucro) as lucro_total,
    AVG(f.med_avaliacao) as avaliacao_media,
    AVG(f.med_popularidade) as popularidade_media,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters,
    MAX(t.ano_lancamento) as ultimo_filme
FROM gold.fto_filme f
JOIN gold.dim_ator a ON f.act_fky = a.act_srk
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
WHERE f.vlr_receita > 0
GROUP BY a.act_nome, a.act_nome_completo
HAVING COUNT(DISTINCT f.mov_fky) >= 5  -- Pelo menos 5 filmes
ORDER BY receita_total DESC
LIMIT 20;


-- =====================================================
-- 8. ANÁLISE SAZONAL - DESEMPENHO POR TRIMESTRE
-- Objetivo: Identificar padrões sazonais de lançamento e desempenho
-- =====================================================
SELECT 
    t.tri_nome as trimestre,
    t.tri_numero,
    COUNT(DISTINCT f.mov_fky) as qtd_lancamentos,
    AVG(f.vlr_receita) as receita_media,
    AVG(f.med_avaliacao) as avaliacao_media,
    AVG(f.med_popularidade) as popularidade_media,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters,
    ROUND(100.0 * SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_blockbusters
FROM gold.fto_filme f
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
WHERE f.vlr_receita > 0
GROUP BY t.tri_nome, t.tri_numero
ORDER BY t.tri_numero;


-- =====================================================
-- 9. RANKING DE COMPANHIAS PRODUTORAS
-- Objetivo: Identificar as produtoras mais bem-sucedidas
-- =====================================================
SELECT 
    c.cmp_nome,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    SUM(f.vlr_receita) as receita_total,
    SUM(f.vlr_lucro) as lucro_total,
    AVG(f.pct_roi) as roi_medio,
    AVG(f.med_avaliacao) as avaliacao_media,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters,
    MIN(t.ano_lancamento) as primeiro_filme,
    MAX(t.ano_lancamento) as ultimo_filme,
    MAX(t.ano_lancamento) - MIN(t.ano_lancamento) + 1 as anos_atividade
FROM gold.fto_filme f
JOIN gold.dim_companhia c ON f.cmp_fky = c.cmp_srk
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
WHERE f.vlr_receita > 0
GROUP BY c.cmp_nome
HAVING COUNT(DISTINCT f.mov_fky) >= 5  -- Pelo menos 5 filmes
ORDER BY receita_total DESC
LIMIT 30;


-- =====================================================
-- 10. ANÁLISE DE CORRELAÇÃO: DURAÇÃO vs AVALIAÇÃO vs RECEITA
-- Objetivo: Entender relação entre duração do filme e seu desempenho
-- =====================================================
SELECT 
    CASE 
        WHEN f.dur_minutos < 90 THEN 'Curto (< 90min)'
        WHEN f.dur_minutos BETWEEN 90 AND 120 THEN 'Médio (90-120min)'
        WHEN f.dur_minutos BETWEEN 121 AND 150 THEN 'Longo (121-150min)'
        ELSE 'Muito Longo (> 150min)'
    END as categoria_duracao,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    AVG(f.dur_minutos) as duracao_media,
    AVG(f.vlr_receita) as receita_media,
    AVG(f.vlr_lucro) as lucro_medio,
    AVG(f.med_avaliacao) as avaliacao_media,
    AVG(f.med_popularidade) as popularidade_media,
    AVG(f.qtd_votos) as votos_medio,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters
FROM gold.fto_filme f
WHERE f.dur_minutos IS NOT NULL 
  AND f.dur_minutos > 0
  AND f.vlr_receita > 0
GROUP BY 
    CASE 
        WHEN f.dur_minutos < 90 THEN 'Curto (< 90min)'
        WHEN f.dur_minutos BETWEEN 90 AND 120 THEN 'Médio (90-120min)'
        WHEN f.dur_minutos BETWEEN 121 AND 150 THEN 'Longo (121-150min)'
        ELSE 'Muito Longo (> 150min)'
    END
ORDER BY duracao_media;


-- =====================================================
-- 11. ANÁLISE DE TAMANHO DE PRODUÇÃO (ELENCO + EQUIPE)
-- Objetivo: Correlacionar tamanho da produção com sucesso do filme
-- =====================================================
SELECT 
    CASE 
        WHEN (f.qtd_elenco + f.qtd_equipe) < 50 THEN 'Produção Pequena (< 50)'
        WHEN (f.qtd_elenco + f.qtd_equipe) BETWEEN 50 AND 100 THEN 'Produção Média (50-100)'
        WHEN (f.qtd_elenco + f.qtd_equipe) BETWEEN 101 AND 200 THEN 'Produção Grande (101-200)'
        ELSE 'Produção Muito Grande (> 200)'
    END as categoria_producao,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    AVG(f.qtd_elenco) as elenco_medio,
    AVG(f.qtd_equipe) as equipe_media,
    AVG(f.vlr_orcamento) as orcamento_medio,
    AVG(f.vlr_receita) as receita_media,
    AVG(f.pct_roi) as roi_medio,
    AVG(f.med_avaliacao) as avaliacao_media,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters
FROM gold.fto_filme f
WHERE f.qtd_elenco > 0 
  AND f.qtd_equipe > 0
  AND f.vlr_receita > 0
GROUP BY 
    CASE 
        WHEN (f.qtd_elenco + f.qtd_equipe) < 50 THEN 'Produção Pequena (< 50)'
        WHEN (f.qtd_elenco + f.qtd_equipe) BETWEEN 50 AND 100 THEN 'Produção Média (50-100)'
        WHEN (f.qtd_elenco + f.qtd_equipe) BETWEEN 101 AND 200 THEN 'Produção Grande (101-200)'
        ELSE 'Produção Muito Grande (> 200)'
    END
ORDER BY orcamento_medio;


-- =====================================================
-- 12. ANÁLISE MULTIDIMENSIONAL COMPLETA
-- Objetivo: Visão consolidada por Ano + Gênero + País
-- =====================================================
SELECT 
    t.ano_lancamento,
    g.gnr_nome as genero,
    geo.geo_pais as pais,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    SUM(f.vlr_receita) as receita_total,
    SUM(f.vlr_lucro) as lucro_total,
    AVG(f.pct_roi) as roi_medio,
    AVG(f.med_avaliacao) as avaliacao_media,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters
FROM gold.fto_filme f
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
JOIN gold.dim_genero g ON f.gnr_fky = g.gnr_srk
JOIN gold.dim_geografia geo ON f.geo_fky = geo.geo_srk
WHERE f.vlr_receita > 0
  AND t.ano_lancamento >= 2000  -- Últimas duas décadas
GROUP BY t.ano_lancamento, g.gnr_nome, geo.geo_pais
HAVING COUNT(DISTINCT f.mov_fky) >= 5  -- Pelo menos 5 filmes
ORDER BY t.ano_lancamento DESC, receita_total DESC;


-- =====================================================
-- 13. FILMES CULT (ALTA AVALIAÇÃO, BAIXO ORÇAMENTO)
-- Objetivo: Identificar filmes com excelente avaliação mas orçamento modesto
-- =====================================================
SELECT 
    m.mov_titulo,
    m.mov_titulo_original,
    t.ano_lancamento,
    g.gnr_nome as genero,
    d.dir_nome as diretor,
    f.vlr_orcamento,
    f.vlr_receita,
    f.pct_roi,
    f.med_avaliacao,
    f.qtd_votos,
    f.med_popularidade
FROM gold.fto_filme f
JOIN gold.dim_filme m ON f.mov_fky = m.mov_srk
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
JOIN gold.dim_genero g ON f.gnr_fky = g.gnr_srk
JOIN gold.dim_diretor d ON f.dir_fky = d.dir_srk
WHERE f.med_avaliacao >= 7.5  -- Alta avaliação
  AND f.qtd_votos >= 1000  -- Mínimo de votos para ser significativo
  AND f.vlr_orcamento < 5000000  -- Orçamento modesto (< 5M)
  AND f.vlr_orcamento > 0
ORDER BY f.med_avaliacao DESC, f.pct_roi DESC
LIMIT 30;


-- =====================================================
-- 14. COMPARAÇÃO DE DESEMPENHO: FIM DE SEMANA vs DIA DE SEMANA
-- Objetivo: Analisar se data de lançamento (fim de semana) afeta desempenho
-- =====================================================
SELECT 
    CASE WHEN t.flg_fim_semana = 'true' THEN 'Fim de Semana' ELSE 'Dia de Semana' END as tipo_lancamento,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes,
    AVG(f.vlr_receita) as receita_media,
    AVG(f.vlr_lucro) as lucro_medio,
    AVG(f.pct_roi) as roi_medio,
    AVG(f.med_avaliacao) as avaliacao_media,
    AVG(f.med_popularidade) as popularidade_media,
    SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) as qtd_blockbusters,
    ROUND(100.0 * SUM(CASE WHEN f.flg_blockbuster = 'true' THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_blockbusters
FROM gold.fto_filme f
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
WHERE f.vlr_receita > 0
GROUP BY t.flg_fim_semana
ORDER BY receita_media DESC;


-- =====================================================
-- 15. ANÁLISE DE FRANCHISES/SEQUÊNCIAS
-- Objetivo: Identificar possíveis franchises baseado em títulos similares
-- =====================================================
WITH filmes_serie AS (
    SELECT 
        REGEXP_REPLACE(m.mov_titulo, '\s+(I{1,3}|IV|V|VI{1,3}|\d+)$', '') as serie_base,
        COUNT(*) as qtd_filmes
    FROM gold.dim_filme m
    GROUP BY REGEXP_REPLACE(m.mov_titulo, '\s+(I{1,3}|IV|V|VI{1,3}|\d+)$', '')
    HAVING COUNT(*) > 1
)
SELECT 
    fs.serie_base as franchise,
    fs.qtd_filmes as qtd_filmes_serie,
    COUNT(DISTINCT f.mov_fky) as qtd_registros,
    MIN(t.ano_lancamento) as primeiro_filme,
    MAX(t.ano_lancamento) as ultimo_filme,
    SUM(f.vlr_receita) as receita_total_franchise,
    AVG(f.vlr_receita) as receita_media_filme,
    AVG(f.med_avaliacao) as avaliacao_media,
    STRING_AGG(DISTINCT g.gnr_nome, ', ' ORDER BY g.gnr_nome) as generos
FROM filmes_serie fs
JOIN gold.dim_filme m ON REGEXP_REPLACE(m.mov_titulo, '\s+(I{1,3}|IV|V|VI{1,3}|\d+)$', '') = fs.serie_base
JOIN gold.fto_filme f ON f.mov_fky = m.mov_srk
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
JOIN gold.dim_genero g ON f.gnr_fky = g.gnr_srk
WHERE f.vlr_receita > 0
GROUP BY fs.serie_base, fs.qtd_filmes
HAVING SUM(f.vlr_receita) > 100000000  -- Receita total > 100M
ORDER BY receita_total_franchise DESC
LIMIT 20;


-- =====================================================
-- FIM DAS CONSULTAS
-- Total: 15 consultas analíticas completas
-- =====================================================
