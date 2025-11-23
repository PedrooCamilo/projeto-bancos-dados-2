# MER - CAMADA SILVER (Modelo Entidade-Relacionamento)

**Projeto:** Bancos de Dados 2 - Arquitetura Medallion  
**Camada:** SILVER (Dados Limpos e Transformados)  
**Data:** 2025-11-23

---

## 📋 Introdução

O Modelo Entidade-Relacionamento (MER) da camada SILVER é extremamente simplificado, consistindo de **uma única entidade** sem relacionamentos.

---

## 🎯 Diagrama Conceitual

```
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║                   FILME (movies_raw)                  ║
║                                                       ║
║  Entidade Forte - Totalmente Desnormalizada          ║
║                                                       ║
╠═══════════════════════════════════════════════════════╣
║                                                       ║
║  • ID (PK) - Identificador Único                      ║
║                                                       ║
║  📌 INFORMAÇÕES DO FILME (48 atributos)               ║
║  ├─ Básicas: título, idioma                           ║
║  ├─ Temporais: datas, ano, mês, década                ║
║  ├─ Financeiras: orçamento, receita, lucro, ROI       ║
║  ├─ Avaliações: votos, popularidade                   ║
║  ├─ Classificações: gêneros, produtoras, países       ║
║  ├─ Créditos: diretor, atores                         ║
║  ├─ Keywords: palavras-chave                          ║
║  ├─ Ratings: estatísticas agregadas                   ║
║  ├─ Links: IDs em outras plataformas                  ║
║  └─ Metadados: overview, tagline, URLs                ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

                    Sem Relacionamentos
                   (Modelo Desnormalizado)
```

---

## 📦 Entidade Única

### **FILME** (Entidade Forte)

**Nome da Tabela:** `silver.movies_raw`

**Descrição:** Representa um filme com TODAS as suas informações consolidadas em uma única estrutura flat (plana).

**Tipo:** Entidade independente, sem dependências

---

## 🏷️ Atributos da Entidade FILME

### Classificação dos Atributos

| Categoria | Atributos | Tipo | Descrição |
|-----------|-----------|------|-----------|
| **Chave** | id | Numérico (PK) | Identificador único |
| **Simples** | title, original_title, original_language, status, overview, tagline, homepage, poster_path, imdb_id, director, lead_actor | Texto | Atributos de valor único |
| **Derivados** | release_year, release_month, release_decade, profit, roi, budget_category, revenue_category, runtime_category, primary_genre, primary_company, primary_country, cast_size, crew_size, keywords_count, avg_rating, median_rating, std_rating, total_ratings, min_rating, max_rating, unique_users, imdb_id_formatted | Diversos | Calculados a partir de outros atributos |
| **Compostos (JSON)** | genres_list, production_companies_list, production_countries_list, top_actors, keywords_list | TEXT | Arrays armazenados como JSON |
| **Numéricos** | budget, revenue, runtime, vote_average, vote_count, popularity, tmdb_id | Numérico | Valores mensuráveis |
| **Temporais** | release_date | DATE | Datas |
| **Booleanos** | adult | BOOLEAN | Flags verdadeiro/falso |

---

## 📊 Detalhamento dos Atributos

### 🔑 Chave Primária

| Atributo | Tipo | Descrição | Restrições |
|----------|------|-----------|------------|
| **id** | INTEGER | ID único do filme | NOT NULL, UNIQUE, PK |

### 📝 Atributos Básicos (Não Derivados)

