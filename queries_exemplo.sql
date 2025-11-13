-- ============================================================================
-- QUERIES DE EXEMPLO - Demonstração PC1
-- Sistema de Análise de Filmes
-- ============================================================================

-- Use estas queries durante a apresentação para demonstrar o sistema

-- ============================================================================
-- 1. VERIFICAÇÕES BÁSICAS
-- ============================================================================

-- Ver todas as tabelas
SHOW TABLES;

-- Ver estrutura das tabelas
DESCRIBE movies;
DESCRIBE ratings;

-- Contagem de registros
SELECT 'movies' AS tabela, COUNT(*) AS total FROM movies
UNION ALL
SELECT 'ratings' AS tabela, COUNT(*) AS total FROM ratings;

-- ============================================================================
-- 2. EXPLORAÇÃO DOS DADOS - MOVIES
-- ============================================================================

-- Primeiros 5 filmes
SELECT id, title, release_date, vote_average, popularity 
FROM movies 
LIMIT 5;

-- Filmes mais populares
SELECT title, popularity, vote_average, release_date
FROM movies 
ORDER BY popularity DESC 
LIMIT 10;

-- Filmes com maior receita
SELECT title, budget, revenue, 
       (revenue - budget) AS profit,
       ROUND((revenue - budget) / budget * 100, 2) AS roi_percent
FROM movies 
WHERE budget > 0 AND revenue > 0
ORDER BY revenue DESC 
LIMIT 10;

-- Filmes por década
SELECT 
    CONCAT(FLOOR(YEAR(release_date) / 10) * 10, 's') AS decade,
    COUNT(*) AS total_movies,
    ROUND(AVG(vote_average), 2) AS avg_rating,
    ROUND(AVG(budget), 0) AS avg_budget,
    ROUND(AVG(revenue), 0) AS avg_revenue
FROM movies
WHERE release_date IS NOT NULL
GROUP BY FLOOR(YEAR(release_date) / 10)
ORDER BY decade DESC;

-- ============================================================================
-- 3. EXPLORAÇÃO DOS DADOS - RATINGS
-- ============================================================================

-- Primeiras 10 avaliações
SELECT user_id, movie_id, rating, rating_timestamp 
FROM ratings 
LIMIT 10;

-- Distribuição de notas
SELECT 
    rating,
    COUNT(*) AS frequency,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ratings), 2) AS percentage
FROM ratings
GROUP BY rating
ORDER BY rating DESC;

-- Usuários mais ativos
SELECT 
    user_id,
    COUNT(*) AS num_ratings,
    AVG(rating) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM ratings
GROUP BY user_id
ORDER BY num_ratings DESC
LIMIT 10;

-- ============================================================================
-- 4. CONSULTAS COM JOIN
-- ============================================================================

-- Filmes mais avaliados (com título)
SELECT 
    m.title,
    COUNT(r.rating) AS num_ratings,
    ROUND(AVG(r.rating), 2) AS avg_user_rating,
    m.vote_average AS tmdb_rating,
    m.release_date
FROM movies m
INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.title, m.vote_average, m.release_date
ORDER BY num_ratings DESC
LIMIT 15;

-- Comparação: avaliação TMDB vs usuários
SELECT 
    m.title,
    m.vote_average AS tmdb_rating,
    ROUND(AVG(r.rating), 2) AS user_rating,
    ROUND(AVG(r.rating) - m.vote_average, 2) AS difference,
    COUNT(r.rating) AS num_ratings
FROM movies m
INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.title, m.vote_average
HAVING COUNT(r.rating) > 20
ORDER BY difference DESC
LIMIT 10;

-- ============================================================================
-- 5. USANDO AS VIEWS
-- ============================================================================

-- Ver todas as views disponíveis
SELECT TABLE_NAME 
FROM information_schema.VIEWS 
WHERE TABLE_SCHEMA = 'movies_db';

-- View: Filmes com estatísticas
SELECT 
    title, 
    release_date,
    tmdb_vote_average,
    user_ratings_count,
    user_avg_rating,
    roi_percentage
FROM v_movies_with_stats
WHERE user_ratings_count > 0
ORDER BY user_ratings_count DESC
LIMIT 10;

-- View: Top filmes por ano
SELECT * 
FROM v_top_movies_by_year 
WHERE year = 2015
LIMIT 10;

-- View: Distribuição de gêneros
SELECT * 
FROM v_genre_distribution 
WHERE year BETWEEN 2010 AND 2015
ORDER BY year DESC, movie_count DESC
LIMIT 20;

-- ============================================================================
-- 6. USANDO AS STORED PROCEDURES
-- ============================================================================

-- Ver procedures disponíveis
SHOW PROCEDURE STATUS WHERE Db = 'movies_db';

-- Executar: Estatísticas gerais do banco
CALL sp_database_stats();

-- ============================================================================
-- 7. ANÁLISES AVANÇADAS
-- ============================================================================

-- Gêneros mais populares (extraindo do campo TEXT)
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ',', 1), ',', -1) AS genre,
    COUNT(*) AS movie_count,
    ROUND(AVG(vote_average), 2) AS avg_rating,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM movies
WHERE genres IS NOT NULL AND genres != ''
GROUP BY SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ',', 1), ',', -1)
ORDER BY movie_count DESC
LIMIT 15;

