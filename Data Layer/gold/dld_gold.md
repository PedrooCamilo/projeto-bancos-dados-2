# DLD - Diagrama Lógico de Dados (GOLD Layer)

## Modelo Dimensional - Especificação Técnica Completa

---

## DIMENSÕES

### 1. dim_tempo

**Descrição**: Dimensão temporal completa com hierarquia de data

| **Coluna**           | **Tipo**     | **Null** | **PK** | **Descrição**                          |
|----------------------|--------------|----------|--------|----------------------------------------|
| tmp_srk              | SERIAL       | NOT NULL | ✓      | Chave substituta da dimensão tempo     |
| dta_completa         | DATE         | NOT NULL |        | Data completa                          |
| ano_lancamento       | INTEGER      | NOT NULL |        | Ano de lançamento                      |
| mes_numero           | INTEGER      | NOT NULL |        | Número do mês (1-12)                   |
| mes_nome             | VARCHAR(20)  | NOT NULL |        | Nome do mês                            |
| mes_abrev            | VARCHAR(3)   | NOT NULL |        | Abreviação do mês                      |
| dia_numero           | INTEGER      | NOT NULL |        | Dia do mês (1-31)                      |
| dia_semana           | INTEGER      | NOT NULL |        | Dia da semana (1-7)                    |
| nom_dia_semana       | VARCHAR(20)  | NOT NULL |        | Nome do dia da semana                  |
| tri_numero           | INTEGER      | NOT NULL |        | Número do trimestre (1-4)              |
| tri_nome             | VARCHAR(10)  | NOT NULL |        | Nome do trimestre (Q1, Q2, Q3, Q4)     |
| sem_numero           | INTEGER      | NOT NULL |        | Número da semana no ano                |
| dec_inicio           | INTEGER      | NOT NULL |        | Década inicial (ex: 1990, 2000)        |
| flg_feriado          | BOOLEAN      | NOT NULL |        | Flag indicando feriado                 |
| flg_fim_semana       | BOOLEAN      | NOT NULL |        | Flag indicando fim de semana           |

**Constraints**: PRIMARY KEY (tmp_srk), UNIQUE (dta_completa)
**Índices**: idx_dim_tempo_ano, idx_dim_tempo_decada, idx_dim_tempo_mes, idx_dim_tempo_trimestre
**Volume Estimado**: ~17.000 registros

---

### 2. dim_filme

**Descrição**: Dimensão de filmes com atributos descritivos completos

| **Coluna**           | **Tipo**       | **Null** | **PK** | **Descrição**                          |
|----------------------|----------------|----------|--------|----------------------------------------|
| mov_srk              | SERIAL         | NOT NULL | ✓      | Chave substituta da dimensão filme     |
| mov_nky              | INTEGER        | NOT NULL |        | Chave natural (ID original do filme)   |
| mov_titulo           | VARCHAR(500)   | NOT NULL |        | Título do filme                        |
| mov_titulo_original  | VARCHAR(500)   | NULL     |        | Título original do filme               |
| cod_idioma           | VARCHAR(10)    | NULL     |        | Código do idioma original              |
| cod_imdb             | VARCHAR(20)    | NULL     |        | Código IMDb                            |
| txt_sinopse          | TEXT           | NULL     |        | Sinopse do filme                       |
| txt_tagline          | TEXT           | NULL     |        | Slogan do filme                        |
| url_homepage         | TEXT           | NULL     |        | URL da homepage do filme               |
| url_poster           | TEXT           | NULL     |        | URL do poster do filme                 |
| cat_status           | VARCHAR(50)    | NULL     |        | Status do filme                        |
| cat_orcamento        | VARCHAR(50)    | NULL     |        | Categoria de orçamento                 |
| cat_receita          | VARCHAR(50)    | NULL     |        | Categoria de receita                   |
| cat_duracao          | VARCHAR(50)    | NULL     |        | Categoria de duração                   |

**Constraints**: PRIMARY KEY (mov_srk), UNIQUE (mov_nky)
**Índices**: idx_dim_filme_nky, idx_dim_filme_titulo, idx_dim_filme_imdb
**Volume Estimado**: ~45.000 registros

---

### 3. dim_genero

**Descrição**: Dimensão de gêneros cinematográficos com categorias