| Atributo | Tipo | Descrição | Permite NULL |
|----------|------|-----------|--------------|
| title | VARCHAR(500) | Título do filme | Sim |
| original_title | VARCHAR(500) | Título original | Sim |
| original_language | VARCHAR(10) | Código ISO idioma | Sim |
| release_date | DATE | Data de lançamento | Sim |
| budget | BIGINT | Orçamento em USD | Sim |
| revenue | BIGINT | Receita em USD | Sim |
| runtime | NUMERIC(10,2) | Duração em minutos | Sim |
| vote_average | NUMERIC(3,1) | Média de votos (0-10) | Sim |
| vote_count | INTEGER | Quantidade de votos | Sim |
| popularity | NUMERIC(10,3) | Score de popularidade | Sim |
| status | VARCHAR(50) | Status de lançamento | Sim |
| adult | BOOLEAN | Indicador conteúdo adulto | Sim |
| overview | TEXT | Sinopse | Sim |
| tagline | TEXT | Slogan | Sim |
| homepage | TEXT | URL site oficial | Sim |
| imdb_id | VARCHAR(20) | ID no IMDB | Sim |
| poster_path | VARCHAR(200) | Caminho do poster | Sim |
| tmdb_id | INTEGER | ID no TMDB | Sim |

### 🔗 Atributos Compostos (Listas/Arrays)

| Atributo | Tipo | Descrição | Formato |
|----------|------|-----------|---------|
| genres_list | TEXT | Lista de gêneros | JSON Array |
| production_companies_list | TEXT | Lista de produtoras | JSON Array |
| production_countries_list | TEXT | Lista de países | JSON Array |
| top_actors | TEXT | Top 5 atores | JSON Array |
| keywords_list | TEXT | Palavras-chave | JSON Array |

### 🧮 Atributos Derivados/Calculados

| Atributo | Tipo | Fórmula/Origem | Descrição |
|----------|------|----------------|-----------|
| release_year | INTEGER | EXTRACT(YEAR FROM release_date) | Ano do lançamento |
| release_month | INTEGER | EXTRACT(MONTH FROM release_date) | Mês do lançamento |
| release_decade | INTEGER | (release_year / 10) * 10 | Década |
| profit | BIGINT | revenue - budget | Lucro |
| roi | NUMERIC(15,2) | (profit / budget) * 100 | ROI % |
| budget_category | VARCHAR(50) | Função de categorização | Categoria orçamento |
| revenue_category | VARCHAR(50) | Função de categorização | Categoria receita |
| runtime_category | VARCHAR(50) | Função de categorização | Categoria duração |
| primary_genre | VARCHAR(100) | Primeiro de genres_list | Gênero principal |
| primary_company | VARCHAR(200) | Primeiro de companies_list | Produtora principal |
| primary_country | VARCHAR(100) | Primeiro de countries_list | País principal |
| director | VARCHAR(200) | Extração de credits.crew | Diretor |
| lead_actor | VARCHAR(200) | Primeiro de credits.cast | Ator principal |
| cast_size | INTEGER | COUNT(credits.cast) | Tamanho elenco |
| crew_size | INTEGER | COUNT(credits.crew) | Tamanho equipe |
| keywords_count | INTEGER | COUNT(keywords) | Qtd keywords |
| avg_rating | NUMERIC(3,2) | AVG(ratings) | Média ratings |
| median_rating | NUMERIC(3,2) | MEDIAN(ratings) | Mediana ratings |
| std_rating | NUMERIC(3,2) | STDDEV(ratings) | Desvio padrão |
| total_ratings | INTEGER | COUNT(ratings) | Total avaliações |
| min_rating | NUMERIC(3,2) | MIN(ratings) | Menor nota |
| max_rating | NUMERIC(3,2) | MAX(ratings) | Maior nota |
| unique_users | INTEGER | COUNT(DISTINCT user_id) | Usuários únicos |
| imdb_id_formatted | VARCHAR(20) | 'tt' + LPAD(imdb_id) | IMDB formatado |

---

## 🔗 Relacionamentos

**Não há relacionamentos entre entidades** porque existe apenas uma única entidade no modelo SILVER.

---

## 📐 Regras de Negócio Incorporadas

### RN01: Integridade de Chave
- Cada filme deve ter um ID único
- ID não pode ser NULL

