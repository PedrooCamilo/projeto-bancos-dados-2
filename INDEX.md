# 📑 ÍNDICE DO PROJETO - Navegação Rápida

Este arquivo serve como índice para facilitar a navegação em todo o projeto.

---

## 📂 ESTRUTURA COMPLETA

```
projeto-bancos-dados-2/
│
├── 📖 DOCUMENTAÇÃO PRINCIPAL
│   ├── README.md                     ⭐ Documentação completa do projeto
│   ├── SUMARIO_EXECUTIVO.md          📊 Resumo executivo (para professores)
│   ├── GUIA_RAPIDO.md               ⚡ Quick start
│   ├── CHECKLIST_APRESENTACAO.md    ✅ Checklist para apresentação
│   ├── NOTAS_APRESENTACAO.md        📝 Roteiro de apresentação
│   ├── queries_exemplo.sql          🔍 Queries prontas para demonstração
│   └── start.ps1                    🚀 Script de inicialização (Windows)
│
├── 📊 DATA LAYER
│   │
│   ├── 🥉 RAW (Bronze Layer - Dados Brutos)
│   │   ├── analise_exploratoria.ipynb    ⭐ Análise completa dos dados
│   │   ├── dicionario_de_dados.md         📚 Dicionário dos dados brutos
│   │   └── dados_brutos/                  💾 Arquivos CSV originais
│   │       ├── movies_metadata.csv
│   │       ├── credits.csv
│   │       ├── keywords.csv
│   │       ├── ratings_small.csv
│   │       ├── ratings.csv
│   │       ├── links.csv
│   │       └── links_small.csv
│   │
│   ├── 🥈 SILVER (Dados Transformados)
│   │   ├── mer_silver.md             ⭐ Modelo Entidade-Relacionamento
│   │   ├── der_silver.md             ⭐ Diagrama ER
│   │   ├── dld_silver.md             ⭐ Dicionário Lógico de Dados
│   │   ├── ddl_silver.sql            ⭐ DDL completo (300+ linhas)
│   │   ├── schema.sql                 📋 Schema simplificado
│   │   ├── job_etl.py                ⭐ Pipeline ETL (400+ linhas)
│   │   └── analise.ipynb              📊 Análises adicionais
│   │
│   └── 🥇 GOLD (Dados Agregados - futuro)
│       ├── consultas.sql
│       ├── ddl_gold.sql
│       ├── der_gold.md
│       ├── dld_gold.md
│       └── mer_gold.md
│
└── 🐳 DOCKER (Infraestrutura)
    ├── docker-compose.yml            ⭐ Orquestração dos serviços
    ├── Dockerfile.etl                 🔨 Container ETL
    ├── entrypoint.sh                  🚪 Script de entrada
    └── requirements.txt               📦 Dependências Python
```

---

## 🎯 GUIAS DE USO RÁPIDO

### Para EXECUTAR o projeto:
1. 📄 `GUIA_RAPIDO.md` - Início rápido
2. 🚀 `start.ps1` - Script interativo (Windows)
3. 📖 `README.md` - Seção "Instalação e Uso"

### Para APRESENTAR o projeto:
1. ✅ `CHECKLIST_APRESENTACAO.md` - Lista do que mostrar
2. 📝 `NOTAS_APRESENTACAO.md` - Roteiro detalhado
3. 🔍 `queries_exemplo.sql` - Consultas prontas

### Para ENTENDER o projeto:
1. 📊 `SUMARIO_EXECUTIVO.md` - Visão geral completa
2. 📖 `README.md` - Documentação técnica
3. 🗺️ `Data Layer/silver/mer_silver.md` - Modelo de dados

---

## 📚 DOCUMENTOS POR CATEGORIA

### 🎓 MODELAGEM (Camada Silver)
1. **MER** - `Data Layer/silver/mer_silver.md`
   - Modelo conceitual
   - Entidades e atributos
   - Relacionamentos
   - Regras de negócio

2. **DER** - `Data Layer/silver/der_silver.md`
   - Diagramas detalhados
   - Cardinalidades
   - Constraints
   - Índices

3. **DLD** - `Data Layer/silver/dld_silver.md`
   - Dicionário completo
   - Tipos de dados
   - Validações
   - Transformações

### 🔨 CÓDIGO E SCRIPTS

1. **ETL** - `Data Layer/silver/job_etl.py`
   - Pipeline completo
   - Extract, Transform, Load
   - 400+ linhas

2. **DDL** - `Data Layer/silver/ddl_silver.sql`
   - Criação de tabelas
   - Views, Procedures, Triggers
   - 300+ linhas

3. **Schema** - `Data Layer/silver/schema.sql`
   - Versão simplificada do DDL
   - Apenas estrutura básica

### 📊 ANÁLISES

1. **Exploratória RAW** - `Data Layer/raw/analise_exploratoria.ipynb`
   - 8 seções de análise
   - Estatísticas descritivas
   - Transformações

2. **Silver** - `Data Layer/silver/analise.ipynb`
   - Análises adicionais
   - (Em desenvolvimento)

### 🐳 INFRAESTRUTURA

1. **Compose** - `Docker/docker-compose.yml`
   - Orquestração
   - 2 serviços (db, etl)

2. **Dockerfile** - `Docker/Dockerfile.etl`
   - Container ETL
   - Python 3.11

3. **Entrypoint** - `Docker/entrypoint.sh`
   - Inicialização
   - Healthcheck

---

## 🎯 ARQUIVOS PRINCIPAIS (ESTRELAS ⭐)

Para o PC1, os arquivos mais importantes são:

