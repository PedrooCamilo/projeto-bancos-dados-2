# 🎬 Sistema de Análise de Filmes - Ponto de Controle 1

[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![Python](https://img.shields.io/badge/Python-3.11-green.svg)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED.svg)](https://www.docker.com/)

Sistema completo de análise de dados de filmes utilizando arquitetura em camadas (RAW, Silver, Gold) com banco de dados MySQL containerizado.

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Requisitos](#-requisitos)
- [Instalação e Uso](#-instalação-e-uso)
- [Arquitetura de Dados](#-arquitetura-de-dados)
- [Documentação](#-documentação)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)

---

## 🎯 Visão Geral

Este projeto implementa um sistema completo de **Data Lake/Lakehouse** para análise de dados de filmes, utilizando a arquitetura Medallion (Bronze/Silver/Gold).

### Funcionalidades Principais

✅ **Camada RAW (Bronze)**
- Armazenamento de dados brutos em CSV
- Análise exploratória completa dos dados
- Dicionário de dados detalhado

✅ **Camada SILVER**
- Modelagem relacional (MER, DER, DLD)
- Pipeline ETL automatizado
- Banco de dados MySQL normalizado
- Dados transformados e limpos

✅ **Infraestrutura Containerizada**
- Docker Compose para orquestração
- Banco de dados MySQL 8.0
- Inicialização automática do schema
- Carga automática de dados via ETL

---

## 📁 Estrutura do Projeto

```
projeto-bancos-dados-2/
│
├── Data Layer/
│   ├── raw/                              # Camada RAW (dados brutos)
│   │   ├── analise_exploratoria.ipynb    # Notebook de análise exploratória
│   │   ├── dicionario_de_dados.md        # Dicionário dos dados brutos
│   │   └── dados_brutos/                 # Arquivos CSV originais
│   │       ├── movies_metadata.csv
│   │       ├── credits.csv
│   │       ├── keywords.csv
│   │       ├── ratings_small.csv
│   │       └── ...
│   │
│   ├── silver/                           # Camada SILVER (dados transformados)
│   │   ├── mer_silver.md                 # Modelo Entidade-Relacionamento
│   │   ├── der_silver.md                 # Diagrama Entidade-Relacionamento
│   │   ├── dld_silver.md                 # Dicionário Lógico de Dados
│   │   ├── ddl_silver.sql                # Scripts DDL (CREATE TABLE, etc)
│   │   ├── schema.sql                    # Schema simplificado
│   │   └── job_etl.py                    # Script de ETL (RAW → SILVER)
│   │
│   └── gold/                             # Camada GOLD (dados agregados)
│       ├── consultas.sql
│       ├── ddl_gold.sql
│       └── ...
│
└── Docker/
    ├── docker-compose.yml                # Orquestração dos containers
    ├── Dockerfile.etl                    # Dockerfile para serviço ETL
    ├── entrypoint.sh                     # Script de inicialização do ETL
    └── requirements.txt                  # Dependências Python
```

---

## 🔧 Requisitos

### Software Necessário

- **Docker Desktop** (Windows/Mac) ou **Docker Engine + Docker Compose** (Linux)
  - Versão mínima: Docker 20.10+
  - Docker Compose: 2.0+
  
- **Git** (para clonar o repositório)

### Recursos de Hardware Recomendados

- RAM: Mínimo 4GB (Recomendado 8GB)
- Espaço em disco: ~2GB

---

## 🚀 Instalação e Uso

### 1. Clone o Repositório

```bash
git clone <url-do-repositório>
cd projeto-bancos-dados-2
```

### 2. Verifique os Dados Brutos

Certifique-se de que os arquivos CSV estão na pasta correta:

```
Data Layer/raw/dados_brutos/
├── movies_metadata.csv
├── credits.csv
├── keywords.csv
└── ratings_small.csv
```

### 3. Inicie o Ambiente com Docker Compose

No diretório `Docker/`, execute:

```bash
# Windows PowerShell
cd Docker
docker-compose up --build

# Linux/Mac
cd Docker
docker-compose up --build
```

### 4. Acompanhe a Execução

O sistema irá automaticamente:

1. ✅ Subir o container MySQL
2. ✅ Criar o banco de dados `movies_db`
3. ✅ Executar o DDL (criar tabelas, views, procedures)
4. ✅ Executar o pipeline ETL
5. ✅ Carregar todos os dados transformados

Você verá logs similares a:

```
🎬 ETL Pipeline - Sistema de Análise de Filmes
════════════════════════════════════════════════════════════════════════════
📡 Conectando ao banco de dados...
✅ Conexão estabelecida com sucesso!

📥 FASE 1: EXTRAÇÃO (Extract)
────────────────────────────────────────────────────────────────────────────
📄 Carregando movies_metadata.csv...
   ✓ 45,466 filmes carregados
...
✅ PIPELINE ETL CONCLUÍDO COM SUCESSO!
```

### 5. Acesse o Banco de Dados

Após a inicialização, conecte-se ao MySQL:

**Credenciais:**
- **Host:** localhost
- **Porta:** 3306
- **Database:** movies_db
- **Usuário:** app_user
- **Senha:** app_password

**Exemplos de Conexão:**

```bash
# Via MySQL CLI
mysql -h 127.0.0.1 -P 3306 -u app_user -p movies_db
# Senha: app_password

# Via Docker
docker exec -it movies_mysql_db mysql -u app_user -p movies_db
```

**Com ferramentas GUI:**
- MySQL Workbench
- DBeaver
- TablePlus
- phpMyAdmin

### 6. Consultas de Exemplo

```sql
-- Total de filmes
SELECT COUNT(*) FROM movies;

-- Filmes mais populares
SELECT title, popularity, vote_average 
FROM movies 
ORDER BY popularity DESC 
LIMIT 10;

-- Estatísticas gerais
CALL sp_database_stats();

-- Filmes com avaliações
SELECT * FROM v_movies_with_stats LIMIT 10;
```

### 7. Parar o Ambiente

```bash
# Parar os containers (preserva os dados)
docker-compose down

# Parar e remover volumes (apaga os dados)
docker-compose down -v
```

---

## 🏗️ Arquitetura de Dados

### Arquitetura Medallion (Bronze → Silver → Gold)

```
┌─────────────────────────────────────────────────────────────┐
│                      CAMADA RAW (Bronze)                    │
│  • Dados brutos em CSV                                      │
│  • Sem transformações                                       │
│  • Análise exploratória                                     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ Pipeline ETL (job_etl.py)
                         │ • Limpeza
                         │ • Transformação
                         │ • Extração de JSON
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    CAMADA SILVER                            │
│  • Banco de dados MySQL                                     │
│  • Dados estruturados e limpos                              │
│  • Tabelas: movies, ratings                                 │
│  • Views, Procedures, Triggers                              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ Agregações e Análises
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                     CAMADA GOLD                             │
│  • Dados agregados e otimizados para BI                     │
│  • Análises avançadas                                       │
│  • (Implementação futura)                                   │
└─────────────────────────────────────────────────────────────┘
```

### Modelo de Dados (Silver Layer)

**Tabelas:**

1. **movies** - Informações detalhadas de filmes
   - Chave Primária: `id`
   - ~45.000 registros
   - Campos: título, sinopse, orçamento, receita, avaliações, gêneros, etc.

2. **ratings** - Avaliações de usuários
   - Chave Primária Composta: `(user_id, movie_id)`
   - Chave Estrangeira: `movie_id → movies.id`
   - ~100.000 registros

**Relacionamento:**
- Um filme pode ter várias avaliações (1:N)
- Cada avaliação pertence a um filme (N:1)

---

## 📚 Documentação

### Camada RAW

| Documento | Descrição | Localização |
|-----------|-----------|-------------|
| **Análise Exploratória** | Notebook Jupyter com análise estatística completa | `Data Layer/raw/analise_exploratoria.ipynb` |
| **Dicionário de Dados** | Descrição detalhada dos dados brutos | `Data Layer/raw/dicionario_de_dados.md` |

### Camada SILVER

| Documento | Descrição | Localização |
|-----------|-----------|-------------|
| **MER** | Modelo Entidade-Relacionamento conceitual | `Data Layer/silver/mer_silver.md` |
| **DER** | Diagrama Entidade-Relacionamento | `Data Layer/silver/der_silver.md` |
| **DLD** | Dicionário Lógico de Dados com tipos e constraints | `Data Layer/silver/dld_silver.md` |
| **DDL** | Scripts SQL de criação das tabelas | `Data Layer/silver/ddl_silver.sql` |
| **Job ETL** | Pipeline de transformação RAW → SILVER | `Data Layer/silver/job_etl.py` |

---

## 🛠️ Tecnologias Utilizadas

### Banco de Dados
- **MySQL 8.0** - SGBD relacional
- **InnoDB** - Storage engine
- **utf8mb4** - Charset para suporte completo Unicode

### Linguagens e Frameworks
- **Python 3.11** - Linguagem principal para ETL
- **Pandas 2.1** - Manipulação de dados
- **SQLAlchemy 2.0** - ORM e conexão com banco
- **SQL** - DDL, DML, Views, Procedures

### Infraestrutura
- **Docker** - Containerização
- **Docker Compose** - Orquestração de containers
- **Bash** - Scripts de inicialização

### Análise de Dados
- **Jupyter Notebook** - Análise exploratória interativa
- **Markdown** - Documentação

---

## 📊 Estatísticas do Dataset

Após a carga completa:

- **Filmes:** ~45.000
- **Avaliações:** ~100.000
- **Usuários únicos:** ~700
- **Período coberto:** 1874 - 2017
- **Gêneros:** 20+ categorias
- **Idiomas:** 50+ idiomas

---

## 🔍 Queries Úteis

### Verificar Status das Tabelas

```sql
-- Contagem de registros
SELECT 
    'movies' AS tabela, 
    COUNT(*) AS total 
FROM movies
UNION ALL
SELECT 
    'ratings' AS tabela, 
    COUNT(*) AS total 
FROM ratings;

-- Tamanho das tabelas
SELECT 
    table_name,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS size_mb
FROM information_schema.tables
WHERE table_schema = 'movies_db';
```

### Análises Rápidas

```sql
-- Top 10 filmes mais avaliados
SELECT 
    m.title, 
    COUNT(r.rating) AS num_ratings,
    AVG(r.rating) AS avg_user_rating,
    m.vote_average AS tmdb_rating
FROM movies m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.title, m.vote_average
ORDER BY num_ratings DESC
LIMIT 10;

-- Filmes por década
SELECT 
    CONCAT(FLOOR(YEAR(release_date) / 10) * 10, 's') AS decade,
    COUNT(*) AS total_movies,
    AVG(vote_average) AS avg_rating,
    AVG(budget) AS avg_budget
FROM movies
WHERE release_date IS NOT NULL
GROUP BY FLOOR(YEAR(release_date) / 10)
ORDER BY decade DESC;
```

---

## 🤝 Contribuindo

Este é um projeto acadêmico. Sugestões e melhorias são bem-vindas!

---

## 📝 Licença

Projeto acadêmico - Disciplina de Bancos de Dados 2

---

## 👨‍💻 Autor

**Projeto Bancos de Dados 2**  
Universidade/Instituição  
Ano: 2024

---

## 🆘 Troubleshooting

### Problema: Container do banco não inicia

```bash
# Verifique os logs
docker-compose logs db

# Remova volumes antigos
docker-compose down -v
docker-compose up --build
```

### Problema: ETL falha

```bash
# Verifique se os arquivos CSV estão no lugar certo
ls -la "Data Layer/raw/dados_brutos/"

# Veja os logs do ETL
docker-compose logs etl
```

### Problema: Porta 3306 já em uso

```bash
# No docker-compose.yml, altere a porta:
ports:
  - "3307:3306"  # Use 3307 no host ao invés de 3306
```

---

## 📞 Suporte

Para dúvidas e problemas:
- Consulte a documentação em `Data Layer/silver/`
- Verifique os logs: `docker-compose logs`
- Revise a análise exploratória: `analise_exploratoria.ipynb`

---

**🎬 Bom uso do sistema!**
