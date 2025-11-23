# DLD - CAMADA SILVER (Diagrama Lógico de Dados)

**Projeto:** Bancos de Dados 2 - Arquitetura Medallion  
**Camada:** SILVER (Dados Limpos e Transformados)  
**Data:** 2025-11-23

---

## 📋 Visão Geral

O Diagrama Lógico de Dados (DLD) da camada SILVER especifica detalhadamente a implementação física da **tabela única desnormalizada** `silver.movies_raw` no PostgreSQL.

---

## 📊 Tabela Única: SILVER.MOVIES_RAW

### Estrutura Completa (48 Colunas)

| # | Coluna | Tipo de Dado | Constraint | Default | Índice | Descrição |
|---|--------|--------------|------------|---------|--------|-----------|
| 1 | **id** | `INTEGER` | `PRIMARY KEY` | - | PK | Identificador único |
| 2 | title | `VARCHAR(500)` | `NULL` | - | - | Título do filme |
| 3 | original_title | `VARCHAR(500)` | `NULL` | - | - | Título original |
| 4 | original_language | `VARCHAR(10)` | `NULL` | - | - | Código ISO idioma |
| 5 | release_date | `DATE` | `NULL` | - | - | Data de lançamento |
| 6 | release_year | `INTEGER` | `NULL` | - | IDX | Ano (extraído) |
| 7 | release_month | `INTEGER` | `NULL` | - | - | Mês 1-12 (extraído) |
| 8 | release_decade | `INTEGER` | `NULL` | - | - | Década (derivado) |
| 9 | budget | `BIGINT` | `NULL` | - | - | Orçamento em USD |
| 10 | revenue | `BIGINT` | `NULL` | - | - | Receita em USD |
| 11 | profit | `BIGINT` | `NULL` | - | - | Lucro (calculado) |
| 12 | roi | `NUMERIC(15,2)` | `NULL` | - | - | ROI % (calculado) |
| 13 | budget_category | `VARCHAR(50)` | `NULL` | - | - | Categoria orçamento |
| 14 | revenue_category | `VARCHAR(50)` | `NULL` | - | - | Categoria receita |
| 15 | runtime | `NUMERIC(10,2)` | `NULL` | - | - | Duração em minutos |
| 16 | runtime_category | `VARCHAR(50)` | `NULL` | - | - | Categoria duração |
| 17 | vote_average | `NUMERIC(3,1)` | `NULL` | - | - | Média votos (0-10) |
| 18 | vote_count | `INTEGER` | `NULL` | - | - | Quantidade de votos |
| 19 | popularity | `NUMERIC(10,3)` | `NULL` | - | - | Score popularidade |
| 20 | genres_list | `TEXT` | `NULL` | - | - | Lista gêneros (JSON) |
| 21 | primary_genre | `VARCHAR(100)` | `NULL` | - | IDX | Gênero principal |
| 22 | production_companies_list | `TEXT` | `NULL` | - | - | Lista produtoras (JSON) |
| 23 | primary_company | `VARCHAR(200)` | `NULL` | - | - | Produtora principal |
| 24 | production_countries_list | `TEXT` | `NULL` | - | - | Lista países (JSON) |
| 25 | primary_country | `VARCHAR(100)` | `NULL` | - | - | País principal |
| 26 | status | `VARCHAR(50)` | `NULL` | - | - | Status lançamento |
| 27 | adult | `BOOLEAN` | `NULL` | - | - | Conteúdo adulto |
| 28 | overview | `TEXT` | `NULL` | - | - | Sinopse |
| 29 | tagline | `TEXT` | `NULL` | - | - | Slogan |
| 30 | homepage | `TEXT` | `NULL` | - | - | URL site oficial |
| 31 | imdb_id | `VARCHAR(20)` | `NULL` | - | - | ID IMDB |
| 32 | poster_path | `VARCHAR(200)` | `NULL` | - | - | Caminho poster |
| 33 | director | `VARCHAR(200)` | `NULL` | - | IDX | Nome diretor |
| 34 | lead_actor | `VARCHAR(200)` | `NULL` | - | - | Ator principal |
| 35 | top_actors | `TEXT` | `NULL` | - | - | Top 5 atores (JSON) |
| 36 | cast_size | `INTEGER` | `NULL` | - | - | Tamanho elenco |
| 37 | crew_size | `INTEGER` | `NULL` | - | - | Tamanho equipe |
| 38 | keywords_list | `TEXT` | `NULL` | - | - | Keywords (JSON) |
| 39 | keywords_count | `INTEGER` | `NULL` | - | - | Qtd keywords |
| 40 | avg_rating | `NUMERIC(3,2)` | `NULL` | - | - | Média ratings (0-5) |
| 41 | median_rating | `NUMERIC(3,2)` | `NULL` | - | - | Mediana ratings |
| 42 | std_rating | `NUMERIC(3,2)` | `NULL` | - | - | Desvio padrão |
| 43 | total_ratings | `INTEGER` | `NULL` | - | - | Total avaliações |
| 44 | min_rating | `NUMERIC(3,2)` | `NULL` | - | - | Menor nota |
| 45 | max_rating | `NUMERIC(3,2)` | `NULL` | - | - | Maior nota |
| 46 | unique_users | `INTEGER` | `NULL` | - | - | Usuários únicos |
| 47 | tmdb_id | `INTEGER` | `NULL` | - | - | ID TMDB |
| 48 | imdb_id_formatted | `VARCHAR(20)` | `NULL` | - | - | IMDB formatado (tt) |

