# Dicionário de Mnemônicos e Nomenclatura (GOLD Layer)

## 📖 Guia de Nomenclatura do Data Warehouse

---

## 🔑 CONVENÇÕES DE CHAVES

### Chaves Substitutas (Surrogate Keys - Primary Keys)
**Padrão**: `<prefixo>_srk`  
**Tipo**: SERIAL (auto-incremento)  
**Descrição**: Chaves técnicas internas do data warehouse

| Mnemônico | Significado           | Exemplo      | Tabela        |
|-----------|-----------------------|--------------|---------------|
| tmp_srk   | Tempo Surrogate Key   | 1, 2, 3...   | dim_tempo     |
| mov_srk   | Movie Surrogate Key   | 1, 2, 3...   | dim_filme     |
| gnr_srk   | Gênero Surrogate Key  | 1, 2, 3...   | dim_genero    |
| cmp_srk   | Companhia Surrogate Key | 1, 2, 3... | dim_companhia |
| geo_srk   | Geografia Surrogate Key | 1, 2, 3... | dim_geografia |
| dir_srk   | Diretor Surrogate Key | 1, 2, 3...   | dim_diretor   |
| act_srk   | Ator Surrogate Key    | 1, 2, 3...   | dim_ator      |
| fto_srk   | Fato Surrogate Key    | 1, 2, 3...   | fto_filme     |

### Chaves Estrangeiras (Foreign Keys)
**Padrão**: `<prefixo>_fky`  
**Tipo**: INTEGER  
**Descrição**: Referências às chaves primárias das dimensões

| Mnemônico | Significado           | Referencia   | Tabela    |
|-----------|-----------------------|--------------|-----------|
| mov_fky   | Movie Foreign Key     | dim_filme    | fto_filme |
| tmp_fky   | Tempo Foreign Key     | dim_tempo    | fto_filme |
| gnr_fky   | Gênero Foreign Key    | dim_genero   | fto_filme |
| cmp_fky   | Companhia Foreign Key | dim_companhia| fto_filme |
| geo_fky   | Geografia Foreign Key | dim_geografia| fto_filme |
| dir_fky   | Diretor Foreign Key   | dim_diretor  | fto_filme |
| act_fky   | Ator Foreign Key      | dim_ator     | fto_filme |

### Chaves Naturais (Natural Keys)
**Padrão**: `<prefixo>_nky`  
**Tipo**: INTEGER/VARCHAR  
**Descrição**: Identificadores originais dos dados de origem

| Mnemônico | Significado          | Exemplo | Tabela    |
|-----------|----------------------|---------|-----------|
| mov_nky   | Movie Natural Key    | 19995   | dim_filme |

---

## 📊 PREFIXOS DE ENTIDADES

### Dimensões
| Prefixo | Entidade      | Descrição                        |
|---------|---------------|----------------------------------|
| tmp_    | Tempo         | Atributos de data/tempo          |
| mov_    | Movie/Filme   | Atributos de filmes              |
| gnr_    | Gênero        | Atributos de gênero              |
| cmp_    | Companhia     | Atributos de companhia produtora |
| geo_    | Geografia     | Atributos geográficos            |
| dir_    | Diretor       | Atributos de diretores           |
| act_    | Ator          | Atributos de atores              |

### Fato
| Prefixo | Entidade | Descrição                |
|---------|----------|--------------------------|
| fto_    | Fato     | Tabela fato central      |

---

## 📝 PREFIXOS DE TIPOS DE DADOS

### Valores Numéricos
| Prefixo | Significado | Tipo de Dado  | Exemplos                   |
|---------|-------------|---------------|----------------------------|
| vlr_    | Valor       | BIGINT/NUMERIC| vlr_orcamento, vlr_receita |
| pct_    | Percentual  | NUMERIC       | pct_roi                    |
| med_    | Média       | NUMERIC       | med_avaliacao, med_popularidade |
| qtd_    | Quantidade  | INTEGER       | qtd_votos, qtd_elenco      |
| dur_    | Duração     | INTEGER       | dur_minutos                |
| num_    | Número      | INTEGER       | num_ordem (se usado)       |

### Valores Textuais
| Prefixo | Significado | Tipo de Dado  | Exemplos                    |
|---------|-------------|---------------|-----------------------------|
| txt_    | Texto       | TEXT          | txt_sinopse, txt_tagline    |
| nom_    | Nome        | VARCHAR       | nom_dia_semana              |
| cod_    | Código      | VARCHAR       | cod_idioma, cod_imdb        |
| cat_    | Categoria   | VARCHAR       | cat_status, cat_orcamento   |

### Valores Especiais
| Prefixo | Significado | Tipo de Dado  | Exemplos                    |
|---------|-------------|---------------|-----------------------------|
| dta_    | Data        | DATE          | dta_completa                |
| url_    | URL         | TEXT          | url_homepage, url_poster    |
| flg_    | Flag        | BOOLEAN       | flg_adulto, flg_blockbuster |

---

## 🎯 NOMENCLATURA POR DIMENSÃO

