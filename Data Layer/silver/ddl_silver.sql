-- ============================================================
-- DDL - CAMADA SILVER
-- Projeto: Bancos de Dados 2 - Arquitetura Medallion
-- Data: 2025-11-23
-- ============================================================
-- Descrição: Script de criação da tabela da camada SILVER
-- A camada SILVER contém UMA ÚNICA TABELA com dados limpos,
-- transformados e prontos para consumo analítico.
-- ============================================================

-- ============================================================
-- 1. CRIAR SCHEMA SILVER
-- ============================================================

CREATE SCHEMA IF NOT EXISTS silver;

COMMENT ON SCHEMA silver IS 'Camada SILVER - Dados limpos e transformados em uma única tabela desnormalizada';

-- ============================================================
-- 2. TABELA: silver.movies_raw
-- ============================================================
-- Descrição: TABELA ÚNICA com TODAS as informações de filmes
-- Estrutura: Totalmente desnormalizada para facilitar queries
-- Transformações aplicadas:
--   - Conversão de tipos de dados
--   - Categorização de budget, revenue e runtime
--   - Extração de ano, mês e década
--   - Cálculo de profit e ROI
--   - Extração de gênero/companhia/país primários
--   - Informações de créditos (diretor, atores)
--   - Estatísticas agregadas de ratings
--   - Keywords processadas
--   - Links entre plataformas (IMDB, TMDB)
-- ============================================================

CREATE TABLE IF NOT EXISTS silver.movies_raw (
    -- ========== IDENTIFICADORES ==========
    id INTEGER PRIMARY KEY,
    
    -- ========== INFORMAÇÕES BÁSICAS ==========
    title VARCHAR(500),
    original_title VARCHAR(500),
    original_language VARCHAR(10),
    
    -- ========== DATAS ==========
    release_date DATE,
    release_year INTEGER,
    release_month INTEGER,
    release_decade INTEGER,
    
    -- ========== MÉTRICAS FINANCEIRAS ==========
    budget BIGINT,
    revenue BIGINT,
    profit BIGINT,
    roi NUMERIC(15,2),
    budget_category VARCHAR(50),
    revenue_category VARCHAR(50),
    
    -- ========== DURAÇÃO ==========
    runtime NUMERIC(10,2),
    runtime_category VARCHAR(50),
    
    -- ========== AVALIAÇÕES E POPULARIDADE ==========
    vote_average NUMERIC(3,1),
    vote_count INTEGER,
    popularity NUMERIC(10,3),
    
    -- ========== GÊNEROS ==========
    genres_list TEXT,
    primary_genre VARCHAR(100),
    
    -- ========== PRODUÇÃO ==========
    production_companies_list TEXT,
    primary_company VARCHAR(200),
    production_countries_list TEXT,
    primary_country VARCHAR(100),
    
    -- ========== STATUS E METADADOS ==========
    status VARCHAR(50),
    adult BOOLEAN,
    overview TEXT,
    tagline TEXT,
    homepage TEXT,
    imdb_id VARCHAR(20),
    poster_path VARCHAR(200),
    
    -- ========== CRÉDITOS (ELENCO E EQUIPE) ==========
    director VARCHAR(200),
    lead_actor VARCHAR(200),
    top_actors TEXT,
    cast_size INTEGER,
    crew_size INTEGER,
    
    -- ========== KEYWORDS ==========
    keywords_list TEXT,
    keywords_count INTEGER,
    
    -- ========== ESTATÍSTICAS DE RATINGS ==========
    avg_rating NUMERIC(3,2),
    median_rating NUMERIC(3,2),
    std_rating NUMERIC(3,2),
    total_ratings INTEGER,
    min_rating NUMERIC(3,2),
    max_rating NUMERIC(3,2),
    unique_users INTEGER,
    
    -- ========== LINKS ENTRE PLATAFORMAS ==========
    tmdb_id INTEGER,
    imdb_id_formatted VARCHAR(20)
);

-- ============================================================
-- 3. COMENTÁRIOS
-- ============================================================

COMMENT ON TABLE silver.movies_raw IS 'Tabela única desnormalizada com TODAS as informações de filmes da camada SILVER';

-- Identificadores
COMMENT ON COLUMN silver.movies_raw.id IS 'ID único do filme (chave primária)';

-- Informações Básicas
COMMENT ON COLUMN silver.movies_raw.title IS 'Título do filme';
COMMENT ON COLUMN silver.movies_raw.original_title IS 'Título original do filme';
COMMENT ON COLUMN silver.movies_raw.original_language IS 'Código ISO do idioma original';

-- Datas
COMMENT ON COLUMN silver.movies_raw.release_date IS 'Data de lançamento';
COMMENT ON COLUMN silver.movies_raw.release_year IS 'Ano de lançamento (extraído de release_date)';
COMMENT ON COLUMN silver.movies_raw.release_month IS 'Mês de lançamento (1-12)';
COMMENT ON COLUMN silver.movies_raw.release_decade IS 'Década de lançamento (1990, 2000, 2010...)';

