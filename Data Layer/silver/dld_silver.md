# 📚 DLD - Dicionário Lógico de Dados (Camada Silver)

## Descrição Geral
Este documento apresenta o Dicionário Lógico de Dados (DLD) da camada Silver, especificando detalhadamente cada atributo das tabelas, seus tipos de dados, restrições, valores padrão e regras de negócio aplicáveis.

---

## 📋 Tabela: MOVIES

**Descrição:** Armazena informações detalhadas sobre filmes processados e transformados da camada RAW.

**Nome Físico:** `movies`

**Engine:** InnoDB

**Charset:** utf8mb4

**Collation:** utf8mb4_unicode_ci

---

### Atributos da Tabela MOVIES

| # | Nome Lógico | Nome Físico | Tipo de Dado | Tamanho | Nulável | PK | FK | Unique | Default | Descrição | Regras/Observações |
|---|-------------|-------------|--------------|---------|---------|----|----|--------|---------|-----------|-------------------|
| 1 | ID do Filme | `id` | INT | - | NÃO | ✅ | ❌ | ✅ | - | Identificador único do filme no sistema | PK. Chave primária da tabela. Corresponde ao ID do TMDB. |
| 2 | Título | `title` | VARCHAR | 500 | NÃO | ❌ | ❌ | ❌ | - | Título do filme (traduzido ou mais conhecido) | Campo obrigatório. Indexado para buscas. |
| 3 | Sinopse | `overview` | TEXT | 65535 | SIM | ❌ | ❌ | ❌ | NULL | Resumo/sinopse do enredo do filme | Pode conter até ~65KB de texto. |
| 4 | Data de Lançamento | `release_date` | DATE | - | SIM | ❌ | ❌ | ❌ | NULL | Data oficial de lançamento do filme | Formato: YYYY-MM-DD. Permite consultas temporais. |
| 5 | Orçamento | `budget` | BIGINT | - | SIM | ❌ | ❌ | ❌ | 0 | Orçamento de produção em dólares (USD) | Valor 0 pode indicar "não informado". Permite até ~9 quintilhões. |
| 6 | Receita | `revenue` | BIGINT | - | SIM | ❌ | ❌ | ❌ | 0 | Receita total de bilheteria em dólares (USD) | Valor 0 pode indicar "não informado". |
| 7 | Duração | `runtime` | FLOAT | - | SIM | ❌ | ❌ | ❌ | NULL | Duração do filme em minutos | Valores decimais permitidos (ex: 95.5 minutos). |
| 8 | Popularidade | `popularity` | FLOAT | - | SIM | ❌ | ❌ | ❌ | 0.0 | Métrica de popularidade do TMDB | Valor calculado pelo TMDB. Maior = mais popular. |
| 9 | Status | `status` | VARCHAR | 50 | SIM | ❌ | ❌ | ❌ | NULL | Status atual do filme | Valores comuns: 'Released', 'Post Production', 'Rumored'. |
| 10 | Slogan | `tagline` | TEXT | 65535 | SIM | ❌ | ❌ | ❌ | NULL | Frase de efeito/slogan do filme | Marketing do filme. |
| 11 | Nota Média | `vote_average` | DECIMAL | 4,2 | SIM | ❌ | ❌ | ❌ | NULL | Nota média de avaliação (0 a 10) | Precisão de 2 casas decimais. Ex: 7.85 |
| 12 | Contagem de Votos | `vote_count` | INT | - | SIM | ❌ | ❌ | ❌ | 0 | Número total de votos recebidos | Indica quantidade de avaliações no TMDB. |
| 13 | ID IMDb | `imdb_id` | VARCHAR | 20 | SIM | ❌ | ❌ | ❌ | NULL | Identificador do filme no IMDb | Formato: 'tt' + números (ex: tt0114709). |
| 14 | Idioma Original | `original_language` | VARCHAR | 10 | SIM | ❌ | ❌ | ❌ | NULL | Código ISO 639-1 do idioma original | Ex: 'en' (inglês), 'pt' (português), 'es' (espanhol). |
| 15 | Gêneros | `genres` | TEXT | 65535 | SIM | ❌ | ❌ | ❌ | NULL | Lista de gêneros separados por vírgula | Ex: "Action, Adventure, Sci-Fi". Desnormalizado. |
| 16 | Companhias de Produção | `production_companies` | TEXT | 65535 | SIM | ❌ | ❌ | ❌ | NULL | Produtoras separadas por vírgula | Ex: "Pixar, Walt Disney Pictures". Desnormalizado. |
| 17 | Países de Produção | `production_countries` | TEXT | 65535 | SIM | ❌ | ❌ | ❌ | NULL | Países produtores separados por vírgula | Ex: "United States, United Kingdom". Desnormalizado. |
| 18 | Idiomas Falados | `spoken_languages` | TEXT | 65535 | SIM | ❌ | ❌ | ❌ | NULL | Idiomas do filme separados por vírgula | Ex: "English, French". Desnormalizado. |
| 19 | Coleção/Franquia | `belongs_to_collection` | TEXT | 65535 | SIM | ❌ | ❌ | ❌ | NULL | Nome da coleção/franquia | Ex: "Star Wars Collection". NULL se não pertence. |