### dim_tempo
| Coluna            | Descrição                     | Tipo       |
|-------------------|-------------------------------|------------|
| tmp_srk           | Surrogate key                 | SERIAL     |
| dta_completa      | Data completa                 | DATE       |
| ano_lancamento    | Ano de lançamento             | INTEGER    |
| mes_numero        | Número do mês (1-12)          | INTEGER    |
| mes_nome          | Nome do mês                   | VARCHAR    |
| mes_abrev         | Abreviação do mês             | VARCHAR    |
| dia_numero        | Dia do mês (1-31)             | INTEGER    |
| dia_semana        | Dia da semana (1-7)           | INTEGER    |
| nom_dia_semana    | Nome do dia da semana         | VARCHAR    |
| tri_numero        | Número do trimestre (1-4)     | INTEGER    |
| tri_nome          | Nome do trimestre (Q1-Q4)     | VARCHAR    |
| sem_numero        | Número da semana no ano       | INTEGER    |
| dec_inicio        | Década inicial (1990, 2000)   | INTEGER    |
| flg_feriado       | Flag indicando feriado        | BOOLEAN    |
| flg_fim_semana    | Flag indicando fim de semana  | BOOLEAN    |

### dim_filme
| Coluna               | Descrição                    | Tipo       |
|----------------------|------------------------------|------------|
| mov_srk              | Surrogate key                | SERIAL     |
| mov_nky              | Natural key (ID original)    | INTEGER    |
| mov_titulo           | Título do filme              | VARCHAR    |
| mov_titulo_original  | Título original              | VARCHAR    |
| cod_idioma           | Código do idioma (ISO 639-1) | VARCHAR    |
| cod_imdb             | Código IMDb                  | VARCHAR    |
| txt_sinopse          | Sinopse do filme             | TEXT       |
| txt_tagline          | Slogan/frase do filme        | TEXT       |
| url_homepage         | URL do site oficial          | TEXT       |
| url_poster           | URL do poster                | TEXT       |
| cat_status           | Categoria de status          | VARCHAR    |
| cat_orcamento        | Categoria de orçamento       | VARCHAR    |
| cat_receita          | Categoria de receita         | VARCHAR    |
| cat_duracao          | Categoria de duração         | VARCHAR    |

### dim_genero
| Coluna         | Descrição                     | Tipo       |
|----------------|-------------------------------|------------|
| gnr_srk        | Surrogate key                 | SERIAL     |
| gnr_nome       | Nome do gênero                | VARCHAR    |
| gnr_descricao  | Descrição detalhada           | TEXT       |
| gnr_categoria  | Categoria de agrupamento      | VARCHAR    |

### dim_companhia
| Coluna    | Descrição                      | Tipo       |
|-----------|--------------------------------|------------|
| cmp_srk   | Surrogate key                  | SERIAL     |
| cmp_nome  | Nome da companhia              | VARCHAR    |
| cmp_tipo  | Tipo (Production, Distribution)| VARCHAR    |

### dim_geografia
| Coluna          | Descrição                | Tipo       |
|-----------------|--------------------------|------------|
| geo_srk         | Surrogate key            | SERIAL     |
| geo_pais        | Nome do país             | VARCHAR    |
| geo_codigo_iso  | Código ISO do país       | VARCHAR    |
| geo_continente  | Continente               | VARCHAR    |
| geo_regiao      | Região geográfica        | VARCHAR    |

### dim_diretor
| Coluna            | Descrição            | Tipo       |
|-------------------|----------------------|------------|
| dir_srk           | Surrogate key        | SERIAL     |
| dir_nome          | Nome do diretor      | VARCHAR    |
| dir_nome_completo | Nome completo        | VARCHAR    |

### dim_ator
| Coluna            | Descrição            | Tipo       |
|-------------------|----------------------|------------|
| act_srk           | Surrogate key        | SERIAL     |
| act_nome          | Nome do ator         | VARCHAR    |
| act_nome_completo | Nome completo        | VARCHAR    |

### fto_filme
| Coluna           | Descrição                    | Tipo         |
|------------------|------------------------------|--------------|
| fto_srk          | Surrogate key                | SERIAL       |
| mov_fky          | FK para dim_filme            | INTEGER      |
| tmp_fky          | FK para dim_tempo            | INTEGER      |
| gnr_fky          | FK para dim_genero           | INTEGER      |
| cmp_fky          | FK para dim_companhia        | INTEGER      |
| geo_fky          | FK para dim_geografia        | INTEGER      |
| dir_fky          | FK para dim_diretor          | INTEGER      |
| act_fky          | FK para dim_ator             | INTEGER      |
| vlr_orcamento    | Valor do orçamento           | BIGINT       |
| vlr_receita      | Valor da receita             | BIGINT       |
| vlr_lucro        | Valor do lucro               | BIGINT       |
| pct_roi          | Percentual de ROI            | NUMERIC      |
| med_avaliacao    | Média de avaliação           | NUMERIC      |
| qtd_votos        | Quantidade de votos          | INTEGER      |
| med_popularidade | Média de popularidade        | NUMERIC      |
| dur_minutos      | Duração em minutos           | INTEGER      |
| qtd_elenco       | Quantidade de elenco         | INTEGER      |
| qtd_equipe       | Quantidade de equipe         | INTEGER      |
| flg_adulto       | Flag de conteúdo adulto      | BOOLEAN      |
| flg_blockbuster  | Flag de blockbuster          | BOOLEAN      |

---

**Última Atualização**: 2025-11-23