---

## 🔑 Constraints

### Primary Key
```sql
CONSTRAINT movies_raw_pkey PRIMARY KEY (id)
```

**Características:**
- Garante unicidade de cada filme
- Cria índice B-Tree automaticamente
- Não permite valores NULL

### Foreign Keys
**Não há foreign keys** (tabela única, sem relacionamentos)

### Check Constraints
**Não há check constraints** (validações feitas no ETL)

### Unique Constraints
**Não há unique constraints adicionais** além da PK

---

## 📊 Índices

### Índice Primário (Automático)
```sql
CREATE UNIQUE INDEX movies_raw_pkey ON silver.movies_raw USING btree (id)
```

### Índices Secundários
```sql
-- Índice por ano de lançamento
CREATE INDEX idx_movies_raw_year 
ON silver.movies_raw(release_year);

-- Índice por gênero principal
CREATE INDEX idx_movies_raw_genre 
ON silver.movies_raw(primary_genre);

-- Índice por diretor
CREATE INDEX idx_movies_raw_director 
ON silver.movies_raw(director);
```

**Justificativa:**
- `release_year`: Filtros temporais frequentes
- `primary_genre`: Análises por categoria
- `director`: Buscas por talentos

---

## 📏 Tipos de Dados - Justificativa

### Identificadores
| Tipo | Uso | Motivo |
|------|-----|--------|
| `INTEGER` | id | Valores até ~2 bilhões, suficiente |

### Textos
| Tipo | Uso | Motivo |
|------|-----|--------|
| `VARCHAR(500)` | Títulos | Tamanho máximo observado ~400 chars |
| `VARCHAR(200)` | Nomes, companhias | Tamanho típico ~150 chars |
| `VARCHAR(100)` | Gêneros, países | Raramente > 50 chars |
| `VARCHAR(50)` | Categorias, status | Valores controlados |
| `VARCHAR(20)` | IDs IMDB | Formato fixo tt + 7 dígitos |
| `VARCHAR(10)` | Códigos idioma | ISO 639-1 (2 chars) |
| `TEXT` | Overview, listas JSON | Tamanho variável |

### Numéricos
| Tipo | Uso | Range | Motivo |
|------|-----|-------|--------|
| `BIGINT` | Budget, revenue | ±9 quintilhões | Valores > 2 bilhões existem |
| `INTEGER` | Contadores | ±2 bilhões | Suficiente para counts |
| `NUMERIC(15,2)` | ROI | Até 999 trilhões | Valores extremos de ROI |
| `NUMERIC(10,3)` | Popularity | 3 decimais | Precisão necessária |
| `NUMERIC(10,2)` | Runtime | Minutos com decimais | Duração precisa |
| `NUMERIC(3,2)` | Ratings | 0.00-5.00 | Escala 0-5 |
| `NUMERIC(3,1)` | Vote average | 0.0-10.0 | Escala 0-10 |

### Temporais
| Tipo | Uso | Motivo |
|------|-----|--------|
| `DATE` | release_date | Apenas data, sem hora |

### Booleanos
| Tipo | Uso | Motivo |
|------|-----|--------|
| `BOOLEAN` | adult | Valores TRUE/FALSE |

---

## 💾 Estimativa de Armazenamento

### Por Coluna (Tamanho Médio)

| Grupo de Colunas | Qtd | Bytes/Coluna | Total |
|------------------|-----|--------------|-------|
| INTEGER/BIGINT | 10 | 4-8 | ~60 bytes |
| NUMERIC | 11 | 8-16 | ~120 bytes |
| VARCHAR curtos | 15 | 20-50 | ~400 bytes |
| TEXT (listas JSON) | 6 | 100-500 | ~1.800 bytes |
| DATE | 1 | 4 | 4 bytes |
| BOOLEAN | 1 | 1 | 1 byte |
| **TOTAL por linha** | **48** | - | **~2.385 bytes** |

### Total da Tabela

| Componente | Cálculo | Tamanho |
|------------|---------|---------|
| Dados (45.433 linhas × 2.385 bytes) | - | ~108 MB |
| Índices (4 índices) | - | ~15 MB |
| Overhead PostgreSQL (TOAST, headers) | ~15% | ~18 MB |
| **TOTAL ESTIMADO** | - | **~141 MB** |

**Nota:** Valores reais podem variar devido a compressão e TOAST (The Oversized-Attribute Storage Technique).

---

## 📐 Normalização

### Forma Normal: **0FN (Não Normalizada)**

