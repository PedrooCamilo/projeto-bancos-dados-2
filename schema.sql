-- =================================================================
-- Tabela `movies`: Versão para MySQL
-- =================================================================
CREATE TABLE movies (
    id INT PRIMARY KEY,
    title VARCHAR(500),
    overview TEXT,
    release_date DATE,
    budget BIGINT,
    revenue BIGINT,
    runtime FLOAT,
    popularity FLOAT,
    status VARCHAR(50),
    tagline TEXT,
    vote_average DECIMAL(4, 2),
    vote_count INT,
    imdb_id VARCHAR(20),
    original_language VARCHAR(10),

    -- Campos JSON armazenados como texto.
    genres TEXT,
    production_companies TEXT,
    production_countries TEXT,
    spoken_languages TEXT,
    belongs_to_collection TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =================================================================
-- Tabela `ratings`: Versão para MySQL
-- =================================================================
CREATE TABLE ratings (
    user_id INT,
    movie_id INT,
    rating DECIMAL(3, 1),
    rating_timestamp DATETIME, -- Trocado de TIMESTAMP para DATETIME

    -- Chave primária composta
    PRIMARY KEY (user_id, movie_id),

    -- Relação com a tabela de filmes
    FOREIGN KEY (movie_id) REFERENCES movies(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;