# ✅ CHECKLIST DE APRESENTAÇÃO - PC1

Use este checklist durante sua apresentação para garantir que mostrou tudo!

---

## 📋 ANTES DA APRESENTAÇÃO

- [ ] Docker Desktop está rodando
- [ ] Repositório está atualizado
- [ ] Arquivos CSV estão em `Data Layer/raw/dados_brutos/`
- [ ] Testei o `docker-compose up` pelo menos uma vez
- [ ] Tenho um cliente MySQL pronto (Workbench/DBeaver/CLI)
- [ ] Li o `NOTAS_APRESENTACAO.md`

---

## 🎯 DURANTE A APRESENTAÇÃO

### 1. INTRODUÇÃO (2 min)
- [ ] Apresentei o objetivo do projeto
- [ ] Expliquei a arquitetura Medallion (RAW → SILVER → GOLD)
- [ ] Mostrei a estrutura de pastas

### 2. CAMADA RAW (3 min)
- [ ] Mostrei os arquivos CSV em `dados_brutos/`
- [ ] Abri o `analise_exploratoria.ipynb`
- [ ] Destaquei as 8 seções de análise:
  - [ ] Estatísticas descritivas
  - [ ] Distribuição temporal
  - [ ] Top filmes (orçamento/receita)
  - [ ] Análise de gêneros
  - [ ] Estatísticas de avaliações
  - [ ] Filmes mais avaliados
  - [ ] Qualidade dos dados
- [ ] Mostrei o `dicionario_de_dados.md`

### 3. MODELAGEM - CAMADA SILVER (5 min)
- [ ] Abri e expliquei o `mer_silver.md`:
  - [ ] Entidades (MOVIES, RATINGS)
  - [ ] Atributos principais
  - [ ] Relacionamento 1:N
  - [ ] Regras de negócio
- [ ] Abri e expliquei o `der_silver.md`:
  - [ ] Diagrama principal
  - [ ] Cardinalidades
  - [ ] Chaves (PKs, FKs)
  - [ ] Constraints
- [ ] Abri e expliquei o `dld_silver.md`:
  - [ ] Dicionário completo (23 atributos)
  - [ ] Tipos de dados
  - [ ] Constraints
  - [ ] Transformações aplicadas

### 4. DDL E ESTRUTURAS (3 min)
- [ ] Abri o `ddl_silver.sql`
- [ ] Mostrei:
  - [ ] Criação das 2 tabelas
  - [ ] 9 índices
  - [ ] 3 views (v_movies_with_stats, etc)
  - [ ] 2 procedures (sp_truncate_tables, sp_database_stats)
  - [ ] 1 trigger (trg_movies_before_insert)
- [ ] Abri o `schema.sql` (versão simplificada)

### 5. JOB ETL (4 min)
- [ ] Abri o `job_etl.py`
- [ ] Expliquei a classe `ETLPipeline`
- [ ] Mostrei as 3 fases:
  - [ ] EXTRACT - Leitura dos CSVs
  - [ ] TRANSFORM - Limpeza e transformações
  - [ ] LOAD - Carga no banco
- [ ] Destaquei:
  - [ ] Extração de JSON
  - [ ] Validação de integridade
  - [ ] Performance (chunks)
  - [ ] Logs detalhados

### 6. INFRAESTRUTURA DOCKER (3 min)
- [ ] Abri o `docker-compose.yml`
- [ ] Expliquei os 2 serviços:
  - [ ] db (MySQL 8.0)
  - [ ] etl (Python 3.11)
- [ ] Mostrei:
  - [ ] Healthcheck
  - [ ] Volumes
  - [ ] Network
  - [ ] Dependências
- [ ] Mostrei o `Dockerfile.etl`
- [ ] Mostrei o `entrypoint.sh`

### 7. DEMONSTRAÇÃO AO VIVO (8 min)

#### 7.1 Executar o Sistema
- [ ] Abri terminal no diretório `Docker/`
- [ ] Executei: `docker-compose up --build`
- [ ] Mostrei os logs coloridos do ETL:
  - [ ] Conexão com banco
  - [ ] Fase 1: EXTRAÇÃO
  - [ ] Fase 2: TRANSFORMAÇÃO
  - [ ] Fase 3: CARGA
  - [ ] Mensagem de sucesso
  - [ ] Estatísticas finais

#### 7.2 Conectar ao Banco
- [ ] Conectei ao MySQL:
  ```bash
  docker exec -it movies_mysql_db mysql -u app_user -p movies_db
  ```