| **Coluna**       | **Tipo**       | **Null** | **PK** | **Descrição**                          |
|------------------|----------------|----------|--------|----------------------------------------|
| gnr_srk          | SERIAL         | NOT NULL | ✓      | Chave substituta da dimensão gênero    |
| gnr_nome         | VARCHAR(100)   | NOT NULL |        | Nome do gênero                         |
| gnr_descricao    | TEXT           | NULL     |        | Descrição detalhada do gênero          |
| gnr_categoria    | VARCHAR(50)    | NULL     |        | Categoria de agrupamento               |

**Constraints**: PRIMARY KEY (gnr_srk), UNIQUE (gnr_nome)
**Índices**: idx_dim_genero_nome, idx_dim_genero_categoria
**Volume Estimado**: ~20 registros

---

### 4. dim_companhia

**Descrição**: Dimensão de companhias produtoras com tipo

| **Coluna**    | **Tipo**       | **Null** | **PK** | **Descrição**                          |
|---------------|----------------|----------|--------|----------------------------------------|
| cmp_srk       | SERIAL         | NOT NULL | ✓      | Chave substituta da dimensão companhia |
| cmp_nome      | VARCHAR(200)   | NOT NULL |        | Nome da companhia                      |
| cmp_tipo      | VARCHAR(50)    | NULL     |        | Tipo (Production, Distribution, etc)   |

**Constraints**: PRIMARY KEY (cmp_srk), UNIQUE (cmp_nome)
**Índices**: idx_dim_companhia_nome, idx_dim_companhia_tipo
**Volume Estimado**: ~1.500 registros

---

### 5. dim_geografia

**Descrição**: Dimensão geográfica com país, continente e região

| **Coluna**       | **Tipo**       | **Null** | **PK** | **Descrição**                          |
|------------------|----------------|----------|--------|----------------------------------------|
| geo_srk          | SERIAL         | NOT NULL | ✓      | Chave substituta da dimensão geografia |
| geo_pais         | VARCHAR(100)   | NOT NULL |        | Nome do país                           |
| geo_codigo_iso   | VARCHAR(3)     | NULL     |        | Código ISO do país                     |
| geo_continente   | VARCHAR(50)    | NULL     |        | Continente                             |
| geo_regiao       | VARCHAR(100)   | NULL     |        | Região geográfica                      |

**Constraints**: PRIMARY KEY (geo_srk), UNIQUE (geo_pais)
**Índices**: idx_dim_geografia_pais, idx_dim_geografia_continente, idx_dim_geografia_iso
**Volume Estimado**: ~100 registros

---

### 6. dim_diretor

**Descrição**: Dimensão de diretores

| **Coluna**         | **Tipo**       | **Null** | **PK** | **Descrição**                          |
|--------------------|----------------|----------|--------|----------------------------------------|
| dir_srk            | SERIAL         | NOT NULL | ✓      | Chave substituta da dimensão diretor   |
| dir_nome           | VARCHAR(200)   | NOT NULL |        | Nome do diretor                        |
| dir_nome_completo  | VARCHAR(300)   | NULL     |        | Nome completo do diretor               |

**Constraints**: PRIMARY KEY (dir_srk), UNIQUE (dir_nome)
**Índices**: idx_dim_diretor_nome
**Volume Estimado**: ~3.000 registros

---

### 7. dim_ator

**Descrição**: Dimensão de atores

| **Coluna**         | **Tipo**       | **Null** | **PK** | **Descrição**                          |
|--------------------|----------------|----------|--------|----------------------------------------|
| act_srk            | SERIAL         | NOT NULL | ✓      | Chave substituta da dimensão ator      |
| act_nome           | VARCHAR(200)   | NOT NULL |        | Nome do ator                           |
| act_nome_completo  | VARCHAR(300)   | NULL     |        | Nome completo do ator                  |

**Constraints**: PRIMARY KEY (act_srk), UNIQUE (act_nome)
**Índices**: idx_dim_ator_nome
**Volume Estimado**: ~5.000 registros

---

## TABELA FATO

### fto_filme

**Descrição**: Tabela fato central com métricas de filmes