### RN02: Cálculos Derivados
- Lucro = Receita - Orçamento
- ROI = (Lucro / Orçamento) × 100
- Se Orçamento = 0, ROI = NULL

### RN03: Extração de Valores Primários
- Gênero/Companhia/País primário = primeiro da lista JSON
- Se lista vazia, valor = NULL

### RN04: Categorização Automática
- Budget/Revenue/Runtime classificados em categorias predefinidas
- Baseado em faixas de valores

### RN05: Agregações de Ratings
- Estatísticas calculadas a partir de múltiplas avaliações
- Filmes sem ratings terão campos NULL

---

## 📊 Cardinalidade

Como há apenas uma entidade, não há cardinalidades de relacionamento.

**Cardinalidade de Instâncias:**
- **Total de Filmes:** 45.433

---

## 🎨 Características do Modelo

### ✅ Modelo Flat (Plano/Desnormalizado)

**Vantagens:**
1. **Simplicidade:** Fácil de entender e consultar
2. **Performance de Leitura:** Sem JOINs necessários
3. **ETL Simplificado:** Processo de carga direto
4. **Preparação para Dimensional:** Fonte única para GOLD

**Desvantagens Aceitáveis:**
1. **Redundância:** Informações repetidas (não aplicável aqui)
2. **Espaço:** Maior uso de storage
3. **Atualização:** Mais complexo (mas é append-only)

### 🎯 Normalização: **0FN (Forma Não Normalizada)**

**Justificativa:**
- Camada intermediária de transformação
- Não há requisito de normalização
- Prioridade em facilitar ETL SILVER → GOLD

---

## 🔄 Origem dos Dados (RAW → SILVER)

A entidade FILME consolidou dados de múltiplas fontes RAW:

```
┌─────────────────┐
│ movies_metadata │ → Dados básicos do filme
└─────────────────┘

┌─────────────────┐
│    credits      │ → Diretor, atores, equipes
└─────────────────┘

┌─────────────────┐
│    keywords     │ → Palavras-chave
└─────────────────┘

┌─────────────────┐
│    ratings      │ → Estatísticas agregadas
└─────────────────┘

┌─────────────────┐
│     links       │ → IDs de plataformas
└─────────────────┘

         ↓ CONSOLIDAÇÃO (ETL)

┌─────────────────┐
│   movies_raw    │ → Tabela única SILVER
└─────────────────┘
```

---

## 💾 Volumetria

| Métrica | Valor |
|---------|-------|
| Entidades | 1 |
| Relacionamentos | 0 |
| Atributos Totais | 48 |
| Atributos Derivados | 25 |
| Atributos Básicos | 18 |
| Atributos Compostos | 5 |
| Instâncias (Filmes) | 45.433 |

---

## 🚀 Evolução do Modelo

### RAW → SILVER (Transformações Aplicadas)
1. ✅ Consolidação de 5 CSVs em 1 tabela
2. ✅ Limpeza e tratamento de NULLs
3. ✅ Derivação de atributos calculados
4. ✅ Categorização de valores numéricos
5. ✅ Extração de valores primários
6. ✅ Agregação de ratings

### SILVER → GOLD (Próximas Transformações)
1. 🔄 Quebra em modelo dimensional (Star Schema)
2. 🔄 Criação de 7 dimensões
3. 🔄 Criação de 1 tabela fato
4. 🔄 Estabelecimento de relacionamentos
5. 🔄 Surrogate keys
6. 🔄 Otimização para OLAP

---

## 📝 Observações Finais

1. **Modelo Transitório:** SILVER serve como ponte entre RAW e GOLD
2. **Não há Integridade Referencial:** Tabela única, sem FKs
3. **Preparado para Análise:** Estrutura já facilita queries básicas
4. **Fonte Única de Verdade:** Para criação do modelo dimensional
5. **Append-Only:** Dados não são atualizados, apenas inseridos

---

**Conclusão:** O MER da camada SILVER é intencionalmente simplificado para facilitar transformações subsequentes na camada GOLD.
