# DER - Diagrama Entidade-Relacionamento (GOLD Layer)

## Modelo Dimensional - Star Schema

### Visão Geral
O modelo dimensional da camada GOLD segue o padrão **Star Schema** (Esquema Estrela), otimizado para análises OLAP (Online Analytical Processing). Este modelo é composto por:
- **1 Tabela Fato Central**: `fto_filme`
- **7 Dimensões**: `dim_tempo`, `dim_filme`, `dim_genero`, `dim_companhia`, `dim_geografia`, `dim_diretor`, `dim_ator`

---

## Diagrama Conceitual

```
                    ┌─────────────────┐
                    │   dim_tempo     │
                    ├─────────────────┤
                    │ PK sk_tempo     │
                    │    ano          │
                    │    decada       │
                    └────────┬────────┘
                             │
                             │ 1
                             │
    ┌─────────────────┐      │      ┌─────────────────┐
    │  dim_genero     │      │      │  dim_companhia  │
    ├─────────────────┤      │      ├─────────────────┤
    │ PK sk_genero    │      │      │ PK sk_companhia │
    │    gen_nome     │      │      │    comp_nome    │
    └────────┬────────┘      │      └────────┬────────┘
             │               │               │
             │ 1             │               │ 1
             │               │               │
             │      ┌────────┴────────┐      │
             └──────┤   fto_filme     ├──────┘
                 N  │ (FATO CENTRAL)  │  N
                    ├─────────────────┤
                    │ PK fto_srk      │
                    │ FK sk_tempo     │
                    │ FK sk_filme     │
         ┌──────────┤ FK sk_genero    ├──────────┐
         │          │ FK sk_companhia │          │
         │          │ FK sk_geografia │          │
         │          │ FK sk_diretor   │          │
         │          │ FK sk_ator      │          │
         │          │                 │          │
         │          │ vlr_receita     │          │
         │          │ vlr_orcamento   │          │
         │          │ vlr_lucro       │          │
         │          │ pct_roi         │          │
         │          │ med_popularidade│          │
         │          │ qtd_votos       │          │
         │          │ med_avaliacao   │          │
         │          └─────────────────┘          │
         │ N                                 N   │
         │                                       │
┌────────┴────────┐                     ┌────────┴────────┐
│  dim_filme      │                     │  dim_geografia  │
├─────────────────┤                     ├─────────────────┤
│ PK sk_filme     │                     │ PK sk_geografia │
│    mov_id       │                     │    geo_pais     │
│    mov_titulo   │                     └─────────────────┘
│    mov_titulo_  │
│      original   │
│    mov_idioma   │        ┌─────────────────┐
│    mov_overview │        │  dim_diretor    │
│    mov_tagline  │        ├─────────────────┤
│    mov_status   │        │ PK sk_diretor   │
│    mov_data_    │        │    dir_nome     │
│      lancamento │        └────────┬────────┘
│    mov_duracao  │                 │
│    mov_adulto   │                 │ 1
└─────────────────┘                 │
                                    │
                           ┌────────┴────────┐
                           │   fto_filme     │
                           │                 │
                           └────────┬────────┘
                                    │
                                    │ N
                                    │
                           ┌────────┴────────┐
                           │   dim_ator      │
                           ├─────────────────┤
                           │ PK sk_ator      │
                           │    ator_nome    │
                           └─────────────────┘
```

---

## Relacionamentos

### Cardinalidade: 1:N (Um para Muitos)

Todas as dimensões têm relacionamento **1:N** com a tabela fato:

| **Dimensão**        | **Chave Dimensão** | **→** | **Chave Fato**        | **Cardinalidade** |
|---------------------|-------------------|-------|-----------------------|-------------------|
| `dim_tempo`         | `tmp_srk`         | →     | `fto_filme.tmp_fky`   | 1:N              |
| `dim_filme`         | `mov_srk`         | →     | `fto_filme.mov_fky`   | 1:N              |
| `dim_genero`        | `gnr_srk`         | →     | `fto_filme.gnr_fky`   | 1:N              |
| `dim_companhia`     | `cmp_srk`         | →     | `fto_filme.cmp_fky`   | 1:N              |
| `dim_geografia`     | `geo_srk`         | →     | `fto_filme.geo_fky`   | 1:N              |
| `dim_diretor`       | `dir_srk`         | →     | `fto_filme.dir_fky`   | 1:N              |
| `dim_ator`          | `act_srk`         | →     | `fto_filme.act_fky`   | 1:N              |

