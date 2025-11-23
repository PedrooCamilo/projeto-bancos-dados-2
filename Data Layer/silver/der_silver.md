# DER - CAMADA SILVER (Diagrama Entidade-Relacionamento)

**Projeto:** Bancos de Dados 2 - Arquitetura Medallion  
**Camada:** SILVER (Dados Limpos e Transformados)  
**Data:** 2025-11-23

---

## 📋 Visão Geral

A camada SILVER implementa uma estrutura **totalmente desnormalizada** com **UMA ÚNICA TABELA** contendo todas as informações de filmes consolidadas.

---

## 📊 Diagrama Conceitual Simplificado

```
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│                     SILVER.MOVIES_RAW                        │
│                  (Tabela Única Desnormalizada)               │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  🎬 INFORMAÇÕES BÁSICAS                                      │
│  • ID (PK)                                                   │
│  • Título                                                    │
│  • Título Original                                           │
│  • Idioma                                                    │
│                                                              │
│  📅 DATAS                                                    │
│  • Data de Lançamento                                        │
│  • Ano / Mês / Década                                        │
│                                                              │
│  💰 MÉTRICAS FINANCEIRAS                                     │
│  • Orçamento / Receita / Lucro / ROI                         │
│  • Categorias de Orçamento e Receita                         │
│                                                              │
│  ⏱️  DURAÇÃO                                                  │
│  • Runtime em minutos                                        │
│  • Categoria de Duração                                      │
│                                                              │
│  ⭐ AVALIAÇÕES                                               │
│  • Média de Votos                                            │
│  • Contagem de Votos                                         │
│  • Popularidade                                              │
│                                                              │
│  🎭 GÊNEROS E PRODUÇÃO                                       │
│  • Lista de Gêneros / Gênero Principal                       │
│  • Lista de Produtoras / Produtora Principal                 │
│  • Lista de Países / País Principal                          │
│                                                              │
│  👤 CRÉDITOS (Elenco e Equipe)                               │
│  • Diretor                                                   │
│  • Ator Principal                                            │
│  • Top Atores                                                │
│  • Tamanho Elenco / Equipe                                   │
│                                                              │
│  🏷️  KEYWORDS                                                │
│  • Lista de Palavras-chave                                   │
│  • Contagem de Keywords                                      │
│                                                              │
│  📊 ESTATÍSTICAS DE RATINGS                                  │
│  • Média / Mediana / Desvio Padrão                           │
│  • Total / Mín / Máx                                         │
│  • Usuários Únicos                                           │
│                                                              │
│  🔗 LINKS ENTRE PLATAFORMAS                                  │
│  • TMDB ID                                                   │
│  • IMDB ID / IMDB ID Formatado                               │
│                                                              │
│  📝 METADADOS                                                │
│  • Status / Adult / Overview                                 │
│  • Tagline / Homepage / Poster Path                          │
│                                                              │
└──────────────────────────────────────────────────────────────┘

        Total de Colunas: 48
        Total de Registros: 45.433 filmes
```

---

## 🎯 Características da Estrutura

### ✅ Modelo Totalmente Desnormalizado

**Decisão de Design:** Uma única tabela flat (plana) com TODAS as informações

**Justificativa:**
1. **Simplicidade:** Sem JOINs necessários para queries básicas
2. **Performance de Leitura:** Queries mais rápidas ao evitar JOINs
3. **Facilidade de ETL:** Processo de transformação simplificado
4. **Preparação para GOLD:** Fonte única para criar modelo dimensional

**Desvantagens Aceitáveis:**
- ❌ Redundância de dados (aceitável em camada SILVER)
- ❌ Maior espaço de armazenamento (~68 MB total)
- ❌ Atualizações mais complexas (camada é append-only)

---

## 📦 Estrutura da Entidade Única

### **SILVER.MOVIES_RAW**

| Grupo | Quantidade de Colunas | Descrição |
|-------|----------------------|-----------|
| Identificadores | 1 | ID único |
| Informações Básicas | 3 | Títulos e idioma |
| Datas | 4 | Data completa + derivadas |
| Métricas Financeiras | 6 | Budget, revenue, profit, ROI + categorias |
| Duração | 2 | Runtime + categoria |
| Avaliações | 3 | Vote average/count, popularity |
| Gêneros | 2 | Lista completa + principal |
| Produção | 4 | Companies e countries (lista + principal) |
| Status e Metadados | 7 | Status, adult, textos, URLs |
| Créditos | 5 | Diretor, atores, tamanhos |
| Keywords | 2 | Lista + contagem |
| Estatísticas de Ratings | 7 | Agregações de usuários |
| Links | 2 | IDs de plataformas |
| **TOTAL** | **48 colunas** | - |