| **Coluna**         | **Tipo**       | **Null** | **PK** | **FK** | **Descrição**                          |
|--------------------|----------------|----------|--------|--------|----------------------------------------|
| fto_srk            | SERIAL         | NOT NULL | ✓      |        | Chave substituta da fato               |
| mov_fky            | INTEGER        | NOT NULL |        | ✓      | FK para dim_filme                      |
| tmp_fky            | INTEGER        | NOT NULL |        | ✓      | FK para dim_tempo                      |
| gnr_fky            | INTEGER        | NOT NULL |        | ✓      | FK para dim_genero                     |
| cmp_fky            | INTEGER        | NOT NULL |        | ✓      | FK para dim_companhia                  |
| geo_fky            | INTEGER        | NOT NULL |        | ✓      | FK para dim_geografia                  |
| dir_fky            | INTEGER        | NOT NULL |        | ✓      | FK para dim_diretor                    |
| act_fky            | INTEGER        | NOT NULL |        | ✓      | FK para dim_ator                       |
| vlr_orcamento      | BIGINT         | NULL     |        |        | Orçamento do filme                     |
| vlr_receita        | BIGINT         | NULL     |        |        | Receita total                          |
| vlr_lucro          | BIGINT         | NULL     |        |        | Lucro (receita - orçamento)            |
| pct_roi            | NUMERIC(15,3)  | NULL     |        |        | ROI (%)                                |
| med_avaliacao      | NUMERIC(4,2)   | NULL     |        |        | Média de avaliação (0-10)              |
| qtd_votos          | INTEGER        | NULL     |        |        | Quantidade de votos                    |
| med_popularidade   | NUMERIC(15,3)  | NULL     |        |        | Média de popularidade                  |
| dur_minutos        | INTEGER        | NULL     |        |        | Duração em minutos                     |
| qtd_elenco         | INTEGER        | NULL     |        |        | Quantidade de membros do elenco        |
| qtd_equipe         | INTEGER        | NULL     |        |        | Quantidade de membros da equipe        |
| flg_adulto         | BOOLEAN        | NULL     |        |        | Flag de conteúdo adulto                |
| flg_blockbuster    | BOOLEAN        | NULL     |        |        | Flag de blockbuster                    |

**Constraints**:
- PRIMARY KEY (fto_srk)
- FOREIGN KEY (mov_fky) REFERENCES dim_filme(mov_srk)
- FOREIGN KEY (tmp_fky) REFERENCES dim_tempo(tmp_srk)
- FOREIGN KEY (gnr_fky) REFERENCES dim_genero(gnr_srk)
- FOREIGN KEY (cmp_fky) REFERENCES dim_companhia(cmp_srk)
- FOREIGN KEY (geo_fky) REFERENCES dim_geografia(geo_srk)
- FOREIGN KEY (dir_fky) REFERENCES dim_diretor(dir_srk)
- FOREIGN KEY (act_fky) REFERENCES dim_ator(act_srk)

**Índices**:
- idx_fto_filme_mov_fky
- idx_fto_filme_tmp_fky
- idx_fto_filme_gnr_fky
- idx_fto_filme_cmp_fky
- idx_fto_filme_geo_fky
- idx_fto_filme_dir_fky
- idx_fto_filme_act_fky
- idx_fto_filme_blockbuster
- idx_fto_filme_adulto

**Volume Estimado**: ~100.000 registros
**Tamanho Estimado**: ~30 MB

---

## RESUMO DO MODELO

### Estatísticas Gerais

| **Métrica**              | **Valor**          |
|--------------------------|--------------------|
| Total de Tabelas         | 8                  |
| Total de Dimensões       | 7                  |
| Total de Fatos           | 1                  |
| Total de Colunas         | 70                 |
| Total de FKs             | 7                  |
| Total de Índices         | ~25                |
| Tamanho Total Estimado   | ~60 MB             |
| Registros Totais (aprox) | ~170.000           |

### Nomenclatura de Chaves

- **Surrogate Keys (PK)**: `*_srk` (tmp_srk, mov_srk, gnr_srk, etc)
- **Foreign Keys**: `*_fky` (mov_fky, tmp_fky, gnr_fky, etc)
- **Natural Keys**: `*_nky` (mov_nky)

### Prefixos de Colunas

- `tmp_` - Tempo/Data
- `mov_` - Movie/Filme
- `gnr_` - Gênero
- `cmp_` - Companhia
- `geo_` - Geografia
- `dir_` - Diretor
- `act_` - Ator
- `vlr_` - Valor (numérico financeiro)
- `pct_` - Percentual
- `med_` - Média
- `qtd_` - Quantidade
- `dur_` - Duração
- `flg_` - Flag (booleano)
- `cod_` - Código
- `txt_` - Texto
- `url_` - URL
- `cat_` - Categoria
- `nom_` - Nome
- `dta_` - Data

---

**Última Atualização**: 2025-11-23
