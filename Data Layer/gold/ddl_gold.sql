-- ============================================================================
-- DDL - CAMADA GOLD (Data Warehouse - Star Schema)
-- Banco de Dados: movies_dw
-- Schema: gold
-- Descrição: Modelo dimensional (Star Schema) para análises de filmes
-- ============================================================================

-- Criar schema gold (se não existir)
CREATE SCHEMA IF NOT EXISTS gold;

-- ============================================================================
-- DIMENSÕES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Dimensão: TEMPO
-- Descrição: Dimensão temporal completa com ano, mês, dia, trimestre, etc
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gold.dim_tempo (
    tmp_srk SERIAL PRIMARY KEY,
    dta_completa DATE NOT NULL UNIQUE,
    ano_lancamento INTEGER NOT NULL,
    mes_numero INTEGER NOT NULL,
    mes_nome VARCHAR(20) NOT NULL,
    mes_abrev VARCHAR(3) NOT NULL,
    dia_numero INTEGER NOT NULL,
    dia_semana INTEGER NOT NULL,
    nom_dia_semana VARCHAR(20) NOT NULL,
    tri_numero INTEGER NOT NULL,
    tri_nome VARCHAR(20) NOT NULL,
    sem_numero INTEGER NOT NULL,
    dec_inicio INTEGER NOT NULL,
    flg_feriado BOOLEAN DEFAULT FALSE,
    flg_fim_semana BOOLEAN DEFAULT FALSE
);

COMMENT ON TABLE gold.dim_tempo IS 'Dimensão temporal completa com hierarquias de data';
COMMENT ON COLUMN gold.dim_tempo.tmp_srk IS 'Chave substituta (surrogate key) da dimensão tempo';
COMMENT ON COLUMN gold.dim_tempo.dta_completa IS 'Data completa (YYYY-MM-DD)';
COMMENT ON COLUMN gold.dim_tempo.ano_lancamento IS 'Ano de lançamento';
COMMENT ON COLUMN gold.dim_tempo.mes_numero IS 'Número do mês (1-12)';
COMMENT ON COLUMN gold.dim_tempo.mes_nome IS 'Nome completo do mês';
COMMENT ON COLUMN gold.dim_tempo.mes_abrev IS 'Abreviação do mês (3 letras)';
COMMENT ON COLUMN gold.dim_tempo.dia_numero IS 'Dia do mês (1-31)';
COMMENT ON COLUMN gold.dim_tempo.dia_semana IS 'Dia da semana (0-6)';
COMMENT ON COLUMN gold.dim_tempo.nom_dia_semana IS 'Nome do dia da semana';
COMMENT ON COLUMN gold.dim_tempo.tri_numero IS 'Número do trimestre (1-4)';
COMMENT ON COLUMN gold.dim_tempo.tri_nome IS 'Nome do trimestre (Q1, Q2, Q3, Q4)';
COMMENT ON COLUMN gold.dim_tempo.sem_numero IS 'Número da semana no ano (1-53)';
COMMENT ON COLUMN gold.dim_tempo.dec_inicio IS 'Década de início (ex: 1990, 2000)';
COMMENT ON COLUMN gold.dim_tempo.flg_feriado IS 'Flag indicando se é feriado';
COMMENT ON COLUMN gold.dim_tempo.flg_fim_semana IS 'Flag indicando se é fim de semana';

-- ----------------------------------------------------------------------------
-- Dimensão: FILME
-- Descrição: Informações descritivas dos filmes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gold.dim_filme (
    mov_srk SERIAL PRIMARY KEY,
    mov_nky INTEGER NOT NULL UNIQUE,
    mov_titulo VARCHAR(500) NOT NULL,
    mov_titulo_original VARCHAR(500),
    cod_idioma VARCHAR(10),
    cod_imdb VARCHAR(20),
    txt_sinopse TEXT,
    txt_tagline TEXT,
    url_homepage VARCHAR(500),
    url_poster VARCHAR(500),
    cat_status VARCHAR(50),
    cat_orcamento VARCHAR(50),
    cat_receita VARCHAR(50),
    cat_duracao VARCHAR(50)
);

