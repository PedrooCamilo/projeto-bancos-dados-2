# 📐 MER - Modelo Entidade-Relacionamento (Camada Silver)

## Descrição Geral
Este documento descreve o Modelo Entidade-Relacionamento (MER) para a camada Silver do projeto de análise de filmes. A camada Silver representa os dados transformados e estruturados, prontos para análises e consultas eficientes.

---

## 🎯 Entidades

### 1. MOVIES (Filmes)
**Descrição:** Armazena informações detalhadas sobre filmes.

**Atributos:**
- **id** (PK): Identificador único do filme
- title: Título do filme
- overview: Sinopse/descrição do filme
- release_date: Data de lançamento
- budget: Orçamento de produção
- revenue: Receita de bilheteria
- runtime: Duração em minutos
- popularity: Métrica de popularidade
- status: Status do filme (Released, Post Production, etc.)
- tagline: Slogan do filme
- vote_average: Nota média de avaliação
- vote_count: Quantidade de votos recebidos
- imdb_id: Identificador no IMDb
- original_language: Idioma original
- genres: Gêneros do filme (texto concatenado)
- production_companies: Companhias de produção (texto concatenado)
- production_countries: Países de produção (texto concatenado)
- spoken_languages: Idiomas falados (texto concatenado)
- belongs_to_collection: Coleção/franquia à qual pertence

**Restrições:**
- id é chave primária e não pode ser nulo
- id deve ser único
- title é obrigatório

---

### 2. RATINGS (Avaliações)
**Descrição:** Armazena as avaliações de filmes feitas pelos usuários.

**Atributos:**
- **user_id** (PK, FK composta): Identificador do usuário
- **movie_id** (PK, FK): Identificador do filme avaliado
- rating: Nota atribuída ao filme (0.5 a 5.0)
- rating_timestamp: Data e hora da avaliação

**Restrições:**
- Chave primária composta por (user_id, movie_id)
- movie_id é chave estrangeira que referencia MOVIES(id)
- rating deve estar entre 0.5 e 5.0
- Um usuário pode avaliar um filme apenas uma vez

---

## 🔗 Relacionamentos

### 1. MOVIES ←→ RATINGS
- **Tipo:** 1:N (Um para Muitos)
- **Descrição:** Um filme pode ter várias avaliações, mas cada avaliação pertence a apenas um filme
- **Cardinalidade:** (1,N) ←→ (0,N)
- **Participação:** 
  - Um filme pode existir sem avaliações (participação parcial)
  - Uma avaliação deve estar associada a um filme existente (participação total)

---

## 📊 Regras de Negócio

1. **RN01:** Todo filme deve ter um identificador único (id)
2. **RN02:** Um usuário não pode avaliar o mesmo filme mais de uma vez
3. **RN03:** As avaliações devem referenciar filmes existentes na base
4. **RN04:** A nota de avaliação deve estar no intervalo de 0.5 a 5.0
5. **RN05:** Filmes podem existir sem avaliações
6. **RN06:** Avaliações devem sempre estar associadas a um filme válido
7. **RN07:** O timestamp da avaliação deve ser registrado automaticamente

---

## 🎨 Diagrama Conceitual (Notação Chen)

```
┌─────────────────────┐
│      MOVIES         │
├─────────────────────┤
│ ⬤ id (PK)          │
│ ○ title            │
│ ○ overview         │
│ ○ release_date     │
│ ○ budget           │
│ ○ revenue          │
│ ○ runtime          │
│ ○ popularity       │
│ ○ status           │
│ ○ tagline          │
│ ○ vote_average     │
│ ○ vote_count       │
│ ○ imdb_id          │
│ ○ original_language│
│ ○ genres           │
│ ○ production_...   │
└─────────────────────┘
          │
          │ 1
          │
          ◇ RECEBE
          │
          │ N
          │
┌─────────────────────┐
│      RATINGS        │
├─────────────────────┤
│ ⬤ user_id (PK)     │
│ ⬤ movie_id (PK,FK) │
│ ○ rating           │
│ ○ rating_timestamp │
└─────────────────────┘
```

**Legenda:**
- ⬤ = Atributo chave
- ○ = Atributo simples
- ◇ = Relacionamento
- PK = Primary Key (Chave Primária)
- FK = Foreign Key (Chave Estrangeira)

---

## 📝 Observações Técnicas

1. **Desnormalização Controlada:** 
   - Os campos `genres`, `production_companies`, `production_countries` e `spoken_languages` estão armazenados como texto concatenado para simplificar a estrutura inicial
   - Esta abordagem facilita consultas simples, mas pode ser normalizada futuramente se necessário

2. **Integridade Referencial:**
   - A relação entre RATINGS e MOVIES é garantida por chave estrangeira
   - Exclusões em cascata não são aplicadas para preservar histórico de avaliações

3. **Escalabilidade:**
   - O modelo atual suporta milhões de registros
   - Índices devem ser criados em campos frequentemente consultados

4. **Campos Derivados:**
   - `vote_average` e `vote_count` podem ser calculados a partir de RATINGS, mas são mantidos em MOVIES para performance

---

## 🔄 Evolução Futura

Possíveis melhorias para versões futuras:

1. **Normalização de Gêneros:** Criar tabela separada para gêneros com relacionamento N:N
2. **Tabela de Usuários:** Adicionar entidade USERS com informações demográficas
3. **Tabela de Elenco:** Normalizar informações de atores e diretores
4. **Tabela de Palavras-chave:** Separar keywords em entidade própria
5. **Auditoria:** Adicionar campos de auditoria (created_at, updated_at)