---

## Descrição dos Relacionamentos

### 1. **dim_tempo → fto_filme**
- **Relacionamento**: Uma data pode ter vários filmes (1:N)
- **Significado**: Cada registro de fato está associado a uma data específica de lançamento
- **Uso**: Análises temporais (evolução ao longo dos anos, tendências por mês, trimestre, década)

### 2. **dim_filme → fto_filme**
- **Relacionamento**: Um filme pode ter vários registros de fato (1:N)
- **Significado**: Um filme pode aparecer múltiplas vezes na fato com diferentes combinações de dimensões
- **Uso**: Análises por filme específico, rankings de filmes

### 3. **dim_genero → fto_filme**
- **Relacionamento**: Um gênero pode ter vários filmes (1:N)
- **Significado**: Cada registro de fato representa um filme de um gênero específico
- **Uso**: Análises por gênero (receita por gênero, popularidade, categoria)

### 4. **dim_companhia → fto_filme**
- **Relacionamento**: Uma companhia pode produzir vários filmes (1:N)
- **Significado**: Cada registro de fato está associado a uma companhia produtora
- **Uso**: Análises por estúdio/produtora, tipo de companhia

### 5. **dim_geografia → fto_filme**
- **Relacionamento**: Um país pode produzir vários filmes (1:N)
- **Significado**: Cada registro de fato está associado a um país de produção
- **Uso**: Análises geográficas (produção por país, continente, região)

### 6. **dim_diretor → fto_filme**
- **Relacionamento**: Um diretor pode dirigir vários filmes (1:N)
- **Significado**: Cada registro de fato está associado a um diretor
- **Uso**: Análises de desempenho por diretor

### 7. **dim_ator → fto_filme**
- **Relacionamento**: Um ator pode atuar em vários filmes (1:N)
- **Significado**: Cada registro de fato está associado a um ator principal
- **Uso**: Análises de desempenho por ator

---

## Características do Star Schema

### ✅ Vantagens
1. **Simplicidade**: Estrutura fácil de entender e navegar
2. **Performance**: Queries otimizadas com JOINs diretos
3. **Flexibilidade**: Fácil adicionar novas dimensões
4. **Desnormalização**: Dimensões desnormalizadas para melhor performance

### 📊 Granularidade
- **Nível de Detalhe**: Cada registro na fato representa uma combinação única de:
  - Filme + Data + Gênero + Companhia + País + Diretor + Ator

### 🔑 Chaves Substitutas (Surrogate Keys)
- Todas as dimensões usam chaves substitutas (*_srk) ao invés de chaves naturais
- **Benefícios**:
  - Desempenho melhorado (inteiros sequenciais)
  - Independência de mudanças nos dados de origem
  - Suporte para histórico de mudanças (SCD)

---

## Normalização

- **Dimensões**: 3FN (Terceira Forma Normal) - Desnormalizadas intencionalmente para performance
- **Fato**: Contém apenas chaves e métricas (totalmente normalizada em relação às dimensões)

---

## Queries Típicas

### Exemplo 1: Receita Total por Ano
```sql
SELECT 
    t.ano_lancamento,
    SUM(f.vlr_receita) as receita_total
FROM gold.fto_filme f
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
GROUP BY t.ano_lancamento
ORDER BY t.ano_lancamento;
```

### Exemplo 2: Top 10 Gêneros por Lucro
```sql
SELECT 
    g.gnr_nome,
    g.gnr_categoria,
    SUM(f.vlr_lucro) as lucro_total
FROM gold.fto_filme f
JOIN gold.dim_genero g ON f.gnr_fky = g.gnr_srk
GROUP BY g.gnr_nome, g.gnr_categoria
ORDER BY lucro_total DESC
LIMIT 10;
```