-- Métricas Financeiras
COMMENT ON COLUMN silver.movies_raw.budget IS 'Orçamento em USD';
COMMENT ON COLUMN silver.movies_raw.revenue IS 'Receita em USD';
COMMENT ON COLUMN silver.movies_raw.profit IS 'Lucro calculado (revenue - budget)';
COMMENT ON COLUMN silver.movies_raw.roi IS 'Retorno sobre investimento (%) calculado ((profit/budget)*100)';
COMMENT ON COLUMN silver.movies_raw.budget_category IS 'Categoria de orçamento (Low, Medium, High, Ultra High)';
COMMENT ON COLUMN silver.movies_raw.revenue_category IS 'Categoria de receita (Low, Medium, High, Blockbuster)';

-- Duração
COMMENT ON COLUMN silver.movies_raw.runtime IS 'Duração em minutos';
COMMENT ON COLUMN silver.movies_raw.runtime_category IS 'Categoria de duração (Short, Medium, Long, Very Long)';

-- Avaliações
COMMENT ON COLUMN silver.movies_raw.vote_average IS 'Média de votos (0-10)';
COMMENT ON COLUMN silver.movies_raw.vote_count IS 'Quantidade de votos';
COMMENT ON COLUMN silver.movies_raw.popularity IS 'Score de popularidade';

-- Gêneros
COMMENT ON COLUMN silver.movies_raw.genres_list IS 'Lista completa de gêneros (JSON)';
COMMENT ON COLUMN silver.movies_raw.primary_genre IS 'Gênero principal (primeiro da lista)';

-- Produção
COMMENT ON COLUMN silver.movies_raw.production_companies_list IS 'Lista de produtoras (JSON)';
COMMENT ON COLUMN silver.movies_raw.primary_company IS 'Produtora principal (primeira da lista)';
COMMENT ON COLUMN silver.movies_raw.production_countries_list IS 'Lista de países produtores (JSON)';
COMMENT ON COLUMN silver.movies_raw.primary_country IS 'País principal (primeiro da lista)';

-- Status e Metadados
COMMENT ON COLUMN silver.movies_raw.status IS 'Status de lançamento (Released, Rumored, etc)';
COMMENT ON COLUMN silver.movies_raw.adult IS 'Indicador de conteúdo adulto';
COMMENT ON COLUMN silver.movies_raw.overview IS 'Sinopse do filme';
COMMENT ON COLUMN silver.movies_raw.tagline IS 'Slogan do filme';
COMMENT ON COLUMN silver.movies_raw.homepage IS 'URL do site oficial';
COMMENT ON COLUMN silver.movies_raw.imdb_id IS 'ID no IMDB';
COMMENT ON COLUMN silver.movies_raw.poster_path IS 'Caminho do poster';

-- Créditos
COMMENT ON COLUMN silver.movies_raw.director IS 'Nome do diretor principal';
COMMENT ON COLUMN silver.movies_raw.lead_actor IS 'Nome do ator/atriz principal';
COMMENT ON COLUMN silver.movies_raw.top_actors IS 'Lista dos top 5 atores (JSON)';
COMMENT ON COLUMN silver.movies_raw.cast_size IS 'Tamanho do elenco';
COMMENT ON COLUMN silver.movies_raw.crew_size IS 'Tamanho da equipe de produção';

-- Keywords
COMMENT ON COLUMN silver.movies_raw.keywords_list IS 'Lista de palavras-chave (JSON)';
COMMENT ON COLUMN silver.movies_raw.keywords_count IS 'Quantidade de keywords';

-- Estatísticas de Ratings
COMMENT ON COLUMN silver.movies_raw.avg_rating IS 'Média das avaliações de usuários (0-5)';
COMMENT ON COLUMN silver.movies_raw.median_rating IS 'Mediana das avaliações';
COMMENT ON COLUMN silver.movies_raw.std_rating IS 'Desvio padrão das avaliações';
COMMENT ON COLUMN silver.movies_raw.total_ratings IS 'Total de avaliações recebidas';
COMMENT ON COLUMN silver.movies_raw.min_rating IS 'Avaliação mínima recebida';
COMMENT ON COLUMN silver.movies_raw.max_rating IS 'Avaliação máxima recebida';
COMMENT ON COLUMN silver.movies_raw.unique_users IS 'Número de usuários únicos que avaliaram';

-- Links
COMMENT ON COLUMN silver.movies_raw.tmdb_id IS 'ID no The Movie Database (TMDB)';
COMMENT ON COLUMN silver.movies_raw.imdb_id_formatted IS 'ID do IMDB formatado com prefixo tt';

-- ============================================================
-- 4. ÍNDICES PARA PERFORMANCE
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_movies_raw_year ON silver.movies_raw(release_year);
CREATE INDEX IF NOT EXISTS idx_movies_raw_genre ON silver.movies_raw(primary_genre);
CREATE INDEX IF NOT EXISTS idx_movies_raw_director ON silver.movies_raw(director);

-- ============================================================
-- 5. GRANTS (PERMISSÕES)
-- ============================================================

GRANT ALL PRIVILEGES ON SCHEMA silver TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA silver TO postgres;

-- ============================================================
-- FIM DO SCRIPT DDL SILVER
-- ============================================================