### Camada RAW
- ⭐ `Data Layer/raw/analise_exploratoria.ipynb`
- ⭐ `Data Layer/raw/dicionario_de_dados.md`

### Camada SILVER
- ⭐ `Data Layer/silver/mer_silver.md`
- ⭐ `Data Layer/silver/der_silver.md`
- ⭐ `Data Layer/silver/dld_silver.md`
- ⭐ `Data Layer/silver/ddl_silver.sql`
- ⭐ `Data Layer/silver/job_etl.py`

### Infraestrutura
- ⭐ `Docker/docker-compose.yml`

### Documentação
- ⭐ `README.md`
- ⭐ `SUMARIO_EXECUTIVO.md`

---

## 🔍 BUSCA RÁPIDA

### "Quero ver a modelagem conceitual"
→ `Data Layer/silver/mer_silver.md`

### "Quero ver os diagramas"
→ `Data Layer/silver/der_silver.md`

### "Quero ver o dicionário de dados"
→ RAW: `Data Layer/raw/dicionario_de_dados.md`  
→ SILVER: `Data Layer/silver/dld_silver.md`

### "Quero ver o código SQL"
→ Completo: `Data Layer/silver/ddl_silver.sql`  
→ Simples: `Data Layer/silver/schema.sql`

### "Quero ver o código Python"
→ ETL: `Data Layer/silver/job_etl.py`  
→ Análise: `Data Layer/raw/analise_exploratoria.ipynb`

### "Quero ver a análise dos dados"
→ `Data Layer/raw/analise_exploratoria.ipynb`

### "Quero executar o projeto"
→ Windows: Execute `start.ps1`  
→ Manual: Leia `GUIA_RAPIDO.md`  
→ Detalhado: Leia `README.md`

### "Quero preparar a apresentação"
→ `CHECKLIST_APRESENTACAO.md`  
→ `NOTAS_APRESENTACAO.md`

### "Quero queries prontas"
→ `queries_exemplo.sql`

---

## 📊 ESTATÍSTICAS DO PROJETO

### Arquivos
- **Documentação:** 8 arquivos Markdown
- **Código Python:** 2 arquivos (.py + .ipynb)
- **SQL:** 3 arquivos
- **Docker:** 4 arquivos
- **Scripts:** 1 PowerShell

### Linhas de Código
- **Python:** ~400 linhas (job_etl.py)
- **SQL:** ~300 linhas (ddl_silver.sql)
- **PowerShell:** ~150 linhas
- **Documentação:** ~1500 linhas

### Objetos de Banco
- **Tabelas:** 2
- **Views:** 3
- **Procedures:** 2
- **Triggers:** 1
- **Índices:** 9

---

## 🆘 AJUDA RÁPIDA

### Problema: "Não sei por onde começar"
→ Leia: `GUIA_RAPIDO.md`

### Problema: "Como executar?"
→ Execute: `start.ps1` (Windows)  
→ Ou: `cd Docker && docker-compose up --build`

### Problema: "O que mostrar na apresentação?"
→ Leia: `CHECKLIST_APRESENTACAO.md`

### Problema: "Preciso entender o modelo de dados"
→ Leia em ordem:
1. `Data Layer/silver/mer_silver.md`
2. `Data Layer/silver/der_silver.md`
3. `Data Layer/silver/dld_silver.md`

### Problema: "Preciso de queries prontas"
→ Abra: `queries_exemplo.sql`

---

## ✅ CHECKLIST DE ENTREGA

Use isto para verificar se tem tudo:

- [ ] `README.md` existe
- [ ] `Data Layer/raw/analise_exploratoria.ipynb` existe
- [ ] `Data Layer/raw/dicionario_de_dados.md` existe
- [ ] `Data Layer/raw/dados_brutos/` contém os CSVs
- [ ] `Data Layer/silver/mer_silver.md` existe
- [ ] `Data Layer/silver/der_silver.md` existe
- [ ] `Data Layer/silver/dld_silver.md` existe
- [ ] `Data Layer/silver/ddl_silver.sql` existe
- [ ] `Data Layer/silver/schema.sql` existe
- [ ] `Data Layer/silver/job_etl.py` existe
- [ ] `Docker/docker-compose.yml` existe
- [ ] `Docker/Dockerfile.etl` existe
- [ ] `Docker/entrypoint.sh` existe
- [ ] `Docker/requirements.txt` existe
- [ ] Executei `docker-compose up --build` com sucesso
- [ ] Conectei no banco MySQL
- [ ] Executei algumas queries de teste

---

## 📞 ORDEM DE LEITURA SUGERIDA

Para alguém que está conhecendo o projeto pela primeira vez:

1. 📄 `SUMARIO_EXECUTIVO.md` - Visão geral
2. 📖 `README.md` - Detalhes técnicos
3. 📊 `Data Layer/raw/analise_exploratoria.ipynb` - Entender os dados
4. 🗺️ `Data Layer/silver/mer_silver.md` - Modelo conceitual
5. 📐 `Data Layer/silver/der_silver.md` - Diagrama
6. 📚 `Data Layer/silver/dld_silver.md` - Dicionário
7. 🔨 `Data Layer/silver/ddl_silver.sql` - Implementação SQL
8. 🔄 `Data Layer/silver/job_etl.py` - Pipeline ETL
9. 🐳 `Docker/docker-compose.yml` - Infraestrutura
10. ⚡ `GUIA_RAPIDO.md` - Como executar

---

**Última atualização:** Novembro 2024  
**Status:** ✅ Projeto Completo