- [ ] Ou usei cliente GUI (Workbench/DBeaver)

#### 7.3 Consultas de Demonstração
- [ ] Mostrei tabelas:
  ```sql
  SHOW TABLES;
  ```
- [ ] Contei registros:
  ```sql
  SELECT COUNT(*) FROM movies;
  SELECT COUNT(*) FROM ratings;
  ```
- [ ] Executei procedure:
  ```sql
  CALL sp_database_stats();
  ```
- [ ] Consultei view:
  ```sql
  SELECT * FROM v_movies_with_stats LIMIT 5;
  ```
- [ ] Fiz consulta analítica:
  ```sql
  SELECT title, user_ratings_count, user_avg_rating 
  FROM v_movies_with_stats 
  WHERE user_ratings_count > 0
  ORDER BY user_ratings_count DESC 
  LIMIT 10;
  ```

### 8. DOCUMENTAÇÃO (2 min)
- [ ] Abri o `README.md`
- [ ] Destaquei seções importantes:
  - [ ] Instalação e uso
  - [ ] Arquitetura
  - [ ] Documentação completa
- [ ] Mostrei o `GUIA_RAPIDO.md`
- [ ] Mencionei o `SUMARIO_EXECUTIVO.md`

---

## 📊 NÚMEROS PARA MENCIONAR

- [ ] ~45.000 filmes processados
- [ ] ~100.000 avaliações
- [ ] ~700 usuários únicos
- [ ] Período: 1874-2017
- [ ] 400+ linhas de Python (ETL)
- [ ] 300+ linhas de SQL (DDL)
- [ ] 1500+ linhas de documentação
- [ ] 2 tabelas, 3 views, 2 procedures, 1 trigger
- [ ] 9 índices otimizados
- [ ] Tempo de execução: 30s-2min

---

## 💡 PONTOS FORTES PARA DESTACAR

- [ ] **Automação completa**: Um comando roda tudo
- [ ] **Documentação profissional**: MER, DER, DLD completos
- [ ] **Código limpo**: Bem estruturado e comentado
- [ ] **Performance**: Chunks, índices, views
- [ ] **DevOps**: Docker, healthchecks, orquestração
- [ ] **Análise completa**: 8 seções de estatísticas
- [ ] **DDL além do básico**: Views, procedures, triggers
- [ ] **ETL robusto**: Validação, transformações complexas

---

## ❓ PERGUNTAS COMUNS E RESPOSTAS

### "Por que desnormalizou genres, cast, etc?"
- [ ] Respondi: Decisão de design para simplicidade inicial. Documentado como evolução futura. Facilita consultas simples.

### "Como garantiu integridade referencial?"
- [ ] Respondi: FK em ratings.movie_id, validação no ETL, ON DELETE NO ACTION.

### "Por que chave composta em ratings?"
- [ ] Respondi: (user_id, movie_id) garante que um usuário avalie cada filme apenas uma vez.

### "O sistema escala?"
- [ ] Respondi: Sim. Usa chunks, índices, e arquitetura permite processamento distribuído futuro.

### "Como validou os dados?"
- [ ] Respondi: Análise exploratória completa, remoção de inválidos, constraints no banco.

---

## 🎬 ENCERRAMENTO

- [ ] Resumo do que foi entregue:
  - [ ] Estrutura de pastas completa
  - [ ] Análise exploratória (RAW)
  - [ ] Modelagem completa (MER, DER, DLD)
  - [ ] DDL com views, procedures, triggers
  - [ ] Job ETL automatizado
  - [ ] Lakehouse containerizada e populada
  - [ ] Docker Compose funcional
  - [ ] Documentação completa
- [ ] Destaquei que tudo funciona com um comando
- [ ] Agradeci a atenção

---

## 📝 APÓS A APRESENTAÇÃO

- [ ] Parei os containers: `docker-compose down`
- [ ] Salvei feedback recebido
- [ ] Anotei sugestões de melhoria
- [ ] Comemorei! 🎉

---

## ⏱️ TEMPO SUGERIDO

| Seção | Tempo |
|-------|-------|
| Introdução | 2 min |
| Camada RAW | 3 min |
| Modelagem SILVER | 5 min |
| DDL | 3 min |
| ETL | 4 min |
| Docker | 3 min |
| **Demonstração ao vivo** | **8 min** |
| Documentação | 2 min |
| **TOTAL** | **30 min** |

---

**BOA SORTE! 🚀🎬**

Lembre-se: Você tem um projeto completo, funcional e bem documentado. Mostre com confiança! 💪
