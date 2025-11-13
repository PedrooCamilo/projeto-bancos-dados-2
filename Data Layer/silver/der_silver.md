# 🗺️ DER - Diagrama Entidade-Relacionamento (Camada Silver)

## Descrição
Este documento apresenta o Diagrama Entidade-Relacionamento (DER) da camada Silver, mostrando graficamente as entidades, seus atributos e os relacionamentos entre elas.

---

## 📊 Diagrama Principal

### Notação: Crow's Foot (Pé de Galinha)

```
┌─────────────────────────────────────────────────────────────┐
│                           MOVIES                            │
├─────────────────────────────────────────────────────────────┤
│ 🔑 id                          INT            NOT NULL      │
│    title                       VARCHAR(500)   NOT NULL      │
│    overview                    TEXT                         │
│    release_date                DATE                         │
│    budget                      BIGINT                       │
│    revenue                     BIGINT                       │
│    runtime                     FLOAT                        │
│    popularity                  FLOAT                        │
│    status                      VARCHAR(50)                  │
│    tagline                     TEXT                         │
│    vote_average                DECIMAL(4,2)                 │
│    vote_count                  INT                          │
│    imdb_id                     VARCHAR(20)                  │
│    original_language           VARCHAR(10)                  │
│    genres                      TEXT                         │
│    production_companies        TEXT                         │
│    production_countries        TEXT                         │
│    spoken_languages            TEXT                         │
│    belongs_to_collection       TEXT                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ 1
                              │
                              ├──────────────────────┐
                              │                      │
                              │                      │
                              ○<                     │
                              │                      │
                            N │                      │
                              │                      │
┌─────────────────────────────────────────────────────────────┐
│                          RATINGS                            │
├─────────────────────────────────────────────────────────────┤
│ 🔑 user_id                 INT            NOT NULL          │
│ 🔑🔗 movie_id              INT            NOT NULL          │
│    rating                  DECIMAL(3,1)   NOT NULL          │
│    rating_timestamp        DATETIME       NOT NULL          │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎨 Diagrama Detalhado com Cardinalidades

```
                    ┌─────────────────┐
                    │     MOVIES      │
                    ├─────────────────┤
                    │ PK: id          │
                    │                 │
                    │ title           │
                    │ overview        │
                    │ release_date    │
                    │ budget          │
                    │ revenue         │
                    │ ...             │
                    └────────┬────────┘
                             │
                             │ 1
                             │
                  ┌──────────┴──────────┐
                  │                     │
                  │    RECEBE           │
                  │    AVALIAÇÃO        │
                  │                     │
                  └──────────┬──────────┘
                             │
                             │ N (0..*)
                             │
                    ┌────────┴────────┐
                    │    RATINGS      │
                    ├─────────────────┤
                    │ PK: user_id     │
                    │ PK: movie_id    │
                    │ FK: movie_id ───┘
                    │                 │
                    │ rating          │
                    │ rating_timestamp│
                    └─────────────────┘
```

---

## 🔍 Cardinalidades Detalhadas

### Relacionamento: MOVIES ─< RATINGS

| Lado         | Entidade | Cardinalidade | Descrição                                    |
|--------------|----------|---------------|----------------------------------------------|
| **Um (1)**   | MOVIES   | 1             | Um filme...                                  |
| **Muitos (N)**| RATINGS  | 0..*          | ...pode ter zero ou muitas avaliações        |

**Interpretação:**
- Um filme pode existir sem nenhuma avaliação (mínimo 0)
- Um filme pode ter quantas avaliações forem necessárias (máximo *)
- Cada avaliação deve estar associada a exatamente um filme (obrigatório)

---

## 📐 Diagrama com Chaves e Constraints

```
╔═══════════════════════════════════════════════════════════╗
║                         MOVIES                            ║
╠═══════════════════════════════════════════════════════════╣
║ 🔑 id (PK)                    INT                         ║
║ ───────────────────────────────────────────────────────── ║
║    title                      VARCHAR(500)    NOT NULL    ║
║    overview                   TEXT                        ║
║    release_date               DATE                        ║
║    budget                     BIGINT         DEFAULT 0    ║
║    revenue                    BIGINT         DEFAULT 0    ║
║    runtime                    FLOAT                       ║
║    popularity                 FLOAT          DEFAULT 0    ║
║    status                     VARCHAR(50)                 ║
║    tagline                    TEXT                        ║
║    vote_average               DECIMAL(4,2)                ║
║    vote_count                 INT            DEFAULT 0    ║
║    imdb_id                    VARCHAR(20)                 ║
║    original_language          VARCHAR(10)                 ║
║    genres                     TEXT                        ║
║    production_companies       TEXT                        ║
║    production_countries       TEXT                        ║
║    spoken_languages           TEXT                        ║
║    belongs_to_collection      TEXT                        ║
╚═══════════════════════════════════════════════════════════╝
                          │
                          │
                          │ FK: movie_id
                          │ ON DELETE: NO ACTION
                          │ ON UPDATE: CASCADE
                          │
                          ↓