---

### Índices da Tabela MOVIES

| Nome do Índice | Tipo | Colunas | Descrição |
|----------------|------|---------|-----------|
| PRIMARY | PRIMARY KEY | `id` | Chave primária - acesso direto por ID |
| idx_release_date | INDEX | `release_date` | Otimiza consultas por período/ano |
| idx_popularity | INDEX | `popularity` | Otimiza ordenação por popularidade |
| idx_vote_average | INDEX | `vote_average` | Otimiza consultas de filmes bem avaliados |
| idx_title | INDEX | `title(100)` | Otimiza buscas por título (prefix index) |

---

### Constraints da Tabela MOVIES

| Nome | Tipo | Descrição |
|------|------|-----------|
| PK_MOVIES | PRIMARY KEY | `id` deve ser único e não nulo |
| CHK_BUDGET | CHECK | `budget >= 0` |
| CHK_REVENUE | CHECK | `revenue >= 0` |
| CHK_RUNTIME | CHECK | `runtime IS NULL OR runtime > 0` |
| CHK_VOTE_AVERAGE | CHECK | `vote_average IS NULL OR (vote_average >= 0 AND vote_average <= 10)` |

---

## 📊 Tabela: RATINGS

**Descrição:** Armazena as avaliações de filmes realizadas por usuários.

**Nome Físico:** `ratings`

**Engine:** InnoDB

**Charset:** utf8mb4

**Collation:** utf8mb4_unicode_ci

---

### Atributos da Tabela RATINGS

| # | Nome Lógico | Nome Físico | Tipo de Dado | Tamanho | Nulável | PK | FK | Unique | Default | Descrição | Regras/Observações |
|---|-------------|-------------|--------------|---------|---------|----|----|--------|---------|-----------|-------------------|
| 1 | ID do Usuário | `user_id` | INT | - | NÃO | ✅ | ❌ | ✅* | - | Identificador único do usuário avaliador | Parte da chave primária composta. |
| 2 | ID do Filme | `movie_id` | INT | - | NÃO | ✅ | ✅ | ✅* | - | Referência ao filme avaliado | Parte da PK composta + FK para MOVIES.id |
| 3 | Nota | `rating` | DECIMAL | 3,1 | NÃO | ❌ | ❌ | ❌ | - | Nota atribuída ao filme | Escala de 0.5 a 5.0 com incremento de 0.5 |
| 4 | Data/Hora da Avaliação | `rating_timestamp` | DATETIME | - | NÃO | ❌ | ❌ | ❌ | CURRENT_TIMESTAMP | Momento em que a avaliação foi realizada | Timestamp completo com data e hora |

**Observação:** ✅* indica que a combinação (user_id, movie_id) é única através da PK composta.

---

### Índices da Tabela RATINGS

| Nome do Índice | Tipo | Colunas | Descrição |
|----------------|------|---------|-----------|
| PRIMARY | PRIMARY KEY | `(user_id, movie_id)` | Garante que um usuário avalie cada filme apenas uma vez |
| FK_RATINGS_MOVIES | FOREIGN KEY INDEX | `movie_id` | FK para MOVIES - criado automaticamente |
| idx_rating_timestamp | INDEX | `rating_timestamp` | Otimiza consultas temporais de avaliações |
| idx_rating | INDEX | `rating` | Otimiza consultas por faixa de nota |

---

### Constraints da Tabela RATINGS

| Nome | Tipo | Descrição |
|------|------|-----------|
| PK_RATINGS | PRIMARY KEY | Combinação `(user_id, movie_id)` deve ser única |
| FK_RATINGS_MOVIES | FOREIGN KEY | `movie_id` referencia `MOVIES(id)` |
| CHK_RATING_RANGE | CHECK | `rating >= 0.5 AND rating <= 5.0` |
| CHK_RATING_INCREMENT | CHECK | `(rating * 10) % 5 = 0` (múltiplo de 0.5) |

---

### Regras de Integridade Referencial - RATINGS

| FK | Tabela Origem | Coluna Origem | Tabela Destino | Coluna Destino | ON DELETE | ON UPDATE |
|----|---------------|---------------|----------------|----------------|-----------|-----------|
| FK_RATINGS_MOVIES | RATINGS | movie_id | MOVIES | id | NO ACTION | CASCADE |

**Explicação:**
- **ON DELETE NO ACTION:** Não permite deletar um filme que possui avaliações (preserva histórico)
- **ON UPDATE CASCADE:** Se o ID do filme for alterado, atualiza automaticamente nas avaliações

---

## 🎯 Regras de Negócio Implementadas no DLD

### RN01 - Unicidade de Filmes
- **Campo:** `MOVIES.id`
- **Implementação:** PRIMARY KEY
- **Descrição:** Cada filme deve ter um identificador único no sistema

### RN02 - Avaliação Única por Usuário
- **Campos:** `RATINGS.(user_id, movie_id)`
- **Implementação:** PRIMARY KEY composta
- **Descrição:** Um usuário pode avaliar o mesmo filme apenas uma vez