-- Idiomas mais comuns
SELECT 
    original_language,
    COUNT(*) AS movie_count,
    ROUND(AVG(vote_average), 2) AS avg_rating
FROM movies
WHERE original_language IS NOT NULL
GROUP BY original_language
ORDER BY movie_count DESC
LIMIT 10;

-- Filmes com melhor ROI
SELECT 
    title,
    budget,
    revenue,
    ROUND((revenue - budget) / budget * 100, 2) AS roi_percent,
    release_date
FROM movies
WHERE budget > 1000000 AND revenue > budget
ORDER BY roi_percent DESC
LIMIT 10;

-- Timeline de avaliações
SELECT 
    DATE_FORMAT(rating_timestamp, '%Y-%m') AS month,
    COUNT(*) AS num_ratings,
    ROUND(AVG(rating), 2) AS avg_rating
FROM ratings
GROUP BY DATE_FORMAT(rating_timestamp, '%Y-%m')
ORDER BY month DESC
LIMIT 12;

-- ============================================================================
-- 8. CONSULTAS DE QUALIDADE DOS DADOS
-- ============================================================================

-- Filmes sem avaliações de usuários
SELECT 
    m.title,
    m.release_date,
    m.vote_average AS tmdb_rating,
    m.popularity
FROM movies m
LEFT JOIN ratings r ON m.id = r.movie_id
WHERE r.movie_id IS NULL
ORDER BY m.popularity DESC
LIMIT 10;

-- Campos com valores nulos (movies)
SELECT 
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_title,
    SUM(CASE WHEN release_date IS NULL THEN 1 ELSE 0 END) AS null_release_date,
    SUM(CASE WHEN budget = 0 THEN 1 ELSE 0 END) AS zero_budget,
    SUM(CASE WHEN revenue = 0 THEN 1 ELSE 0 END) AS zero_revenue,
    SUM(CASE WHEN overview IS NULL OR overview = '' THEN 1 ELSE 0 END) AS null_overview,
    COUNT(*) AS total_movies
FROM movies;

-- Tamanho das tabelas em MB
SELECT 
    table_name,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS size_mb,
    table_rows
FROM information_schema.tables
WHERE table_schema = 'movies_db'
ORDER BY size_mb DESC;

-- ============================================================================
-- 9. QUERIES PARA IMPRESSIONAR 😎
-- ============================================================================

-- Matriz: Ano x Gênero (filmes de ação por década)
SELECT 
    CONCAT(FLOOR(YEAR(release_date) / 10) * 10, 's') AS decade,
    SUM(CASE WHEN genres LIKE '%Action%' THEN 1 ELSE 0 END) AS action,
    SUM(CASE WHEN genres LIKE '%Comedy%' THEN 1 ELSE 0 END) AS comedy,
    SUM(CASE WHEN genres LIKE '%Drama%' THEN 1 ELSE 0 END) AS drama,
    SUM(CASE WHEN genres LIKE '%Thriller%' THEN 1 ELSE 0 END) AS thriller,
    COUNT(*) AS total
FROM movies
WHERE release_date IS NOT NULL
GROUP BY FLOOR(YEAR(release_date) / 10)
ORDER BY decade DESC;

-- Análise de rentabilidade por faixa de orçamento
SELECT 
    CASE 
        WHEN budget < 10000000 THEN '< 10M'
        WHEN budget < 50000000 THEN '10M - 50M'
        WHEN budget < 100000000 THEN '50M - 100M'
        ELSE '> 100M'
    END AS budget_range,
    COUNT(*) AS movie_count,
    ROUND(AVG(revenue), 0) AS avg_revenue,
    ROUND(AVG((revenue - budget) / budget * 100), 2) AS avg_roi_percent
FROM movies
WHERE budget > 0 AND revenue > 0
GROUP BY 
    CASE 
        WHEN budget < 10000000 THEN '< 10M'
        WHEN budget < 50000000 THEN '10M - 50M'
        WHEN budget < 100000000 THEN '50M - 100M'
        ELSE '> 100M'
    END
ORDER BY avg_roi_percent DESC;

-- Filmes "underrated" (boa avaliação de usuários, mas baixa no TMDB)
SELECT 
    m.title,
    m.vote_average AS tmdb_rating,
    ROUND(AVG(r.rating), 2) AS user_rating,
    COUNT(r.rating) AS num_ratings,
    m.release_date
FROM movies m
INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.title, m.vote_average, m.release_date
HAVING COUNT(r.rating) > 30 
   AND AVG(r.rating) > m.vote_average + 1
ORDER BY (AVG(r.rating) - m.vote_average) DESC
LIMIT 10;

-- ============================================================================
-- 10. PERFORMANCE E EXPLICAÇÃO
-- ============================================================================

-- Ver uso dos índices
SHOW INDEX FROM movies;
SHOW INDEX FROM ratings;

-- Explicar query plan de uma consulta complexa
EXPLAIN SELECT 
    m.title,
    COUNT(r.rating) AS num_ratings,
    AVG(r.rating) AS avg_rating
FROM movies m
LEFT JOIN ratings r ON m.id = r.movie_id
WHERE m.release_date >= '2010-01-01'
GROUP BY m.id, m.title
HAVING num_ratings > 10
ORDER BY num_ratings DESC;

-- ============================================================================
-- FIM DAS QUERIES DE EXEMPLO
-- ============================================================================

-- Dica: Salve suas queries favoritas em um arquivo para reuso!
