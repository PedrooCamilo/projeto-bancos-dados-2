# DER - CAMADA SILVER (Diagrama Entidade-Relacionamento)

**Projeto:** Bancos de Dados 2 - Arquitetura Medallion  
**Camada:** SILVER (Dados Limpos e Transformados)  
**Data:** 2025-11-23

---

## 📋 Visão Geral

A camada SILVER contém dados limpos, transformados e normalizados vindos da camada RAW. O modelo é composto por 5 tabelas relacionais otimizadas para análise.

---

## 🎯 Diagrama Entidade-Relacionamento

```
┌─────────────────────────────────────────────────────────────────┐
│                        SILVER.MOVIES                            │
│─────────────────────────────────────────────────────────────────│
│ PK  id                    BIGINT                                │
│     title                 VARCHAR(500)                          │
│     original_title        VARCHAR(500)                          │
│     original_language     VARCHAR(10)                           │
│     release_date          DATE                                  │
│     release_year          NUMERIC                               │
│     release_month         NUMERIC                               │
│     release_decade        NUMERIC                               │
│     budget                NUMERIC(15,2)                         │
│     revenue               NUMERIC(15,2)                         │
│     profit                NUMERIC(15,2)                         │
│     roi                   NUMERIC(15,2)                         │
│     budget_category       VARCHAR(50)                           │
│     revenue_category      VARCHAR(50)                           │
│     runtime               NUMERIC(8,2)                          │
│     runtime_category      VARCHAR(50)                           │
│     vote_average          NUMERIC(4,2)                          │
│     vote_count            NUMERIC                               │
│     popularity            NUMERIC(10,3)                         │
│     genres_list           TEXT                                  │
│     primary_genre         VARCHAR(100)                          │
│     production_companies  TEXT                                  │
│     primary_company       VARCHAR(255)                          │
│     production_countries  TEXT                                  │
│     primary_country       VARCHAR(255)                          │
│     status                VARCHAR(50)                           │
│     adult                 TEXT                                  │
│     overview              TEXT                                  │
│     tagline               TEXT                                  │
│     homepage              VARCHAR(500)                          │
│     imdb_id               VARCHAR(20)                           │
│     poster_path           VARCHAR(255)                          │
└─────────────────────────────────────────────────────────────────┘
                          │
                          │ 1
                          │
        ┌─────────────────┼─────────────────────────┐
        │                 │                         │
        │ 1               │ 1                       │ 0..1
        ▼                 ▼                         ▼
┌──────────────────┐ ┌──────────────────┐ ┌───────────────────────┐
│ SILVER.CREDITS   │ │ SILVER.KEYWORDS  │ │ SILVER.RATINGS_       │
│                  │ │                  │ │ AGGREGATED            │
├──────────────────┤ ├──────────────────┤ ├───────────────────────┤
│ PK,FK  id        │ │ PK,FK  id        │ │ PK  movie_id          │
│     director     │ │     keywords_list│ │     avg_rating        │
│     lead_actor   │ │     keywords_cnt │ │     median_rating     │
│     top_actors   │ └──────────────────┘ │     std_rating        │
│     cast_size    │                      │     total_ratings     │
│     crew_size    │                      │     min_rating        │
└──────────────────┘                      │     max_rating        │
                                          │     unique_users      │
                                          └───────────────────────┘

                          ┌─────────────────────────┐
                          │ SILVER.LINKS            │
                          │ (Tabela Independente)   │
                          ├─────────────────────────┤
                          │ PK  movie_id            │
                          │     imdb_id             │
                          │     tmdb_id             │
                          │     imdb_id_formatted   │
                          └─────────────────────────┘
```

---

## 🔗 Relacionamentos

### 1. **MOVIES ↔ CREDITS** (1:1)
- **Tipo:** Identificação (Obrigatório)
- **Descrição:** Cada filme tem um registro de créditos (elenco e equipe)
- **Cardinalidade:** 1 filme → 1 registro de créditos
- **Chave Estrangeira:** `credits.id` → `movies.id`
- **Regra de Deleção:** `ON DELETE CASCADE`

