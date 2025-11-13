-- ============================================================================
-- DDL - Data Definition Language (Camada Silver)
-- Sistema de Análise de Filmes
-- Versão: 1.0
-- Data: 2024
-- ============================================================================

-- Configurações iniciais
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- ============================================================================
-- Criação do Database (se não existir)
-- ============================================================================

CREATE DATABASE IF NOT EXISTS `movies_db`
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE `movies_db`;

-- ============================================================================
-- Tabela: MOVIES
-- Descrição: Armazena informações detalhadas sobre filmes
-- ============================================================================

DROP TABLE IF EXISTS `movies`;

CREATE TABLE `movies` (
    -- Chave Primária
    `id` INT NOT NULL COMMENT 'Identificador único do filme (TMDB ID)',
    
    -- Informações Básicas
    `title` VARCHAR(500) NOT NULL COMMENT 'Título do filme',
    `overview` TEXT DEFAULT NULL COMMENT 'Sinopse/resumo do filme',
    `release_date` DATE DEFAULT NULL COMMENT 'Data de lançamento do filme',
    
    -- Informações Financeiras
    `budget` BIGINT DEFAULT 0 COMMENT 'Orçamento de produção em USD',
    `revenue` BIGINT DEFAULT 0 COMMENT 'Receita de bilheteria em USD',
    
    -- Métricas e Avaliações
    `runtime` FLOAT DEFAULT NULL COMMENT 'Duração do filme em minutos',
    `popularity` FLOAT DEFAULT 0.0 COMMENT 'Métrica de popularidade do TMDB',
    `vote_average` DECIMAL(4, 2) DEFAULT NULL COMMENT 'Nota média (0-10)',
    `vote_count` INT DEFAULT 0 COMMENT 'Número total de votos',
    
    -- Status e Metadata
    `status` VARCHAR(50) DEFAULT NULL COMMENT 'Status do filme (Released, Post Production, etc)',
    `tagline` TEXT DEFAULT NULL COMMENT 'Slogan/frase de efeito do filme',
    
    -- Identificadores Externos
    `imdb_id` VARCHAR(20) DEFAULT NULL COMMENT 'ID do filme no IMDb (formato: ttXXXXXXX)',
    `original_language` VARCHAR(10) DEFAULT NULL COMMENT 'Código ISO 639-1 do idioma original',
    
    -- Informações Categóricas (Desnormalizadas)
    `genres` TEXT DEFAULT NULL COMMENT 'Lista de gêneros separados por vírgula',
    `production_companies` TEXT DEFAULT NULL COMMENT 'Lista de produtoras separadas por vírgula',
    `production_countries` TEXT DEFAULT NULL COMMENT 'Lista de países produtores separados por vírgula',
    `spoken_languages` TEXT DEFAULT NULL COMMENT 'Lista de idiomas falados separados por vírgula',
    `belongs_to_collection` TEXT DEFAULT NULL COMMENT 'Nome da coleção/franquia (se aplicável)',
    
    -- Constraints
    PRIMARY KEY (`id`),
    
    -- Constraints de validação
    CONSTRAINT `CHK_BUDGET` CHECK (`budget` >= 0),
    CONSTRAINT `CHK_REVENUE` CHECK (`revenue` >= 0),
    CONSTRAINT `CHK_RUNTIME` CHECK (`runtime` IS NULL OR `runtime` >= 0),
    CONSTRAINT `CHK_VOTE_AVERAGE` CHECK (`vote_average` IS NULL OR (`vote_average` >= 0 AND `vote_average` <= 10))
    
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Tabela principal de filmes - Camada Silver';

-- ============================================================================
-- Índices para a tabela MOVIES
-- ============================================================================

CREATE INDEX `idx_release_date` ON `movies` (`release_date` ASC) 
    COMMENT 'Índice para consultas por período/ano';

CREATE INDEX `idx_popularity` ON `movies` (`popularity` DESC) 
    COMMENT 'Índice para ordenação por popularidade';

CREATE INDEX `idx_vote_average` ON `movies` (`vote_average` DESC) 
    COMMENT 'Índice para consultas de filmes bem avaliados';

CREATE INDEX `idx_title` ON `movies` (`title`(100) ASC) 
    COMMENT 'Índice prefix para buscas por título';

CREATE INDEX `idx_status` ON `movies` (`status` ASC) 
    COMMENT 'Índice para filtros por status do filme';

-- ============================================================================
-- Tabela: RATINGS
-- Descrição: Armazena avaliações de filmes feitas por usuários
-- ============================================================================

DROP TABLE IF EXISTS `ratings`;

CREATE TABLE `ratings` (
    -- Chaves Primárias Compostas
    `user_id` INT NOT NULL COMMENT 'Identificador do usuário que avaliou',
    `movie_id` INT NOT NULL COMMENT 'Identificador do filme avaliado',
    
    -- Dados da Avaliação
    `rating` DECIMAL(3, 1) NOT NULL COMMENT 'Nota atribuída (0.5 a 5.0)',
    `rating_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data e hora da avaliação',
    
    -- Constraints
    PRIMARY KEY (`user_id`, `movie_id`),
    
    -- Chave Estrangeira (FK para tabela movies)
    CONSTRAINT `FK_RATINGS_MOVIES` 
        FOREIGN KEY (`movie_id`) 
        REFERENCES `movies` (`id`)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    
    -- Constraints de validação
    CONSTRAINT `CHK_RATING_RANGE` CHECK (`rating` >= 0.5 AND `rating` <= 5.0),
    CONSTRAINT `CHK_RATING_INCREMENT` CHECK ((`rating` * 10) % 5 = 0)
    
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Tabela de avaliações de usuários - Camada Silver';

-- ============================================================================
-- Índices para a tabela RATINGS
-- ============================================================================

CREATE INDEX `idx_movie_id` ON `ratings` (`movie_id` ASC) 
    COMMENT 'FK index - otimiza joins com movies';

CREATE INDEX `idx_rating_timestamp` ON `ratings` (`rating_timestamp` DESC) 
    COMMENT 'Índice para análises temporais';

CREATE INDEX `idx_rating` ON `ratings` (`rating` DESC) 
    COMMENT 'Índice para consultas por faixa de nota';

-- ============================================================================
-- Views Úteis
-- ============================================================================

-- View: Filmes com estatísticas de avaliação
DROP VIEW IF EXISTS `v_movies_with_stats`;

CREATE VIEW `v_movies_with_stats` AS
SELECT 
    m.id,
    m.title,
    m.release_date,
    m.genres,
    m.budget,
    m.revenue,
    m.popularity,
    m.vote_average AS tmdb_vote_average,
    m.vote_count AS tmdb_vote_count,
    COUNT(r.rating) AS user_ratings_count,
    AVG(r.rating) AS user_avg_rating,
    MIN(r.rating) AS user_min_rating,
    MAX(r.rating) AS user_max_rating,
    CASE 
        WHEN m.revenue > 0 AND m.budget > 0 
        THEN ROUND((m.revenue - m.budget) / m.budget * 100, 2)
        ELSE NULL 
    END AS roi_percentage
FROM movies m
LEFT JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.title, m.release_date, m.genres, m.budget, m.revenue, 
         m.popularity, m.vote_average, m.vote_count;

-- View: Top filmes por ano
DROP VIEW IF EXISTS `v_top_movies_by_year`;

CREATE VIEW `v_top_movies_by_year` AS
SELECT 
    YEAR(release_date) AS year,
    id,
    title,
    vote_average,
    popularity,
    revenue,
    genres
FROM movies
WHERE release_date IS NOT NULL
ORDER BY YEAR(release_date) DESC, vote_average DESC, popularity DESC;

-- View: Distribuição de gêneros
DROP VIEW IF EXISTS `v_genre_distribution`;

CREATE VIEW `v_genre_distribution` AS
SELECT 
    YEAR(release_date) AS year,
    genres,
    COUNT(*) AS movie_count,
    AVG(vote_average) AS avg_rating,
    AVG(revenue) AS avg_revenue,
    AVG(budget) AS avg_budget
FROM movies
WHERE genres IS NOT NULL AND genres != ''
GROUP BY YEAR(release_date), genres
ORDER BY year DESC, movie_count DESC;

-- ============================================================================
-- Procedures Úteis
-- ============================================================================

-- Procedure: Limpar tabelas para recarga
DROP PROCEDURE IF EXISTS `sp_truncate_tables`;

DELIMITER $$

CREATE PROCEDURE `sp_truncate_tables`()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    TRUNCATE TABLE `ratings`;
    TRUNCATE TABLE `movies`;
    SET FOREIGN_KEY_CHECKS = 1;
    SELECT 'Tabelas limpas com sucesso!' AS message;
END$$

DELIMITER ;

-- Procedure: Estatísticas gerais do banco
DROP PROCEDURE IF EXISTS `sp_database_stats`;

DELIMITER $$

CREATE PROCEDURE `sp_database_stats`()
BEGIN
    SELECT 
        'MOVIES' AS table_name,
        COUNT(*) AS total_records,
        COUNT(DISTINCT id) AS unique_ids,
        MIN(release_date) AS earliest_movie,
        MAX(release_date) AS latest_movie,
        ROUND(AVG(budget), 2) AS avg_budget,
        ROUND(AVG(revenue), 2) AS avg_revenue,
        ROUND(AVG(vote_average), 2) AS avg_rating
    FROM movies
    
    UNION ALL
    
    SELECT 
        'RATINGS' AS table_name,
        COUNT(*) AS total_records,
        COUNT(DISTINCT user_id) AS unique_users,
        MIN(rating_timestamp) AS earliest_rating,
        MAX(rating_timestamp) AS latest_rating,
        ROUND(AVG(rating), 2) AS avg_rating,
        NULL AS avg_revenue,
        NULL AS avg_rating_tmdb
    FROM ratings;
END$$

DELIMITER ;

-- ============================================================================
-- Triggers
-- ============================================================================

-- Trigger removido para permitir carga de dados (alguns filmes têm título vazio nos dados brutos)
-- Se necessário reativar após a carga inicial
/*
DROP TRIGGER IF EXISTS `trg_movies_before_insert`;

DELIMITER $$

CREATE TRIGGER `trg_movies_before_insert`
BEFORE INSERT ON `movies`
FOR EACH ROW
BEGIN
    -- Validar que a data não seja futura (opcional)
    IF NEW.release_date > CURDATE() THEN
        SET NEW.status = 'Planned';
    END IF;
    
    -- Garantir que valores vazios sejam NULL
    IF NEW.title = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Título não pode ser vazio';
    END IF;
END$$

DELIMITER ;
*/

-- ============================================================================
-- Grants e Permissões (exemplo)
-- ============================================================================

-- Usuário de aplicação (somente leitura em movies, completo em ratings)
-- CREATE USER IF NOT EXISTS 'app_user'@'%' IDENTIFIED BY 'app_password';
-- GRANT SELECT ON movies_db.movies TO 'app_user'@'%';
-- GRANT SELECT, INSERT, UPDATE ON movies_db.ratings TO 'app_user'@'%';
-- FLUSH PRIVILEGES;

-- ============================================================================
-- Restaurar configurações
-- ============================================================================

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- ============================================================================
-- Mensagem de conclusão
-- ============================================================================

SELECT '✅ DDL executado com sucesso!' AS status,
       'Tabelas MOVIES e RATINGS criadas' AS message,
       '3 Views e 2 Procedures adicionadas' AS extras;
