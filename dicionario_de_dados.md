# 📘 Dicionário de Dados  

Este documento descreve os campos utilizados no dataset de filmes, detalhando o nome de cada coluna, seu tipo de dado original e o tipo ideal para análise, além de explicações e observações relevantes sobre possíveis inconsistências ou ajustes necessários.  

---

## 🧩 Estrutura das Tabelas de Dados  

### Movies_metada.csv


| **Nome da Coluna**        | **Tipo de Dado (Original)** | **Tipo de Dado (Ideal)**     | **Descrição**                                                       | **Observações / Problemas** |
|----------------------------|-----------------------------|-------------------------------|----------------------------------------------------------------------|------------------------------|
| `adult`                    | object                      | Boolean                      | Indica se o filme é para maiores de 18 (conteúdo adulto).            | Necessita conversão de texto para Booleano (True/False). |
| `belongs_to_collection`    | object                      | JSON/Text                    | Contém ID, nome e pôster da coleção/franquia do filme.               | Muitos nulos. Formato JSON em texto, necessita extração (parsing). |
| `budget`                   | object                      | Numeric (Integer)             | Orçamento de produção do filme em dólares.                           | Necessita conversão para tipo numérico. |
| `genres`                   | object                      | JSON/Text                    | Lista de gêneros associados ao filme (ex: Animação, Comédia).        | Formato JSON em texto, necessita extração (parsing). |
| `homepage`                 | object                      | String (URL)                  | URL para a página oficial do filme.                                  | Alta quantidade de valores nulos. |
| `id`                       | object                      | Integer                      | Identificador único do filme no dataset.                             | Chave Primária (PK). Necessita conversão para tipo numérico. |
| `imdb_id`                  | object                      | String                       | ID do filme no site IMDb (ex: 'tt0114709').                          | Pode ser mantido como texto. |
| `original_language`        | object                      | String                       | Código do idioma original do filme (ex: 'en' para inglês).           | Pode ser mantido como texto. |
| `original_title`           | object                      | String                       | Título do filme em seu idioma original.                              | Pode ser mantido como texto. |
| `overview`                 | object                      | String (Text)                 | Breve sinopse ou resumo do filme.                                    | Alguns valores nulos. |
| `popularity`               | object                      | Numeric (Float)               | Métrica de popularidade do filme no TMDB.                            | Necessita conversão para tipo numérico. |
| `poster_path`              | object                      | String (Path/URL)             | Caminho parcial para a imagem do pôster do filme.                    | Alguns valores nulos. |
| `production_companies`     | object                      | JSON/Text                    | Lista de companhias que produziram o filme.                          | Formato JSON em texto, necessita extração (parsing). |
| `production_countries`     | object                      | JSON/Text                    | Lista de países onde o filme foi produzido.                          | Formato JSON em texto, necessita extração (parsing). |
| `release_date`             | object                      | Date                         | Data de lançamento do filme.                                         | Necessita conversão de texto para Data. |
| `revenue`                  | float64                     | Numeric (Integer)             | Receita total de bilheteria do filme em dólares.                     | O tipo está correto, mas valores 0 podem significar "não informado". |
| `runtime`                  | float64                     | Numeric (Float)               | Duração do filme em minutos.                                         | O tipo está correto. |
| `spoken_languages`         | object                      | JSON/Text                    | Lista de idiomas falados no filme.                                   | Formato JSON em texto, necessita extração (parsing). |
| `status`                   | object                      | String                       | Status do filme (ex: 'Released', 'Post Production').                 | Categórico. Pode ser mantido como texto. |
| `tagline`                  | object                      | String                       | Slogan ou frase de efeito do filme.                                  | Alta quantidade de valores nulos. |
| `title`                    | object                      | String                       | Título do filme traduzido ou mais comum.                             | Pode ser mantido como texto. |
| `video`                    | object                      | Boolean                      | Indica se há um vídeo (trailer) associado ao filme.                  | Necessita conversão de texto para Booleano. |
| `vote_average`             | float64                     | Numeric (Float)               | Nota média do filme (geralmente de 0 a 10).                          | O tipo está correto. |
| `vote_count`               | float64                     | Numeric (Integer)             | Número total de votos que o filme recebeu.                           | O tipo está correto, mas deveria ser idealmente um Inteiro. |


---

### Ratings_small.csv

| **Nome da Coluna** | **Tipo de Dado (Original)** | **Tipo de Dado (Ideal)** | **Descrição** | **Observações / Problemas** |
|---------------------|-----------------------------|---------------------------|----------------|------------------------------|
| `userId`           | Integer                     | Integer                   | ID do usuário que fez a avaliação. | Nenhuma observação inicial. |
| `movieId`          | Integer                     | Integer                   | ID do filme que foi avaliado. | Chave estrangeira para `movies_metadata.id`. |
| `rating`           | Float                       | Float                     | A nota que o usuário deu ao filme (ex: 1 a 5). | Nenhuma observação inicial. |
| `timestamp`        | Integer                     | Datetime                  | Data e hora em que a avaliação foi feita. | Formato Unix Timestamp. Precisará de conversão para data/hora. |

---

### Tabela de Créditos (`credits`)

| **Nome da Coluna** | **Tipo de Dado (Original)** | **Tipo de Dado (Ideal)** | **Descrição** | **Observações / Problemas** |
|---------------------|-----------------------------|---------------------------|----------------|------------------------------|
| `cast`             | object                      | JSON/Text                | Lista de atores e seus personagens no filme. | Formato JSON em texto, necessita extração (parsing). |
| `crew`             | object                      | JSON/Text                | Lista da equipe técnica (diretor, roteirista, etc.). | Formato JSON em texto, necessita extração (parsing). |
| `id`               | int64                       | Integer                  | ID do filme para conectar com a tabela `movies_metadata`. | Chave Estrangeira (FK) para `movies_metadata.id`. |

---

## Tabela de Keywords (`keywords`)

| **Nome da Coluna** | **Tipo de Dado (Original)** | **Tipo de Dado (Ideal)** | **Descrição** | **Observações / Problemas** |
|---------------------|-----------------------------|---------------------------|----------------|------------------------------|
| `id`               | int64                       | Integer                  | ID do filme para conectar com a tabela `movies_metadata`. | Chave Estrangeira (FK) para `movies_metadata.id`. |
| `keywords`         | object                      | JSON/Text                | Lista de palavras-chave relacionadas ao enredo do filme. | Formato JSON em texto, necessita extração (parsing). |