### 2. **MOVIES ↔ KEYWORDS** (1:1)
- **Tipo:** Identificação (Obrigatório)
- **Descrição:** Cada filme tem um conjunto de palavras-chave
- **Cardinalidade:** 1 filme → 1 registro de keywords
- **Chave Estrangeira:** `keywords.id` → `movies.id`
- **Regra de Deleção:** `ON DELETE CASCADE`

### 3. **MOVIES ↔ RATINGS_AGGREGATED** (1:0..1)
- **Tipo:** Associação (Opcional)
- **Descrição:** Cada filme pode ter estatísticas de avaliação agregadas
- **Cardinalidade:** 1 filme → 0 ou 1 registro de ratings
- **Observação:** Nem todos os filmes possuem avaliações
- **Sem FK explícita** (relacionamento lógico via `movie_id`)

### 4. **LINKS** (Independente)
- **Tipo:** Tabela de referência cruzada
- **Descrição:** Mapeia IDs entre plataformas (MovieLens, IMDB, TMDB)
- **Observação:** Não possui FK para movies (dataset independente)

---

## 📊 Entidades Principais

### 🎬 **MOVIES** (Entidade Central)
- **Descrição:** Tabela principal com todas as informações de filmes
- **Registros:** 45.433 filmes
- **Atributos-chave:**
  - Identificação: `id`, `title`, `imdb_id`
  - Temporal: `release_date`, `release_year`, `release_decade`
  - Financeiro: `budget`, `revenue`, `profit`, `roi`
  - Avaliação: `vote_average`, `vote_count`, `popularity`
  - Categorização: `primary_genre`, `budget_category`, `revenue_category`

### 👥 **CREDITS** (Entidade Dependente)
- **Descrição:** Informações de elenco e equipe
- **Registros:** 45.432 registros
- **Atributos-chave:**
  - `director`: Nome do diretor principal
  - `lead_actor`: Ator/atriz principal
  - `cast_size`, `crew_size`: Tamanho do elenco e equipe

### 🏷️ **KEYWORDS** (Entidade Dependente)
- **Descrição:** Palavras-chave para classificação temática
- **Registros:** 45.432 registros
- **Atributos-chave:**
  - `keywords_list`: Lista em formato JSON
  - `keywords_count`: Quantidade de keywords

### ⭐ **RATINGS_AGGREGATED** (Entidade Associativa)
- **Descrição:** Estatísticas agregadas de avaliações
- **Registros:** 45.115 registros
- **Atributos-chave:**
  - `avg_rating`: Média das avaliações
  - `total_ratings`: Total de avaliações
  - `unique_users`: Usuários únicos que avaliaram

### 🔗 **LINKS** (Entidade de Referência)
- **Descrição:** Mapeamento entre plataformas
- **Registros:** 45.624 registros
- **Atributos-chave:**
  - `imdb_id`, `tmdb_id`: IDs em diferentes plataformas
  - `imdb_id_formatted`: ID formatado com prefixo 'tt'

---

## 🎯 Índices Criados

### MOVIES
- `idx_movies_release_year` (release_year)
- `idx_movies_primary_genre` (primary_genre)
- `idx_movies_budget_category` (budget_category)
- `idx_movies_revenue_category` (revenue_category)

### CREDITS
- `idx_credits_director` (director)

### LINKS
- `idx_links_tmdb_id` (tmdb_id)
- `idx_links_imdb_id` (imdb_id)

---

## 📌 Observações Importantes

1. **Normalização:** O modelo está na 3ª Forma Normal (3FN)
2. **Integridade Referencial:** FKs garantem consistência entre movies, credits e keywords
3. **Desnormalização Controlada:** Campos como `primary_genre`, `primary_company` são desnormalizados para facilitar queries
4. **Dados em JSON:** `genres_list`, `keywords_list`, `top_actors` armazenam arrays em formato texto
5. **Cardinalidade 1:1:** Credits e Keywords têm relacionamento identificador com Movies
6. **Ratings Opcional:** Nem todos os filmes possuem avaliações (45.115 de 45.433)

---

## 🚀 Próximos Passos

- ✅ Camada SILVER carregada com 226.936 registros
- 🔄 Criar modelo dimensional GOLD (Star Schema)
- 🔄 Implementar tabelas de dimensões e fatos
- 🔄 Conectar ao Power BI para dashboards