### RN03 - Integridade Referencial
- **Campos:** `RATINGS.movie_id → MOVIES.id`
- **Implementação:** FOREIGN KEY
- **Descrição:** Toda avaliação deve referenciar um filme existente

### RN04 - Validação de Notas
- **Campo:** `RATINGS.rating`
- **Implementação:** CHECK CONSTRAINT
- **Descrição:** Notas devem estar entre 0.5 e 5.0, com incremento de 0.5

### RN05 - Valores Financeiros Não-Negativos
- **Campos:** `MOVIES.budget`, `MOVIES.revenue`
- **Implementação:** CHECK CONSTRAINT
- **Descrição:** Valores financeiros não podem ser negativos

### RN06 - Registro Temporal Automático
- **Campo:** `RATINGS.rating_timestamp`
- **Implementação:** DEFAULT CURRENT_TIMESTAMP
- **Descrição:** Registra automaticamente o momento da avaliação

### RN07 - Validação de Duração
- **Campo:** `MOVIES.runtime`
- **Implementação:** CHECK CONSTRAINT
- **Descrição:** Se informado, a duração deve ser maior que zero

### RN08 - Validação de Nota Média
- **Campo:** `MOVIES.vote_average`
- **Implementação:** CHECK CONSTRAINT
- **Descrição:** Nota média deve estar entre 0 e 10

---

## 📊 Domínios e Valores Válidos

### Status do Filme (`MOVIES.status`)
Valores típicos (não restritivo):
- `Released` - Filme lançado
- `Post Production` - Em pós-produção
- `Rumored` - Boatos/não confirmado
- `Planned` - Planejado
- `In Production` - Em produção
- `Canceled` - Cancelado

### Idiomas (`MOVIES.original_language`, `MOVIES.spoken_languages`)
Formato: Código ISO 639-1 (2 letras)
- `en` - Inglês
- `pt` - Português
- `es` - Espanhol
- `fr` - Francês
- `de` - Alemão
- etc.

### Notas de Avaliação (`RATINGS.rating`)
Valores válidos: {0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0}

---

## 🔄 Transformações Aplicadas (RAW → SILVER)

### MOVIES
1. **Limpeza de IDs inválidos:** Removidos registros com ID não-numérico
2. **Conversão de tipos:** 
   - `budget`: object → BIGINT
   - `revenue`: object → BIGINT (já era float64)
   - `release_date`: object → DATE
   - `popularity`: object → FLOAT
3. **Extração de JSON:**
   - `genres`: JSON array → TEXT concatenado
   - `production_companies`: JSON array → TEXT concatenado (limitado a 3)
   - `production_countries`: JSON array → TEXT concatenado
   - `spoken_languages`: JSON array → TEXT concatenado
   - `belongs_to_collection`: JSON object → TEXT (nome da coleção)
4. **Remoção de duplicatas:** Mantida primeira ocorrência
5. **Tratamento de nulos:** Strings vazias para campos de texto

### RATINGS
1. **Renomeação de colunas:** 
   - `userId` → `user_id`
   - `movieId` → `movie_id`
   - `timestamp` → `rating_timestamp`
2. **Conversão de timestamp:** Unix timestamp → DATETIME
3. **Filtro de integridade:** Mantidas apenas avaliações de filmes existentes em MOVIES

---

## 📈 Estimativa de Armazenamento

### MOVIES (por registro)
- Campos numéricos: ~60 bytes
- Campos de texto variável: ~1-5 KB (depende do conteúdo)
- **Média estimada:** ~3 KB por filme
- **Para 45.000 filmes:** ~135 MB

### RATINGS (por registro)
- Todos os campos: ~20 bytes
- **Para 100.000 avaliações:** ~2 MB

**Total estimado do banco:** ~150-200 MB (incluindo índices)

---

## 🔐 Permissões e Segurança

### Usuários Recomendados
1. **app_user** (aplicação)
   - SELECT, INSERT, UPDATE em RATINGS
   - SELECT em MOVIES
   
2. **admin_user** (administração)
   - ALL PRIVILEGES em ambas as tabelas
   
3. **readonly_user** (leitura/análise)
   - SELECT em ambas as tabelas

---

## 📝 Observações Finais

1. **Desnormalização Intencional:** Os campos de gêneros, companhias e idiomas foram mantidos como TEXT concatenado para simplificar a estrutura inicial. Futura normalização pode criar tabelas auxiliares.

2. **Performance:** Índices criados para otimizar as consultas mais comuns (por título, data, popularidade).

3. **Escalabilidade:** A estrutura atual suporta crescimento para milhões de registros com performance adequada.

4. **Charset UTF-8:** Suporta caracteres especiais e emojis (utf8mb4).

5. **Campos Calculados:** `vote_average` e `vote_count` são mantidos em MOVIES para performance, mesmo que possam ser calculados a partir de RATINGS.

---

**Versão:** 1.0  
**Data:** 2024  
**Autor:** Sistema de Análise de Filmes - Camada Silver  
**Status:** Produção