### Exemplo 3: Análise Multidimensional
```sql
SELECT 
    t.ano_lancamento,
    t.tri_nome,
    g.gnr_nome,
    geo.geo_pais,
    geo.geo_continente,
    SUM(f.vlr_receita) as receita_total,
    AVG(f.med_avaliacao) as avaliacao_media,
    COUNT(DISTINCT f.mov_fky) as qtd_filmes
FROM gold.fto_filme f
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
JOIN gold.dim_genero g ON f.gnr_fky = g.gnr_srk
JOIN gold.dim_geografia geo ON f.geo_fky = geo.geo_srk
GROUP BY t.ano_lancamento, t.tri_nome, g.gnr_nome, geo.geo_pais, geo.geo_continente
ORDER BY receita_total DESC;
```

### Exemplo 4: Análise de Blockbusters
```sql
SELECT 
    m.mov_titulo,
    t.ano_lancamento,
    d.dir_nome,
    f.vlr_receita,
    f.vlr_orcamento,
    f.pct_roi,
    f.med_avaliacao
FROM gold.fto_filme f
JOIN gold.dim_filme m ON f.mov_fky = m.mov_srk
JOIN gold.dim_tempo t ON f.tmp_fky = t.tmp_srk
JOIN gold.dim_diretor d ON f.dir_fky = d.dir_srk
WHERE f.flg_blockbuster = TRUE
ORDER BY f.vlr_receita DESC
LIMIT 20;
```

---

## Integridade Referencial

- Todas as chaves estrangeiras na tabela fato possuem **FOREIGN KEY constraints**
- Garante que cada registro na fato aponte para registros válidos nas dimensões
- **Cascata**: Não há DELETE ou UPDATE CASCADE (dados históricos são preservados)

---

## Métricas Disponíveis na Fato

| **Métrica**          | **Tipo**        | **Descrição**                              |
|----------------------|-----------------|-------------------------------------------|
| `vlr_orcamento`      | BIGINT          | Orçamento de produção                     |
| `vlr_receita`        | BIGINT          | Receita total do filme                    |
| `vlr_lucro`          | BIGINT          | Lucro (receita - orçamento)               |
| `pct_roi`            | NUMERIC(15,3)   | Retorno sobre investimento (%)            |
| `med_avaliacao`      | NUMERIC(4,2)    | Média de avaliação (0-10)                 |
| `qtd_votos`          | INTEGER         | Quantidade de votos recebidos             |
| `med_popularidade`   | NUMERIC(15,3)   | Média de popularidade                     |
| `dur_minutos`        | INTEGER         | Duração do filme em minutos               |
| `qtd_elenco`         | INTEGER         | Quantidade de membros do elenco           |
| `qtd_equipe`         | INTEGER         | Quantidade de membros da equipe           |
| `flg_adulto`         | BOOLEAN         | Flag indicando conteúdo adulto            |
| `flg_blockbuster`    | BOOLEAN         | Flag indicando se é blockbuster           |

---

## Atributos Descritivos nas Dimensões

### dim_tempo (Dimensão Temporal Completa)
- Data completa, ano, mês, dia, trimestre, semana, década
- Flags: feriado, fim de semana
- **15 atributos** para análise temporal rica

### dim_filme (Catálogo de Filmes)
- Títulos (original e traduzido)
- Códigos (idioma, IMDb)
- URLs (homepage, poster)
- Categorias (status, orçamento, receita, duração)
- **14 atributos** descritivos

### dim_genero (Classificação por Gênero)
- Nome do gênero
- Descrição detalhada
- Categoria de agrupamento
- **4 atributos**

### dim_companhia (Produtoras)
- Nome da companhia
- Tipo (Production, Distribution, etc)
- **3 atributos**

### dim_geografia (Localização)
- País, código ISO, continente, região
- **5 atributos** para análise geográfica

### dim_diretor (Profissionais - Direção)
- Nome e nome completo
- **3 atributos**

### dim_ator (Profissionais - Atuação)
- Nome e nome completo
- **3 atributos**

---

## Modelo Implementado

**Status**: ✅ Implementado e Operacional
**Total de Tabelas**: 8 (1 fato + 7 dimensões)
**Total de Relacionamentos**: 7 (todos 1:N)
**Total de Atributos**: 
- Dimensões: 50 atributos
- Fato: 20 atributos (8 FKs + 12 métricas)
- **Total**: 70 atributos

---

**Última Atualização**: 2025-11-23