COMMENT ON TABLE gold.dim_filme IS 'Dimensão de filmes com atributos descritivos';
COMMENT ON COLUMN gold.dim_filme.mov_srk IS 'Chave substituta (surrogate key) da dimensão filme';
COMMENT ON COLUMN gold.dim_filme.mov_nky IS 'Chave natural - ID original do filme';
COMMENT ON COLUMN gold.dim_filme.mov_titulo IS 'Título do filme';
COMMENT ON COLUMN gold.dim_filme.mov_titulo_original IS 'Título original do filme';
COMMENT ON COLUMN gold.dim_filme.cod_idioma IS 'Código do idioma original (ISO 639-1)';
COMMENT ON COLUMN gold.dim_filme.cod_imdb IS 'Código IMDb do filme';
COMMENT ON COLUMN gold.dim_filme.txt_sinopse IS 'Sinopse/resumo do filme';
COMMENT ON COLUMN gold.dim_filme.txt_tagline IS 'Slogan/frase de marketing do filme';
COMMENT ON COLUMN gold.dim_filme.url_homepage IS 'URL da página oficial do filme';
COMMENT ON COLUMN gold.dim_filme.url_poster IS 'URL do pôster do filme';
COMMENT ON COLUMN gold.dim_filme.cat_status IS 'Status do filme (Released, Post Production, etc)';
COMMENT ON COLUMN gold.dim_filme.cat_orcamento IS 'Categoria de orçamento';
COMMENT ON COLUMN gold.dim_filme.cat_receita IS 'Categoria de receita';
COMMENT ON COLUMN gold.dim_filme.cat_duracao IS 'Categoria de duração';

-- ----------------------------------------------------------------------------
-- Dimensão: GÊNERO
-- Descrição: Gêneros dos filmes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gold.dim_genero (
    gnr_srk SERIAL PRIMARY KEY,
    gnr_nome VARCHAR(100) NOT NULL UNIQUE
);

COMMENT ON TABLE gold.dim_genero IS 'Dimensão de gêneros cinematográficos';
COMMENT ON COLUMN gold.dim_genero.gnr_srk IS 'Chave substituta (surrogate key) da dimensão gênero';
COMMENT ON COLUMN gold.dim_genero.gnr_nome IS 'Nome do gênero (Drama, Action, Comedy, etc)';

-- ----------------------------------------------------------------------------
-- Dimensão: COMPANHIA PRODUTORA
-- Descrição: Companhias de produção dos filmes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gold.dim_companhia (
    cmp_srk SERIAL PRIMARY KEY,
    cmp_nome VARCHAR(300) NOT NULL UNIQUE
);

COMMENT ON TABLE gold.dim_companhia IS 'Dimensão de companhias produtoras';
COMMENT ON COLUMN gold.dim_companhia.cmp_srk IS 'Chave substituta (surrogate key) da dimensão companhia';
COMMENT ON COLUMN gold.dim_companhia.cmp_nome IS 'Nome da companhia produtora';

-- ----------------------------------------------------------------------------
-- Dimensão: GEOGRAFIA
-- Descrição: Países de produção dos filmes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gold.dim_geografia (
    geo_srk SERIAL PRIMARY KEY,
    geo_pais VARCHAR(100) NOT NULL UNIQUE
);

COMMENT ON TABLE gold.dim_geografia IS 'Dimensão geográfica (países de produção)';
COMMENT ON COLUMN gold.dim_geografia.geo_srk IS 'Chave substituta (surrogate key) da dimensão geografia';
COMMENT ON COLUMN gold.dim_geografia.geo_pais IS 'Nome do país de produção';

-- ----------------------------------------------------------------------------
-- Dimensão: DIRETOR
-- Descrição: Diretores dos filmes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gold.dim_diretor (
    dir_srk SERIAL PRIMARY KEY,
    dir_nome VARCHAR(200) NOT NULL UNIQUE,
    dir_nome_completo VARCHAR(300)
);

COMMENT ON TABLE gold.dim_diretor IS 'Dimensão de diretores';
COMMENT ON COLUMN gold.dim_diretor.dir_srk IS 'Chave substituta (surrogate key) da dimensão diretor';
COMMENT ON COLUMN gold.dim_diretor.dir_nome IS 'Nome do diretor';
COMMENT ON COLUMN gold.dim_diretor.dir_nome_completo IS 'Nome completo do diretor';