╔═══════════════════════════════════════════════════════════╗
║                        RATINGS                            ║
╠═══════════════════════════════════════════════════════════╣
║ 🔑 user_id (PK)               INT            NOT NULL     ║
║ 🔑 movie_id (PK, FK)          INT            NOT NULL     ║
║ ───────────────────────────────────────────────────────── ║
║    rating                     DECIMAL(3,1)   NOT NULL     ║
║    rating_timestamp           DATETIME       NOT NULL     ║
║                                                           ║
║ CONSTRAINT: PK_RATINGS (user_id, movie_id)                ║
║ CONSTRAINT: FK_RATINGS_MOVIES (movie_id → MOVIES.id)      ║
║ CONSTRAINT: CHK_RATING CHECK (rating >= 0.5 AND <= 5.0)   ║
╚═══════════════════════════════════════════════════════════╝
```

---

## 🎯 Índices Recomendados

```
📌 MOVIES
├── PRIMARY KEY INDEX: id
├── INDEX: release_date (para consultas por período)
├── INDEX: popularity (para ordenação de filmes populares)
└── INDEX: vote_average (para consultas de filmes bem avaliados)

📌 RATINGS
├── PRIMARY KEY INDEX: (user_id, movie_id)
├── FOREIGN KEY INDEX: movie_id (automático)
└── INDEX: rating_timestamp (para análises temporais)
```

---

## 🔗 Constraints e Regras

### 1. Chaves Primárias
- **MOVIES.id**: Identifica unicamente cada filme
- **RATINGS.(user_id, movie_id)**: Identifica unicamente cada avaliação (um usuário pode avaliar cada filme apenas uma vez)

### 2. Chaves Estrangeiras
- **RATINGS.movie_id → MOVIES.id**
  - ON DELETE: NO ACTION (previne exclusão de filmes com avaliações)
  - ON UPDATE: CASCADE (atualiza movie_id nas avaliações se o id do filme mudar)

### 3. Check Constraints
- **RATINGS.rating**: Deve estar entre 0.5 e 5.0
- **MOVIES.budget**: Deve ser >= 0
- **MOVIES.revenue**: Deve ser >= 0
- **MOVIES.runtime**: Deve ser > 0

### 4. Unique Constraints
- **MOVIES.id**: Único
- **RATINGS.(user_id, movie_id)**: Único (garantido pela PK composta)

---

## 📊 Legenda de Símbolos

| Símbolo | Significado                          |
|---------|--------------------------------------|
| 🔑      | Chave Primária (Primary Key)        |
| 🔗      | Chave Estrangeira (Foreign Key)     |
| ─       | Relacionamento                       |
| │       | Um (1)                               |
| ○<      | Muitos (N) - opcional                |
| ●<      | Muitos (N) - obrigatório             |
| ═       | Linha de separação principal         |
| ─       | Linha de separação secundária        |

---

## 📈 Exemplo de Instâncias

### Dados de Exemplo

**MOVIES**
```
┌────┬────────────────────┬──────────────┬──────────┬────────────┐
│ id │ title              │ release_date │ budget   │ genres     │
├────┼────────────────────┼──────────────┼──────────┼────────────┤
│ 1  │ Toy Story          │ 1995-11-22   │ 30000000 │ Animation, │
│    │                    │              │          │ Comedy     │
│ 2  │ Jumanji            │ 1995-12-15   │ 65000000 │ Adventure, │
│    │                    │              │          │ Fantasy    │
│ 3  │ Grumpier Old Men   │ 1995-12-22   │ 0        │ Romance,   │
│    │                    │              │          │ Comedy     │
└────┴────────────────────┴──────────────┴──────────┴────────────┘
```

**RATINGS**
```
┌─────────┬──────────┬────────┬─────────────────────┐
│ user_id │ movie_id │ rating │ rating_timestamp    │
├─────────┼──────────┼────────┼─────────────────────┤
│ 1       │ 1        │ 4.0    │ 2023-01-15 14:30:00 │
│ 1       │ 2        │ 3.5    │ 2023-01-16 10:20:00 │
│ 2       │ 1        │ 5.0    │ 2023-01-15 16:45:00 │
│ 3       │ 1        │ 4.5    │ 2023-01-17 20:10:00 │
│ 3       │ 3        │ 3.0    │ 2023-01-18 11:00:00 │
└─────────┴──────────┴────────┴─────────────────────┘
```

**Relacionamentos mostrados:**
- Filme "Toy Story" (id=1) possui 3 avaliações
- Usuário 1 avaliou 2 filmes diferentes
- Cada combinação (user_id, movie_id) é única

---

## 🔄 Evolução e Versionamento

**Versão Atual:** 1.0 - Silver Layer
**Data:** 2024
**Status:** Produção

**Histórico de Mudanças:**
- v1.0 (2024): Estrutura inicial com duas entidades principais (MOVIES e RATINGS)
