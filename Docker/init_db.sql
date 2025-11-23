-- ============================================================
-- SCRIPT DE INICIALIZAÇÃO DO BANCO DE DADOS
-- Projeto: Bancos de Dados 2 - Arquitetura Medallion
-- Database: movies_dw
-- ============================================================

-- Criar schemas
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- Comentários
COMMENT ON SCHEMA silver IS 'Camada SILVER - Dados limpos e consolidados';
COMMENT ON SCHEMA gold IS 'Camada GOLD - Modelo Dimensional (Star Schema)';

-- ============================================================
-- SILVER SCHEMA - Tabela movies_raw
-- ============================================================

CREATE TABLE IF NOT EXISTS silver.movies_raw (
    -- Identificadores
    id INTEGER PRIMARY KEY,
    title VARCHAR(500),
    original_title VARCHAR(500),
    original_language VARCHAR(10),
    
    -- Datas
    release_date DATE,
    release_year INTEGER,
    release_month INTEGER,
    release_decade INTEGER,
    
    -- Métricas Financeiras
    budget BIGINT,
    revenue BIGINT,
    profit BIGINT,
    roi NUMERIC(15, 2),
    budget_category VARCHAR(50),
    revenue_category VARCHAR(50),
    
    -- Duração
    runtime NUMERIC(10, 2),
    runtime_category VARCHAR(50),
    
    -- Avaliações TMDB
    vote_average NUMERIC(3, 1),
    vote_count INTEGER,
    popularity NUMERIC(10, 3),
    
    -- Gêneros
    genres_list TEXT,
    primary_genre VARCHAR(100),
    
    -- Produção
    production_companies_list TEXT,
    primary_company VARCHAR(200),
    production_countries_list TEXT,
    primary_country VARCHAR(100),
    
    -- Status
    status VARCHAR(50),
    adult BOOLEAN,
    
    -- Descrições
    overview TEXT,
    tagline TEXT,
    homepage TEXT,
    
    -- Links externos
    imdb_id VARCHAR(20),
    poster_path VARCHAR(200),
    
    -- Credits
    director VARCHAR(200),
    lead_actor VARCHAR(200),
    top_actors TEXT,
    cast_size INTEGER,
    crew_size INTEGER,
    
    -- Keywords
    keywords_list TEXT,
    keywords_count INTEGER,
    
    -- Ratings agregados (dos usuários)
    avg_rating NUMERIC(3, 2),
    median_rating NUMERIC(3, 2),
    std_rating NUMERIC(3, 2),
    total_ratings INTEGER,
    min_rating NUMERIC(3, 2),
    max_rating NUMERIC(3, 2),
    unique_users INTEGER,
    
    -- IDs adicionais
    tmdb_id INTEGER,
    imdb_id_formatted VARCHAR(20)
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_movies_raw_year ON silver.movies_raw(release_year);
CREATE INDEX IF NOT EXISTS idx_movies_raw_genre ON silver.movies_raw(primary_genre);
CREATE INDEX IF NOT EXISTS idx_movies_raw_director ON silver.movies_raw(director);

-- Comentários
COMMENT ON TABLE silver.movies_raw IS 'Tabela consolidada com todos os dados de filmes - Camada SILVER';

-- ============================================================
-- Mensagem de sucesso
-- ============================================================

DO $$
BEGIN
    RAISE NOTICE '✅ Banco de dados inicializado com sucesso!';
    RAISE NOTICE '   - Schema SILVER criado';
    RAISE NOTICE '   - Schema GOLD criado';
    RAISE NOTICE '   - Tabela silver.movies_raw criada';
END $$;
-- ============================================================
-- DDL - CAMADA GOLD (Star Schema)
-- Projeto: Bancos de Dados 2 - Arquitetura Medallion
-- Data: 2025-11-23
-- ============================================================
-- Descrição: Script de criação do modelo dimensional (Star Schema)
-- com 1 tabela fato (fto_filme) e 7 dimensões
-- ============================================================

-- ============================================================
-- 1. CRIAR SCHEMA GOLD (se ainda não existe)
-- ============================================================

CREATE SCHEMA IF NOT EXISTS gold;

COMMENT ON SCHEMA gold IS 'Camada GOLD - Modelo Dimensional (Star Schema) otimizado para análises e BI';

-- ============================================================
-- 2. DIMENSÃO: DIM_TEMPO
-- ============================================================

CREATE TABLE IF NOT EXISTS gold.dim_tempo (
    -- Chaves
    tmp_srk INTEGER PRIMARY KEY,
    dta_completa DATE NOT NULL UNIQUE,
    
    -- Hierarquia Temporal
    ano_lancamento INTEGER NOT NULL,
    mes_numero INTEGER NOT NULL,
    mes_nome VARCHAR(20) NOT NULL,
    mes_abrev CHAR(3) NOT NULL,
    dia_numero INTEGER NOT NULL,
    dia_semana INTEGER NOT NULL,
    nom_dia_semana VARCHAR(20) NOT NULL,
    tri_numero INTEGER NOT NULL,
    tri_nome VARCHAR(10) NOT NULL,
    sem_numero INTEGER NOT NULL,
    dec_inicio INTEGER NOT NULL,
    
    -- Flags
    flg_feriado CHAR(1) DEFAULT 'N',
    flg_fim_semana CHAR(1) NOT NULL,
    
    -- Constraints
    CONSTRAINT chk_mes_numero CHECK (mes_numero BETWEEN 1 AND 12),
    CONSTRAINT chk_dia_numero CHECK (dia_numero BETWEEN 1 AND 31),
    CONSTRAINT chk_dia_semana CHECK (dia_semana BETWEEN 1 AND 7),
    CONSTRAINT chk_tri_numero CHECK (tri_numero BETWEEN 1 AND 4),
    CONSTRAINT chk_flg_feriado CHECK (flg_feriado IN ('S', 'N')),
    CONSTRAINT chk_flg_fim_semana CHECK (flg_fim_semana IN ('S', 'N'))
);

COMMENT ON TABLE gold.dim_tempo IS 'Dimensão de tempo com hierarquia completa (Ano > Trimestre > Mês > Dia)';
COMMENT ON COLUMN gold.dim_tempo.tmp_srk IS 'Surrogate key no formato YYYYMMDD';
COMMENT ON COLUMN gold.dim_tempo.dta_completa IS 'Data completa';
COMMENT ON COLUMN gold.dim_tempo.dec_inicio IS 'Início da década (1990, 2000, 2010...)';

-- Índices
CREATE INDEX idx_dim_tempo_ano ON gold.dim_tempo(ano_lancamento);
CREATE INDEX idx_dim_tempo_decada ON gold.dim_tempo(dec_inicio);

-- ============================================================
-- 3. DIMENSÃO: DIM_GENERO
-- ============================================================

CREATE TABLE IF NOT EXISTS gold.dim_genero (
    -- Chaves
    gnr_srk SERIAL PRIMARY KEY,
    
    -- Atributos
    gnr_nome VARCHAR(100) NOT NULL UNIQUE,
    gnr_descricao TEXT,
    gnr_categoria VARCHAR(50)
);

COMMENT ON TABLE gold.dim_genero IS 'Dimensão de gêneros cinematográficos';
COMMENT ON COLUMN gold.dim_genero.gnr_srk IS 'Surrogate key';
COMMENT ON COLUMN gold.dim_genero.gnr_nome IS 'Nome do gênero (Action, Drama, Comedy...)';

-- Índices
CREATE INDEX idx_dim_genero_nome ON gold.dim_genero(gnr_nome);

-- ============================================================
-- 4. DIMENSÃO: DIM_COMPANHIA
-- ============================================================

CREATE TABLE IF NOT EXISTS gold.dim_companhia (
    -- Chaves
    cmp_srk SERIAL PRIMARY KEY,
    
    -- Atributos
    cmp_nome VARCHAR(255) NOT NULL,
    cmp_tipo VARCHAR(50) DEFAULT 'Produtora'
);

COMMENT ON TABLE gold.dim_companhia IS 'Dimensão de companhias produtoras';
COMMENT ON COLUMN gold.dim_companhia.cmp_srk IS 'Surrogate key';
COMMENT ON COLUMN gold.dim_companhia.cmp_nome IS 'Nome da companhia (Warner Bros, Universal...)';

-- Índices
CREATE INDEX idx_dim_companhia_nome ON gold.dim_companhia(cmp_nome);

-- ============================================================
-- 5. DIMENSÃO: DIM_GEOGRAFIA
-- ============================================================

CREATE TABLE IF NOT EXISTS gold.dim_geografia (
    -- Chaves
    geo_srk SERIAL PRIMARY KEY,
    
    -- Atributos
    geo_pais VARCHAR(100) NOT NULL UNIQUE,
    geo_codigo_iso CHAR(2),
    geo_continente VARCHAR(50),
    geo_regiao VARCHAR(100)
);

COMMENT ON TABLE gold.dim_geografia IS 'Dimensão geográfica com hierarquia (Continente > Região > País)';
COMMENT ON COLUMN gold.dim_geografia.geo_srk IS 'Surrogate key';
COMMENT ON COLUMN gold.dim_geografia.geo_pais IS 'Nome do país';
COMMENT ON COLUMN gold.dim_geografia.geo_codigo_iso IS 'Código ISO 3166 (US, FR, BR...)';

-- Índices
CREATE INDEX idx_dim_geografia_pais ON gold.dim_geografia(geo_pais);
CREATE INDEX idx_dim_geografia_continente ON gold.dim_geografia(geo_continente);
CREATE INDEX idx_dim_geografia_codigo ON gold.dim_geografia(geo_codigo_iso);

-- ============================================================
-- 6. DIMENSÃO: DIM_DIRETOR
-- ============================================================

CREATE TABLE IF NOT EXISTS gold.dim_diretor (
    -- Chaves
    dir_srk SERIAL PRIMARY KEY,
    
    -- Atributos
    dir_nome VARCHAR(255) NOT NULL,
    dir_nome_completo VARCHAR(500)
);

COMMENT ON TABLE gold.dim_diretor IS 'Dimensão de diretores';
COMMENT ON COLUMN gold.dim_diretor.dir_srk IS 'Surrogate key';
COMMENT ON COLUMN gold.dim_diretor.dir_nome IS 'Nome do diretor';

-- Índices
CREATE INDEX idx_dim_diretor_nome ON gold.dim_diretor(dir_nome);

-- ============================================================
-- 7. DIMENSÃO: DIM_ATOR
-- ============================================================

CREATE TABLE IF NOT EXISTS gold.dim_ator (
    -- Chaves
    act_srk SERIAL PRIMARY KEY,
    
    -- Atributos
    act_nome VARCHAR(255) NOT NULL,
    act_nome_completo VARCHAR(500)
);

COMMENT ON TABLE gold.dim_ator IS 'Dimensão de atores principais';
COMMENT ON COLUMN gold.dim_ator.act_srk IS 'Surrogate key';
COMMENT ON COLUMN gold.dim_ator.act_nome IS 'Nome do ator/atriz';

-- Índices
CREATE INDEX idx_dim_ator_nome ON gold.dim_ator(act_nome);

-- ============================================================
-- 8. DIMENSÃO: DIM_FILME
-- ============================================================

CREATE TABLE IF NOT EXISTS gold.dim_filme (
    -- Chaves
    mov_srk SERIAL PRIMARY KEY,
    mov_nky BIGINT NOT NULL UNIQUE,
    
    -- Identificação
    mov_titulo VARCHAR(500) NOT NULL,
    mov_titulo_original VARCHAR(500),
    cod_idioma VARCHAR(10),
    cod_imdb VARCHAR(20),
    
    -- Descrição
    txt_sinopse TEXT,
    txt_tagline TEXT,
    
    -- URLs
    url_homepage VARCHAR(500),
    url_poster VARCHAR(255),
    
    -- Categorizações
    cat_status VARCHAR(50),
    cat_orcamento VARCHAR(50),
    cat_receita VARCHAR(50),
    cat_duracao VARCHAR(50)
);

COMMENT ON TABLE gold.dim_filme IS 'Dimensão de filmes com informações descritivas';
COMMENT ON COLUMN gold.dim_filme.mov_srk IS 'Surrogate key';
COMMENT ON COLUMN gold.dim_filme.mov_nky IS 'Natural key (ID original do filme)';
COMMENT ON COLUMN gold.dim_filme.mov_titulo IS 'Título do filme';
COMMENT ON COLUMN gold.dim_filme.cod_imdb IS 'ID IMDB (formato: tt1234567)';

-- Índices
CREATE INDEX idx_dim_filme_titulo ON gold.dim_filme(mov_titulo);
CREATE INDEX idx_dim_filme_imdb ON gold.dim_filme(cod_imdb);

-- ============================================================
-- 9. TABELA FATO: FTO_FILME
-- ============================================================

CREATE TABLE IF NOT EXISTS gold.fto_filme (
    -- Chave Primária
    fto_srk BIGSERIAL PRIMARY KEY,
    
    -- Chaves Estrangeiras (7 dimensões)
    mov_fky INTEGER NOT NULL,
    tmp_fky INTEGER NOT NULL,
    gnr_fky INTEGER NOT NULL,
    cmp_fky INTEGER NOT NULL,
    geo_fky INTEGER NOT NULL,
    dir_fky INTEGER NOT NULL,
    act_fky INTEGER NOT NULL,
    
    -- Métricas Financeiras
    vlr_orcamento NUMERIC(15,2),
    vlr_receita NUMERIC(15,2),
    vlr_lucro NUMERIC(15,2),
    pct_roi NUMERIC(15,3),
    
    -- Métricas de Avaliação
    med_avaliacao NUMERIC(4,2),
    qtd_votos INTEGER,
    med_popularidade NUMERIC(15,3),
    
    -- Métricas de Produção
    dur_minutos NUMERIC(8,2),
    qtd_elenco INTEGER,
    qtd_equipe INTEGER,
    
    -- Flags
    flg_adulto CHAR(1),
    flg_blockbuster CHAR(1),
    
    -- Foreign Keys
    CONSTRAINT fk_fto_filme_filme 
        FOREIGN KEY (mov_fky) REFERENCES gold.dim_filme(mov_srk),
    CONSTRAINT fk_fto_filme_tempo 
        FOREIGN KEY (tmp_fky) REFERENCES gold.dim_tempo(tmp_srk),
    CONSTRAINT fk_fto_filme_genero 
        FOREIGN KEY (gnr_fky) REFERENCES gold.dim_genero(gnr_srk),
    CONSTRAINT fk_fto_filme_companhia 
        FOREIGN KEY (cmp_fky) REFERENCES gold.dim_companhia(cmp_srk),
    CONSTRAINT fk_fto_filme_geografia 
        FOREIGN KEY (geo_fky) REFERENCES gold.dim_geografia(geo_srk),
    CONSTRAINT fk_fto_filme_diretor 
        FOREIGN KEY (dir_fky) REFERENCES gold.dim_diretor(dir_srk),
    CONSTRAINT fk_fto_filme_ator 
        FOREIGN KEY (act_fky) REFERENCES gold.dim_ator(act_srk),
    
    -- Check Constraints
    CONSTRAINT chk_flg_adulto CHECK (flg_adulto IN ('S', 'N') OR flg_adulto IS NULL),
    CONSTRAINT chk_flg_blockbuster CHECK (flg_blockbuster IN ('S', 'N') OR flg_blockbuster IS NULL)
);

COMMENT ON TABLE gold.fto_filme IS 'Tabela fato central do Star Schema com métricas de filmes';
COMMENT ON COLUMN gold.fto_filme.fto_srk IS 'Surrogate key da fato';
COMMENT ON COLUMN gold.fto_filme.vlr_orcamento IS 'Orçamento em USD';
COMMENT ON COLUMN gold.fto_filme.vlr_receita IS 'Receita em USD';
COMMENT ON COLUMN gold.fto_filme.vlr_lucro IS 'Lucro (receita - orçamento)';
COMMENT ON COLUMN gold.fto_filme.pct_roi IS 'Retorno sobre investimento em percentual';
COMMENT ON COLUMN gold.fto_filme.med_avaliacao IS 'Média de avaliação (0-10)';
COMMENT ON COLUMN gold.fto_filme.flg_blockbuster IS 'S se receita >= 100M USD';

-- Índices nas Foreign Keys
CREATE INDEX idx_fto_filme_filme ON gold.fto_filme(mov_fky);
CREATE INDEX idx_fto_filme_tempo ON gold.fto_filme(tmp_fky);
CREATE INDEX idx_fto_filme_genero ON gold.fto_filme(gnr_fky);
CREATE INDEX idx_fto_filme_companhia ON gold.fto_filme(cmp_fky);
CREATE INDEX idx_fto_filme_geografia ON gold.fto_filme(geo_fky);
CREATE INDEX idx_fto_filme_diretor ON gold.fto_filme(dir_fky);
CREATE INDEX idx_fto_filme_ator ON gold.fto_filme(act_fky);

-- Índices Compostos para Queries Comuns
CREATE INDEX idx_fto_genero_tempo ON gold.fto_filme(gnr_fky, tmp_fky);
CREATE INDEX idx_fto_diretor_tempo ON gold.fto_filme(dir_fky, tmp_fky);
CREATE INDEX idx_fto_geografia_genero ON gold.fto_filme(geo_fky, gnr_fky);

-- ============================================================
-- 10. INSERIR REGISTROS "DESCONHECIDO" NAS DIMENSÕES
-- ============================================================

-- DIM_TEMPO: Data desconhecida (1900-01-01)
INSERT INTO gold.dim_tempo (tmp_srk, dta_completa, ano_lancamento, mes_numero, mes_nome, mes_abrev, 
    dia_numero, dia_semana, nom_dia_semana, tri_numero, tri_nome, sem_numero, dec_inicio, flg_feriado, flg_fim_semana)
VALUES (
    -1, '1900-01-01', 1900, 1, 'Janeiro', 'JAN', 
    1, 2, 'Segunda-feira', 1, 'Q1', 1, 1900, 'N', 'N'
)
ON CONFLICT (tmp_srk) DO NOTHING;

-- DIM_GENERO: Gênero desconhecido
INSERT INTO gold.dim_genero (gnr_srk, gnr_nome, gnr_descricao, gnr_categoria)
VALUES (-1, 'Desconhecido', 'Gênero não especificado', 'Outros')
ON CONFLICT (gnr_srk) DO NOTHING;

-- DIM_COMPANHIA: Companhia desconhecida
INSERT INTO gold.dim_companhia (cmp_srk, cmp_nome, cmp_tipo)
VALUES (-1, 'Desconhecida', 'Produtora')
ON CONFLICT (cmp_srk) DO NOTHING;

-- DIM_GEOGRAFIA: País desconhecido
INSERT INTO gold.dim_geografia (geo_srk, geo_pais, geo_codigo_iso, geo_continente, geo_regiao)
VALUES (-1, 'Desconhecido', 'XX', 'Desconhecido', 'Desconhecida')
ON CONFLICT (geo_srk) DO NOTHING;

-- DIM_DIRETOR: Diretor desconhecido
INSERT INTO gold.dim_diretor (dir_srk, dir_nome, dir_nome_completo)
VALUES (-1, 'Desconhecido', 'Diretor Não Especificado')
ON CONFLICT (dir_srk) DO NOTHING;

-- DIM_ATOR: Ator desconhecido
INSERT INTO gold.dim_ator (act_srk, act_nome, act_nome_completo)
VALUES (-1, 'Desconhecido', 'Ator Não Especificado')
ON CONFLICT (act_srk) DO NOTHING;

-- DIM_FILME: Filme desconhecido
INSERT INTO gold.dim_filme (mov_srk, mov_nky, mov_titulo, mov_titulo_original, cod_idioma)
VALUES (-1, -1, 'Desconhecido', 'Unknown', 'XX')
ON CONFLICT (mov_srk) DO NOTHING;

-- ============================================================
-- 11. GRANTS (PERMISSÕES)
-- ============================================================

GRANT ALL PRIVILEGES ON SCHEMA gold TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA gold TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA gold TO postgres;

-- ============================================================
-- 12. ESTATÍSTICAS E ANÁLISE
-- ============================================================

-- Atualizar estatísticas do PostgreSQL
ANALYZE gold.dim_tempo;
ANALYZE gold.dim_genero;
ANALYZE gold.dim_companhia;
ANALYZE gold.dim_geografia;
ANALYZE gold.dim_diretor;
ANALYZE gold.dim_ator;
ANALYZE gold.dim_filme;
ANALYZE gold.fto_filme;

-- ============================================================
-- 13. VIEWS ANALÍTICAS (OPCIONAL)
-- ============================================================

-- View: Visão completa da fato com todas as dimensões
CREATE OR REPLACE VIEW gold.vw_fato_completa AS
SELECT 
    -- Fato
    f.fto_srk,
    
    -- Filme
    m.mov_titulo,
    m.mov_titulo_original,
    m.cod_imdb,
    m.cat_status,
    
    -- Tempo
    t.dta_completa,
    t.ano_lancamento,
    t.mes_nome,
    t.tri_nome,
    t.dec_inicio,
    
    -- Gênero
    g.gnr_nome AS genero,
    
    -- Companhia
    c.cmp_nome AS companhia,
    
    -- Geografia
    geo.geo_pais AS pais,
    geo.geo_continente AS continente,
    
    -- Diretor
    d.dir_nome AS diretor,
    
    -- Ator
    a.act_nome AS ator_principal,
    
    -- Métricas Financeiras
    f.vlr_orcamento,
    f.vlr_receita,
    f.vlr_lucro,
    f.pct_roi,
    
    -- Métricas de Avaliação
    f.med_avaliacao,
    f.qtd_votos,
    f.med_popularidade,
    
    -- Métricas de Produção
    f.dur_minutos,
    f.qtd_elenco,
    f.qtd_equipe,
    
    -- Flags
    f.flg_adulto,
    f.flg_blockbuster
FROM gold.fto_filme f
INNER JOIN gold.dim_filme m ON f.mov_fky = m.mov_srk
INNER JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
INNER JOIN gold.dim_genero g ON f.gnr_fky = g.gnr_srk
INNER JOIN gold.dim_companhia c ON f.cmp_fky = c.cmp_srk
INNER JOIN gold.dim_geografia geo ON f.geo_fky = geo.geo_srk
INNER JOIN gold.dim_diretor d ON f.dir_fky = d.dir_srk
INNER JOIN gold.dim_ator a ON f.act_fky = a.act_srk;

COMMENT ON VIEW gold.vw_fato_completa IS 'View desnormalizada da fato com todas as dimensões para facilitar análises';

-- ============================================================
-- 14. MENSAGENS DE SUCESSO
-- ============================================================

DO $$
BEGIN
    RAISE NOTICE '============================================================';
    RAISE NOTICE '✅ CAMADA GOLD (Star Schema) criada com sucesso!';
    RAISE NOTICE '============================================================';
    RAISE NOTICE '';
    RAISE NOTICE '📊 TABELAS CRIADAS:';
    RAISE NOTICE '   🌟 FATO:';
    RAISE NOTICE '      - fto_filme (Tabela fato central)';
    RAISE NOTICE '';
    RAISE NOTICE '   📦 DIMENSÕES (7):';
    RAISE NOTICE '      - dim_tempo (Dimensão temporal)';
    RAISE NOTICE '      - dim_filme (Filmes)';
    RAISE NOTICE '      - dim_genero (Gêneros)';
    RAISE NOTICE '      - dim_companhia (Produtoras)';
    RAISE NOTICE '      - dim_geografia (Países)';
    RAISE NOTICE '      - dim_diretor (Diretores)';
    RAISE NOTICE '      - dim_ator (Atores)';
    RAISE NOTICE '';
    RAISE NOTICE '   📊 VIEW:';
    RAISE NOTICE '      - vw_fato_completa (Visão desnormalizada)';
    RAISE NOTICE '';
    RAISE NOTICE '🔑 REGISTROS "DESCONHECIDO" INSERIDOS (srk = -1)';
    RAISE NOTICE '📈 ÍNDICES CRIADOS (29 índices)';
    RAISE NOTICE '🔗 FOREIGN KEYS CONFIGURADAS (7 FKs)';
    RAISE NOTICE '';
    RAISE NOTICE '🚀 PRÓXIMOS PASSOS:';
    RAISE NOTICE '   1. Popular dimensões (ETL SILVER → GOLD)';
    RAISE NOTICE '   2. Carregar tabela fato';
    RAISE NOTICE '   3. Validar integridade';
    RAISE NOTICE '   4. Executar consultas analíticas';
    RAISE NOTICE '   5. Conectar ao Power BI';
    RAISE NOTICE '============================================================';
END $$;

-- ============================================================
-- FIM DO SCRIPT DDL GOLD
-- ============================================================