-- ----------------------------------------------------------------------------
-- Dimensão: ATOR
-- Descrição: Atores principais dos filmes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gold.dim_ator (
    act_srk SERIAL PRIMARY KEY,
    act_nome VARCHAR(200) NOT NULL UNIQUE,
    act_nome_completo VARCHAR(300)
);

COMMENT ON TABLE gold.dim_ator IS 'Dimensão de atores principais';
COMMENT ON COLUMN gold.dim_ator.act_srk IS 'Chave substituta (surrogate key) da dimensão ator';
COMMENT ON COLUMN gold.dim_ator.act_nome IS 'Nome do ator principal';
COMMENT ON COLUMN gold.dim_ator.act_nome_completo IS 'Nome completo do ator';

-- ============================================================================
-- TABELA FATO
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Fato: FILME
-- Descrição: Fato central com métricas de filmes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gold.fto_filme (
    fto_srk SERIAL PRIMARY KEY,
    mov_fky INTEGER NOT NULL REFERENCES gold.dim_filme(mov_srk),
    tmp_fky INTEGER NOT NULL REFERENCES gold.dim_tempo(tmp_srk),
    gnr_fky INTEGER NOT NULL REFERENCES gold.dim_genero(gnr_srk),
    cmp_fky INTEGER NOT NULL REFERENCES gold.dim_companhia(cmp_srk),
    geo_fky INTEGER NOT NULL REFERENCES gold.dim_geografia(geo_srk),
    dir_fky INTEGER NOT NULL REFERENCES gold.dim_diretor(dir_srk),
    act_fky INTEGER NOT NULL REFERENCES gold.dim_ator(act_srk),
    
    -- Métricas financeiras
    vlr_orcamento BIGINT,
    vlr_receita BIGINT,
    vlr_lucro BIGINT,
    pct_roi NUMERIC(15,3),
    
    -- Métricas de avaliação
    med_avaliacao NUMERIC(4,2),
    qtd_votos INTEGER,
    med_popularidade NUMERIC(15,3),
    
    -- Métricas adicionais
    dur_minutos INTEGER,
    qtd_elenco INTEGER,
    qtd_equipe INTEGER,
    
    -- Flags
    flg_adulto BOOLEAN DEFAULT FALSE,
    flg_blockbuster BOOLEAN DEFAULT FALSE
);

COMMENT ON TABLE gold.fto_filme IS 'Tabela fato contendo métricas e medidas dos filmes';
COMMENT ON COLUMN gold.fto_filme.fto_srk IS 'Chave substituta (surrogate key) da tabela fato';
COMMENT ON COLUMN gold.fto_filme.mov_fky IS 'Chave estrangeira para dimensão filme';
COMMENT ON COLUMN gold.fto_filme.tmp_fky IS 'Chave estrangeira para dimensão tempo';
COMMENT ON COLUMN gold.fto_filme.gnr_fky IS 'Chave estrangeira para dimensão gênero';
COMMENT ON COLUMN gold.fto_filme.cmp_fky IS 'Chave estrangeira para dimensão companhia';
COMMENT ON COLUMN gold.fto_filme.geo_fky IS 'Chave estrangeira para dimensão geografia';
COMMENT ON COLUMN gold.fto_filme.dir_fky IS 'Chave estrangeira para dimensão diretor';
COMMENT ON COLUMN gold.fto_filme.act_fky IS 'Chave estrangeira para dimensão ator';
COMMENT ON COLUMN gold.fto_filme.vlr_orcamento IS 'Orçamento do filme (em USD)';
COMMENT ON COLUMN gold.fto_filme.vlr_receita IS 'Receita total do filme (em USD)';
COMMENT ON COLUMN gold.fto_filme.vlr_lucro IS 'Lucro do filme (receita - orçamento)';
COMMENT ON COLUMN gold.fto_filme.pct_roi IS 'Retorno sobre investimento (ROI) em percentual';
COMMENT ON COLUMN gold.fto_filme.med_avaliacao IS 'Média de avaliação (0-10)';
COMMENT ON COLUMN gold.fto_filme.qtd_votos IS 'Quantidade de votos recebidos';
COMMENT ON COLUMN gold.fto_filme.med_popularidade IS 'Média de popularidade do filme';
COMMENT ON COLUMN gold.fto_filme.dur_minutos IS 'Duração do filme em minutos';
COMMENT ON COLUMN gold.fto_filme.qtd_elenco IS 'Quantidade de membros do elenco';
COMMENT ON COLUMN gold.fto_filme.qtd_equipe IS 'Quantidade de membros da equipe';
COMMENT ON COLUMN gold.fto_filme.flg_adulto IS 'Flag indicando se é conteúdo adulto';
COMMENT ON COLUMN gold.fto_filme.flg_blockbuster IS 'Flag indicando se é blockbuster';

