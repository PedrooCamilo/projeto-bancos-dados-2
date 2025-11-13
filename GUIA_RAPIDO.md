# 🚀 Guia Rápido - Ponto de Controle 1

## ⚡ Início Rápido (Quick Start)

### 1️⃣ Pré-requisitos
- Docker Desktop instalado e rodando
- 4GB RAM disponível
- 2GB espaço em disco

### 2️⃣ Executar o Projeto

```powershell
# No diretório do projeto
cd Docker
docker-compose up --build
```

### 3️⃣ Aguarde a Conclusão

Você verá mensagens como:
```
✅ Conexão estabelecida com sucesso!
📥 FASE 1: EXTRAÇÃO (Extract)
🔄 FASE 2: TRANSFORMAÇÃO (Transform)
📤 FASE 3: CARGA (Load)
✅ PIPELINE ETL CONCLUÍDO COM SUCESSO!
```

### 4️⃣ Conectar ao Banco

**Credenciais:**
- Host: `localhost`
- Porta: `3306`
- Database: `movies_db`
- User: `app_user`
- Password: `app_password`

**Via CLI:**
```powershell
docker exec -it movies_mysql_db mysql -u app_user -p movies_db
# Senha: app_password
```

### 5️⃣ Testar

```sql
-- Ver total de filmes
SELECT COUNT(*) FROM movies;

-- Ver filmes mais populares
SELECT title, popularity FROM movies ORDER BY popularity DESC LIMIT 5;

-- Ver estatísticas
CALL sp_database_stats();
```

---

## 📋 Checklist do Ponto de Controle 1

### ✅ Camada RAW
- [x] Dados brutos em `Data Layer/raw/dados_brutos/`
- [x] Análise exploratória completa em `analise_exploratoria.ipynb`
- [x] Dicionário de dados em `dicionario_de_dados.md`

### ✅ Camada SILVER
- [x] MER (Modelo Entidade-Relacionamento) em `mer_silver.md`
- [x] DER (Diagrama Entidade-Relacionamento) em `der_silver.md`
- [x] DLD (Dicionário Lógico de Dados) em `dld_silver.md`
- [x] DDL completo em `ddl_silver.sql`
- [x] Schema em `schema.sql`
- [x] Job ETL em `job_etl.py`

### ✅ Infraestrutura
- [x] Docker Compose configurado
- [x] Banco de dados MySQL containerizado
- [x] Script de inicialização automática
- [x] ETL executado automaticamente no `docker-compose up`

### ✅ Documentação
- [x] README.md completo
- [x] Guia rápido
- [x] Estrutura de pastas organizada

---

## 🎯 Entregas do PC1

### 📁 Estrutura de Pastas
```
✓ Data Layer/
  ✓ raw/
    ✓ dados_brutos/
    ✓ analise_exploratoria.ipynb
    ✓ dicionario_de_dados.md
  ✓ silver/
    ✓ mer_silver.md
    ✓ der_silver.md
    ✓ dld_silver.md
    ✓ ddl_silver.sql
    ✓ schema.sql
    ✓ job_etl.py
✓ Docker/
  ✓ docker-compose.yml
  ✓ Dockerfile.etl
```

### 📊 Conteúdo Entregue

1. **Análise Exploratória Completa** ✅
   - Estatísticas descritivas
   - Distribuição temporal
   - Top filmes por orçamento/receita
   - Análise de gêneros
   - Análise de avaliações
   - Qualidade dos dados

2. **Modelagem (Silver)** ✅
   - MER conceitual
   - DER com cardinalidades
   - DLD com tipos e constraints
   - DDL executável
   - Schema simplificado

3. **Job ETL** ✅
   - Extração de CSVs
   - Transformação completa
   - Limpeza de dados
   - Carga no banco

4. **Lakehouse Populada** ✅
   - Banco MySQL containerizado
   - Dados carregados automaticamente
   - ~45.000 filmes
   - ~100.000 avaliações

5. **Docker Compose** ✅
   - Banco containerizado
   - ETL automatizado
   - Execução com `docker-compose up`

---

## 🔧 Comandos Úteis

### Gerenciar Containers

```powershell
# Iniciar
docker-compose up -d

# Parar
docker-compose down

# Ver logs
docker-compose logs -f

# Logs apenas do banco
docker-compose logs -f db

# Logs apenas do ETL
docker-compose logs etl

# Reiniciar tudo do zero
docker-compose down -v
docker-compose up --build
```

### Acessar Banco

```powershell
# MySQL CLI
docker exec -it movies_mysql_db mysql -u app_user -p movies_db

# Root access
docker exec -it movies_mysql_db mysql -u root -p
# Senha: root_password

# Bash no container
docker exec -it movies_mysql_db bash
```

### Verificações

```sql
-- Verificar tabelas
SHOW TABLES;

-- Ver estrutura
DESCRIBE movies;
DESCRIBE ratings;

-- Contagem
SELECT COUNT(*) FROM movies;
SELECT COUNT(*) FROM ratings;

-- Views disponíveis
SELECT TABLE_NAME 
FROM information_schema.VIEWS 
WHERE TABLE_SCHEMA = 'movies_db';

-- Procedures disponíveis
SHOW PROCEDURE STATUS WHERE Db = 'movies_db';
```

---

## ❓ FAQ

**P: O ETL demora quanto tempo?**  
R: Entre 30 segundos a 2 minutos, dependendo do hardware.

**P: Preciso rodar o ETL toda vez?**  
R: Não. Os dados ficam persistidos no volume Docker. Só rode novamente se quiser resetar.

**P: Como resetar o banco?**  
R: `docker-compose down -v` e depois `docker-compose up --build`

**P: Posso usar outro cliente MySQL?**  
R: Sim! MySQL Workbench, DBeaver, TablePlus, etc. Use as credenciais fornecidas.

**P: Onde estão os logs do ETL?**  
R: `docker-compose logs etl`

---

## 📞 Problemas Comuns

### Porta 3306 ocupada
```yaml
# Em docker-compose.yml, mude para:
ports:
  - "3307:3306"
```

### ETL falha
```powershell
# Verifique os CSVs
dir "Data Layer\raw\dados_brutos"

# Veja o erro
docker-compose logs etl
```

### Banco não inicia
```powershell
# Remova volumes antigos
docker-compose down -v
docker volume prune
docker-compose up --build
```

---

**✅ Projeto pronto para apresentação do PC1!**