**Características:**
- ❌ **1FN violada:** Campos JSON (genres_list, top_actors, etc.) são multivalorados
- ❌ **2FN não aplicável:** Não há chaves compostas
- ❌ **3FN não aplicável:** Dados intencionalmente desnormalizados

**Justificativa:**
- Camada intermediária de transformação
- Prioriza simplicidade e performance de leitura
- Será normalizada na camada GOLD (Star Schema)

---

## 🔄 Regras de Derivação

### Atributos Calculados no ETL

```python
# Extração de ano/mês/década
release_year = pd.to_datetime(release_date).year
release_month = pd.to_datetime(release_date).month
release_decade = (release_year // 10) * 10

# Cálculos financeiros
profit = revenue - budget
roi = (profit / budget) * 100 if budget > 0 else None

# Categorizações
budget_category = categorize_budget(budget)
revenue_category = categorize_revenue(revenue)
runtime_category = categorize_runtime(runtime)

# Extração de valores primários
primary_genre = json.loads(genres_list)[0] if genres_list else None
primary_company = json.loads(companies_list)[0] if companies_list else None

# Agregações de ratings
avg_rating = ratings_df.groupby('movie_id')['rating'].mean()
median_rating = ratings_df.groupby('movie_id')['rating'].median()
```

---

## 📊 Volumetria e Performance

### Estatísticas da Tabela

| Métrica | Valor |
|---------|-------|
| Total de Registros | 45.433 |
| Total de Colunas | 48 |
| Tamanho da Tabela | ~108 MB |
| Tamanho dos Índices | ~15 MB |
| Tamanho Total | ~123 MB |
| Registros por Página (8KB) | ~3-4 |
| Total de Páginas | ~15.000 |

### Performance de Queries

| Tipo de Query | Tempo Estimado | Otimização |
|---------------|----------------|------------|
| SELECT * WHERE id = ? | <1 ms | PK index |
| SELECT * WHERE release_year = ? | <10 ms | Índice secundário |
| SELECT * WHERE primary_genre = ? | <10 ms | Índice secundário |
| SELECT * WHERE director = ? | <10 ms | Índice secundário |
| SELECT * (full scan) | ~100 ms | - |
| Agregações (COUNT, AVG) | 50-200 ms | Depende da coluna |

---

## 🗂️ Particionamento

**Não implementado** na SILVER.

**Motivo:**
- Volume de dados ainda gerenciável (~45K registros)
- Performance aceitável sem particionamento
- Complexidade adicional desnecessária

**Consideração Futura:** Se volume ultrapassar 1M registros, particionar por `release_decade`.

---

## 🔐 Permissões e Segurança

```sql
-- Grants para usuário postgres
GRANT ALL PRIVILEGES ON SCHEMA silver TO postgres;
GRANT ALL PRIVILEGES ON TABLE silver.movies_raw TO postgres;

-- Para outros usuários (exemplo)
-- GRANT SELECT ON silver.movies_raw TO analytics_user;
-- GRANT INSERT ON silver.movies_raw TO etl_user;
```

---

## 📝 Comentários no Banco

Todos os comentários estão implementados via `COMMENT ON`:

```sql
COMMENT ON TABLE silver.movies_raw IS 'Tabela única desnormalizada...';
COMMENT ON COLUMN silver.movies_raw.id IS 'Identificador único...';
-- ... (48 comentários de colunas)
```

**Benefício:** Documentação integrada ao schema, visível em ferramentas de administração.

---

## 🚀 Próximos Passos (SILVER → GOLD)

### Transformações Planejadas

```
silver.movies_raw
         ↓
    ┌────┴────┐
    ↓         ↓
gold.dim_*  gold.fto_filme
```

1. **Quebrar em Dimensões:**
   - dim_tempo ← release_date
   - dim_genero ← primary_genre
   - dim_companhia ← primary_company
   - dim_geografia ← primary_country
   - dim_diretor ← director
   - dim_ator ← lead_actor
   - dim_filme ← atributos descritivos

2. **Criar Tabela Fato:**
   - fto_filme ← métricas + FKs

3. **Normalização:**
   - Modelo dimensional (Star Schema)
   - Surrogate keys
   - Relacionamentos FK

---

## 📌 Observações de Implementação

1. **Encoding:** UTF-8 em todo o schema
2. **Collation:** Padrão PostgreSQL (pt_BR ou C)
3. **NULLs:** Permitidos em todas as colunas exceto PK
4. **Defaults:** Nenhum default definido (valores vêm do ETL)
5. **Triggers:** Nenhum trigger implementado
6. **Views:** Nenhuma view na SILVER (apenas tabela base)
7. **Sequences:** Auto-incremento da PK (não usado, IDs vêm dos dados)

---

## ✅ Checklist de Validação

- [x] PK criada e funcional
- [x] Índices secundários criados
- [x] Tipos de dados adequados
- [x] Comentários documentados
- [x] Permissões configuradas
- [x] Dados carregados (45.433 registros)
- [x] Performance de queries aceitável
- [ ] Backup configurado (pendente)
- [ ] Monitoramento ativo (pendente)

---

**Status:** ✅ Implementado e operacional com 45.433 registros carregados.