-- ============================================================================
-- ÍNDICES
-- ============================================================================

-- Índices nas dimensões
CREATE INDEX IF NOT EXISTS idx_dim_tempo_ano ON gold.dim_tempo(ano_lancamento);
CREATE INDEX IF NOT EXISTS idx_dim_tempo_decada ON gold.dim_tempo(dec_inicio);
CREATE INDEX IF NOT EXISTS idx_dim_tempo_mes ON gold.dim_tempo(mes_numero);
CREATE INDEX IF NOT EXISTS idx_dim_tempo_data ON gold.dim_tempo(dta_completa);
CREATE INDEX IF NOT EXISTS idx_dim_filme_nky ON gold.dim_filme(mov_nky);
CREATE INDEX IF NOT EXISTS idx_dim_filme_titulo ON gold.dim_filme(mov_titulo);
CREATE INDEX IF NOT EXISTS idx_dim_genero_nome ON gold.dim_genero(gnr_nome);
CREATE INDEX IF NOT EXISTS idx_dim_companhia_nome ON gold.dim_companhia(cmp_nome);
CREATE INDEX IF NOT EXISTS idx_dim_geografia_pais ON gold.dim_geografia(geo_pais);
CREATE INDEX IF NOT EXISTS idx_dim_diretor_nome ON gold.dim_diretor(dir_nome);
CREATE INDEX IF NOT EXISTS idx_dim_ator_nome ON gold.dim_ator(act_nome);

-- Índices na tabela fato (chaves estrangeiras)
CREATE INDEX IF NOT EXISTS idx_fto_filme_mov_fky ON gold.fto_filme(mov_fky);
CREATE INDEX IF NOT EXISTS idx_fto_filme_tmp_fky ON gold.fto_filme(tmp_fky);
CREATE INDEX IF NOT EXISTS idx_fto_filme_gnr_fky ON gold.fto_filme(gnr_fky);
CREATE INDEX IF NOT EXISTS idx_fto_filme_cmp_fky ON gold.fto_filme(cmp_fky);
CREATE INDEX IF NOT EXISTS idx_fto_filme_geo_fky ON gold.fto_filme(geo_fky);
CREATE INDEX IF NOT EXISTS idx_fto_filme_dir_fky ON gold.fto_filme(dir_fky);
CREATE INDEX IF NOT EXISTS idx_fto_filme_act_fky ON gold.fto_filme(act_fky);

-- Índices compostos para queries comuns
CREATE INDEX IF NOT EXISTS idx_fto_filme_tempo_genero ON gold.fto_filme(tmp_fky, gnr_fky);
CREATE INDEX IF NOT EXISTS idx_fto_filme_tempo_geografia ON gold.fto_filme(tmp_fky, geo_fky);
CREATE INDEX IF NOT EXISTS idx_fto_filme_genero_diretor ON gold.fto_filme(gnr_fky, dir_fky);

-- Índices em flags para filtros
CREATE INDEX IF NOT EXISTS idx_fto_filme_flg_adulto ON gold.fto_filme(flg_adulto);
CREATE INDEX IF NOT EXISTS idx_fto_filme_flg_blockbuster ON gold.fto_filme(flg_blockbuster);

-- ============================================================================
-- FIM DO SCRIPT DDL
-- ============================================================================
