# 📚 Dicionário de Dados - Camada RAW (Bronze)

## Objetivo do Projeto
**Analisar o desempenho comercial e características dos filmes para identificar padrões de sucesso e tendências da indústria cinematográfica**

---

## 📊 Datasets Disponíveis

### Resumo Geral
| Dataset | Linhas | Colunas | Tamanho | Descrição |
|---------|--------|---------|---------|-----------|
| **movies_metadata.csv** | ~45,000 | 24 | ~12 MB | Informações detalhadas sobre filmes |
| **credits.csv** | ~45,000 | 3 | ~80 MB | Elenco e equipe técnica dos filmes |
| **ratings.csv** | ~26M | 4 | ~670 MB | Avaliações de usuários |
| **keywords.csv** | ~46,000 | 2 | ~7 MB | Palavras-chave associadas aos filmes |
| **links.csv** | ~45,000 | 3 | ~1 MB | IDs externos (IMDB, TMDB) |

---

## 1️⃣ Movies Metadata (movies_metadata.csv)

**Descrição:** Dataset principal contendo informações detalhadas sobre filmes, incluindo métricas financeiras, datas de lançamento, avaliações e metadados.

### Colunas

| Coluna | Tipo | Descrição | Valores Nulos | Observações |
|--------|------|-----------|---------------|-------------|
| **adult** | boolean | Indica se o filme é adulto | Não | true/false |
| **belongs_to_collection** | object/JSON | Coleção à qual o filme pertence | ~60% | Formato JSON |
| **budget** | numeric | Orçamento de produção do filme (US$) | Sim | Muitos zeros (sem informação) |
| **genres** | object/JSON | Gêneros do filme | Sim | Formato JSON, múltiplos valores |
| **homepage** | string | URL do site oficial do filme | ~70% | |
| **id** | integer | ID único do filme (TMDB) | Não | Chave primária |
| **imdb_id** | string | ID do filme no IMDB | Sim | Formato: tt0000000 |
| **original_language** | string | Idioma original do filme | Não | Código ISO (en, fr, ja, etc.) |
| **original_title** | string | Título original do filme | Não | |
| **overview** | string | Sinopse/descrição do filme | Sim | Texto longo |
| **popularity** | numeric | Score de popularidade | Não | Valores entre 0 e 500+ |
| **poster_path** | string | Caminho para o poster do filme | Sim | URL relativa |
| **production_companies** | object/JSON | Empresas produtoras | Sim | Formato JSON, múltiplos valores |
| **production_countries** | object/JSON | Países de produção | Sim | Formato JSON, múltiplos valores |
| **release_date** | date | Data de lançamento do filme | Sim | Formato: YYYY-MM-DD |
| **revenue** | numeric | Receita total do filme (US$) | Sim | Muitos zeros (sem informação) |
| **runtime** | numeric | Duração do filme em minutos | Sim | |
| **spoken_languages** | object/JSON | Idiomas falados no filme | Sim | Formato JSON, múltiplos valores |
| **status** | string | Status de lançamento | Não | Released, Post Production, etc. |
| **tagline** | string | Slogan/frase de efeito do filme | ~60% | |
| **title** | string | Título do filme | Não | Pode diferir do original_title |
| **video** | boolean | Indica se há vídeo disponível | Não | true/false |
| **vote_average** | numeric | Média de avaliações | Não | Escala 0-10 |
| **vote_count** | integer | Número total de votos/avaliações | Não | |

### Observações Importantes
- **Budget e Revenue:** Muitos valores são 0 (sem informação), não valores nulos
- **Formatos JSON:** Colunas como genres, production_companies, etc. precisam de parsing
- **IDs:** O campo `id` é a chave primária e relaciona com outros datasets
- **Correlações:** Forte correlação entre budget e revenue (0.73)

---

## 2️⃣ Credits (credits.csv)

**Descrição:** Informações sobre elenco (cast) e equipe técnica (crew) dos filmes.

### Colunas

| Coluna | Tipo | Descrição | Valores Nulos | Observações |
|--------|------|-----------|---------------|-------------|
| **cast** | object/JSON | Lista de atores e personagens | Não | Array JSON com múltiplos objetos |
| **crew** | object/JSON | Lista de equipe técnica | Não | Array JSON com múltiplos objetos |
| **id** | integer | ID do filme (TMDB) | Não | Chave estrangeira para movies_metadata |

### Estrutura JSON - Cast
```json
[
  {
    "cast_id": 14,
    "character": "Woody (voice)",
    "credit_id": "52fe4284c3a36847f8024f95",
    "gender": 2,
    "id": 31,
    "name": "Tom Hanks",
    "order": 0,
    "profile_path": "/pQFoyx7rp09CJTAb932F2g8Nlho.jpg"
  }
]
```

### Estrutura JSON - Crew
```json
[
  {
    "credit_id": "52fe4284c3a36847f8024f49",
    "department": "Directing",
    "gender": 2,
    "id": 7879,
    "job": "Director",
    "name": "John Lasseter",
    "profile_path": "/7EdqiNbr4FRjIhKHyPPdFfEEEFG.jpg"
  }
]
```

### Observações Importantes
- **Tamanho variável:** Filmes têm de 0 a 100+ membros no elenco
- **Parsing necessário:** Dados em formato JSON precisam ser extraídos
- **Informações úteis:** Nome do diretor, atores principais, equipe técnica

