-- ============================================================================
-- SCHEMA SILVER LAYER - Sistema de Análise de Filmes
-- Versão Simplificada
-- ============================================================================

-- Tabela: MOVIES
-- Descrição: Armazena informações completas sobre filmes
CREATE TABLE movies (
    -- Chave Primária
    id INT PRIMARY KEY COMMENT 'ID único do filme (TMDB)',
    
    -- Informações Básicas
    title VARCHAR(500) NOT NULL COMMENT 'Título do filme',
    overview TEXT COMMENT 'Sinopse do filme',
    release_date DATE COMMENT 'Data de lançamento',
    
    -- Informações Financeiras
    budget BIGINT DEFAULT 0 COMMENT 'Orçamento em USD',
    revenue BIGINT DEFAULT 0 COMMENT 'Receita em USD',
    
    -- Métricas
    runtime FLOAT COMMENT 'Duração em minutos',
    popularity FLOAT DEFAULT 0 COMMENT 'Popularidade (TMDB)',
    vote_average DECIMAL(4, 2) COMMENT 'Nota média (0-10)',
    vote_count INT DEFAULT 0 COMMENT 'Número de votos',
    
    -- Metadata
    status VARCHAR(50) COMMENT 'Status (Released, etc)',
    tagline TEXT COMMENT 'Slogan do filme',
    imdb_id VARCHAR(20) COMMENT 'ID no IMDb',
    original_language VARCHAR(10) COMMENT 'Idioma original (ISO 639-1)',
    
    -- Informações Categóricas (Desnormalizadas)
    genres TEXT COMMENT 'Gêneros (separados por vírgula)',
    production_companies TEXT COMMENT 'Produtoras (separadas por vírgula)',
    production_countries TEXT COMMENT 'Países (separados por vírgula)',
    spoken_languages TEXT COMMENT 'Idiomas (separados por vírgula)',
    belongs_to_collection TEXT COMMENT 'Nome da coleção/franquia'
    
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Tabela de filmes - Camada Silver';


-- Tabela: RATINGS
-- Descrição: Avaliações de filmes por usuários
CREATE TABLE ratings (
    -- Chave Primária Composta
    user_id INT NOT NULL COMMENT 'ID do usuário',
    movie_id INT NOT NULL COMMENT 'ID do filme avaliado',
    
    -- Dados da Avaliação
    rating DECIMAL(3, 1) NOT NULL COMMENT 'Nota (0.5 a 5.0)',
    rating_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora da avaliação',

    -- Constraints
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
        
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Tabela de avaliações - Camada Silver';


-- ============================================================================
-- Índices Recomendados (opcional - já criados no ddl_silver.sql)
-- ============================================================================

-- CREATE INDEX idx_release_date ON movies(release_date);
-- CREATE INDEX idx_popularity ON movies(popularity DESC);
-- CREATE INDEX idx_vote_average ON movies(vote_average DESC);
-- CREATE INDEX idx_rating_timestamp ON ratings(rating_timestamp DESC);