---

## 🔑 Chave Primária

- **PK:** `id` (INTEGER)
- **Tipo:** Natural key vinda dos dados originais
- **Unicidade:** Garantida por constraint PRIMARY KEY
- **Índice:** Criado automaticamente pelo PostgreSQL

---

## 📊 Índices Adicionais

```sql
-- Índice por ano (queries temporais frequentes)
CREATE INDEX idx_movies_raw_year ON silver.movies_raw(release_year);

-- Índice por gênero (análises por categoria)
CREATE INDEX idx_movies_raw_genre ON silver.movies_raw(primary_genre);

-- Índice por diretor (buscas por talentos)
CREATE INDEX idx_movies_raw_director ON silver.movies_raw(director);
```

**Justificativa:**
- Campos frequentemente usados em `WHERE` e `GROUP BY`
- Melhora performance de queries analíticas
- Overhead aceitável dado o volume (~45K registros)

---

## 🔄 Transformações Aplicadas (RAW → SILVER)

### 1️⃣ **Extração de Atributos Derivados**

```
release_date → release_year, release_month, release_decade
revenue - budget → profit
(profit / budget) * 100 → roi
```

### 2️⃣ **Categorização de Valores Numéricos**

```
budget → budget_category (Low, Medium, High, Ultra High)
revenue → revenue_category (Low, Medium, High, Blockbuster)
runtime → runtime_category (Short, Medium, Long, Very Long)
```

### 3️⃣ **Extração de Valores Primários**

```
genres_list (JSON) → primary_genre (primeiro elemento)
production_companies_list → primary_company
production_countries_list → primary_country
```

### 4️⃣ **Consolidação de Créditos**

```
credits.csv → director, lead_actor, top_actors, cast_size, crew_size
```

### 5️⃣ **Agregação de Ratings**

```
ratings.csv → avg_rating, median_rating, std_rating, total_ratings, etc.
```

### 6️⃣ **Formatação de Links**

```
links.csv → tmdb_id, imdb_id_formatted (tt + padding)
```

---

## 📐 Regras de Negócio

### RN01: Cálculo de Lucro
```
profit = revenue - budget
```

### RN02: Cálculo de ROI
```
roi = (profit / budget) × 100
Se budget = 0, então roi = NULL
```

### RN03: Categorização de Orçamento
- **Low:** budget < 1M
- **Medium:** 1M ≤ budget < 10M
- **High:** 10M ≤ budget < 100M
- **Ultra High:** budget ≥ 100M

### RN04: Categorização de Receita
- **Low:** revenue < 10M
- **Medium:** 10M ≤ revenue < 100M
- **High:** 100M ≤ revenue < 1B
- **Blockbuster:** revenue ≥ 1B

### RN05: Extração de Valores Primários
```
primary_* = primeiro elemento da lista JSON
Se lista vazia ou NULL, então primary_* = NULL
```

---

## 💾 Volumetria

| Métrica | Valor |
|---------|-------|
| **Total de Registros** | 45.433 |
| **Total de Colunas** | 48 |
| **Tamanho Estimado** | ~68 MB |
| **Índices** | 4 (1 PK + 3 secundários) |
| **Tamanho Total** | ~75 MB (tabela + índices) |

---

## 🚀 Próximos Passos (SILVER → GOLD)

A tabela `movies_raw` será a **fonte única** para criar o modelo dimensional GOLD:

```
silver.movies_raw (1 tabela flat)
         ↓
    ETL Transform
         ↓
gold.* (Star Schema: 7 dimensões + 1 fato)
```

**Transformações Planejadas:**
1. Quebrar em dimensões (tempo, gênero, companhia, geografia, diretor, ator, filme)
2. Criar tabela fato com métricas
3. Estabelecer relacionamentos via surrogate keys
4. Otimizar para queries OLAP

---

## 📌 Observações Importantes

1. **Sem Foreign Keys:** Tabela única, sem relacionamentos
2. **Sem Constraints de Domínio:** Validações feitas no ETL
3. **Campos JSON:** Preservados para informação completa
4. **NULLs Permitidos:** Exceto na PK
5. **Append-Only:** Não há UPDATEs, apenas INSERTs
6. **ETL Idempotente:** Pode ser reexecutado (TRUNCATE + INSERT)

---

**Conclusão:** A camada SILVER implementa uma estrutura desnormalizada propositalmente para facilitar transformações futuras e otimizar leitura de dados.