---

## 3️⃣ Ratings (ratings.csv)

**Descrição:** Avaliações de usuários para filmes, contendo milhões de registros.

### Colunas

| Coluna | Tipo | Descrição | Valores Nulos | Observações |
|--------|------|-----------|---------------|-------------|
| **userId** | integer | ID único do usuário | Não | |
| **movieId** | integer | ID do filme | Não | Relaciona com links.csv |
| **rating** | float | Avaliação do usuário | Não | Escala 0.5 a 5.0 (incrementos de 0.5) |
| **timestamp** | integer | Data/hora da avaliação | Não | Unix timestamp |

### Estatísticas
- **Total de usuários:** ~270,000 usuários únicos
- **Total de filmes avaliados:** ~45,000 filmes
- **Total de avaliações:** ~26 milhões
- **Média de avaliações por usuário:** ~96 avaliações
- **Média de avaliações por filme:** ~577 avaliações
- **Distribuição:** Concentrada em ratings de 3.5-4.0

### Observações Importantes
- **Alto volume:** Dataset maior em número de linhas
- **Qualidade:** Sem valores nulos
- **Relacionamento:** movieId relaciona com links.csv, não diretamente com movies_metadata.csv

---

## 4️⃣ Keywords (keywords.csv)

**Descrição:** Palavras-chave associadas aos filmes para categorização e busca.

### Colunas

| Coluna | Tipo | Descrição | Valores Nulos | Observações |
|--------|------|-----------|---------------|-------------|
| **id** | integer | ID do filme (TMDB) | Não | Chave estrangeira para movies_metadata |
| **keywords** | object/JSON | Lista de palavras-chave | Não | Array JSON |

### Estrutura JSON
```json
[
  {
    "id": 931,
    "name": "jealousy"
  },
  {
    "id": 4290,
    "name": "toy"
  },
  {
    "id": 5202,
    "name": "boy"
  }
]
```

### Observações Importantes
- **Quantidade variável:** 0 a 20+ keywords por filme
- **Formato JSON:** Necessita parsing para extração
- **Útil para:** Análise de temas, categorização, recomendação

---

## 5️⃣ Links (links.csv)

**Descrição:** Mapeamento de IDs entre diferentes sistemas (MovieLens, IMDB, TMDB).

### Colunas

| Coluna | Tipo | Descrição | Valores Nulos | Observações |
|--------|------|-----------|---------------|-------------|
| **movieId** | integer | ID do filme (MovieLens) | Não | Usado no dataset ratings |
| **imdbId** | integer | ID do filme no IMDB | Não | Sem prefixo 'tt' |
| **tmdbId** | integer | ID do filme no TMDB | ~3% | Relaciona com movies_metadata.id |

### Observações Importantes
- **Ponte de relacionamento:** Liga ratings.csv com movies_metadata.csv
- **Formato IMDB:** Não tem o prefixo 'tt', diferente de movies_metadata.imdb_id
- **Alguns nulos:** tmdbId tem alguns valores ausentes

---

## 🔗 Relacionamentos entre Datasets

```
movies_metadata.csv (id) ←→ credits.csv (id)
                      ↓
                    (id) ←→ keywords.csv (id)
                      ↓
                 (id = tmdbId) ←→ links.csv (tmdbId)
                                        ↓
                                  (movieId) ←→ ratings.csv (movieId)
```

### Chaves de Relacionamento
1. **movies_metadata.id** ↔ **credits.id**: Relacionamento direto 1:1
2. **movies_metadata.id** ↔ **keywords.id**: Relacionamento direto 1:1
3. **movies_metadata.id** ↔ **links.tmdbId**: Relacionamento via TMDB ID
4. **links.movieId** ↔ **ratings.movieId**: Relacionamento via MovieLens ID

---

## 📋 Qualidade dos Dados - Resumo

### Principais Problemas Identificados

1. **Valores Nulos:**
   - `homepage`: ~70% nulos
   - `tagline`: ~60% nulos
   - `belongs_to_collection`: ~60% nulos
   - `budget` e `revenue`: Muitos zeros (sem informação)
   - `runtime`: ~5% nulos

2. **Formatos a Tratar:**
   - Colunas JSON: genres, production_companies, cast, crew, keywords
   - Datas: release_date precisa ser convertida para datetime
   - Tipos numéricos: budget, revenue, runtime têm valores string

3. **Duplicatas:**
   - Não foram identificadas duplicatas significativas

4. **Inconsistências:**
   - IDs do IMDB em formatos diferentes (com/sem 'tt')
   - Valores 0 vs NULL para indicar ausência de informação

---

## 🎯 Próximos Passos

### Para Camada Silver:
1. Converter colunas JSON em tabelas normalizadas
2. Tratar valores nulos com estratégias apropriadas
3. Corrigir tipos de dados (numeric, datetime)
4. Criar colunas derivadas (profit, ROI, decade)
5. Normalizar relacionamentos entre tabelas
6. Extrair informações principais (diretor, atores principais)
7. Categorizar filmes (por orçamento, receita, década)

### Para Camada Gold:
1. Criar tabela fato com métricas principais
2. Criar dimensões (tempo, gênero, idioma, país, estúdio)
3. Implementar esquema estrela/floco de neve
4. Preparar dados para análise no Power BI

---

**Última atualização:** Novembro 2025  
**Status:** Camada RAW - Análise Exploratória Concluída