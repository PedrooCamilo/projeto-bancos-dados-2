# MER - Modelo Entidade-Relacionamento (GOLD Layer)

## Modelo Conceitual de Dados - Camada Dimensional

---

## 📊 VISÃO GERAL

O modelo conceitual da camada GOLD representa um **Data Warehouse dimensional** baseado no padrão **Star Schema**, otimizado para análises analíticas (OLAP) de filmes cinematográficos.

### Propósito
- Suportar análises multidimensionais sobre filmes
- Facilitar consultas de BI e dashboards
- Otimizar performance para agregações e relatórios
- Manter histórico analítico de dados cinematográficos

---

## 🎯 ENTIDADES PRINCIPAIS

### DIMENSÕES (7)

#### 1. TEMPO
**Conceito**: Dimensão temporal completa com hierarquia calendário  
**Granularidade**: Dia  
**Hierarquias**:
- Dia → Mês → Trimestre → Ano → Década
- Dia → Semana → Ano

**Atributos-Chave**:
- Data completa, ano, mês, trimestre, semana, década
- Flags: feriado, fim de semana

**Propósito**: Permitir análises temporais em múltiplos níveis de agregação

---

#### 2. FILME
**Conceito**: Catálogo de filmes com atributos descritivos  
**Granularidade**: Filme individual  

**Atributos-Chave**:
- Identificação: ID natural, títulos (original e traduzido)
- Códigos: Idioma, IMDb
- Conteúdo: Sinopse, tagline
- URLs: Homepage, poster
- Classificações: Status, categorias (orçamento, receita, duração)

**Propósito**: Armazenar características descritivas únicas de cada filme

---

#### 3. GÊNERO
**Conceito**: Classificação por gênero cinematográfico  
**Granularidade**: Gênero único  

**Atributos-Chave**:
- Nome do gênero
- Descrição detalhada
- Categoria de agrupamento

**Propósito**: Permitir análises por gênero e categoria de filmes

---

#### 4. COMPANHIA
**Conceito**: Empresas produtoras/distribuidoras  
**Granularidade**: Companhia individual  

**Atributos-Chave**:
- Nome da companhia
- Tipo (Production, Distribution, etc)

**Propósito**: Analisar produção por estúdio e tipo de companhia

---

#### 5. GEOGRAFIA
**Conceito**: Localização geográfica de produção  
**Granularidade**: País  
**Hierarquias**:
- País → Região → Continente

**Atributos-Chave**:
- País, código ISO
- Continente
- Região geográfica

**Propósito**: Análises geográficas e de mercado

---

#### 6. DIRETOR
**Conceito**: Profissionais de direção cinematográfica  
**Granularidade**: Diretor individual  

**Atributos-Chave**:
- Nome
- Nome completo

**Propósito**: Análises de desempenho por diretor

---

#### 7. ATOR
**Conceito**: Profissionais de atuação cinematográfica  
**Granularidade**: Ator individual  

**Atributos-Chave**:
- Nome
- Nome completo

**Propósito**: Análises de desempenho por ator

---

### FATO (1)

#### FILME (Fato Central)
**Conceito**: Registro analítico de filme com todas as dimensões e métricas  
**Granularidade**: Combinação única de Filme + Data + Gênero + Companhia + País + Diretor + Ator  
**Tipo**: Fato Transacional (additive)

**Métricas Financeiras**:
- Orçamento, Receita, Lucro
- ROI (Retorno sobre Investimento)

**Métricas de Avaliação**:
- Avaliação média
- Quantidade de votos
- Popularidade média

**Métricas Descritivas**:
- Duração em minutos
- Quantidade de elenco
- Quantidade de equipe

**Flags Analíticas**:
- Conteúdo adulto
- Blockbuster

**Propósito**: Centralizar todas as métricas e relacionamentos para análise

---

## 🔗 RELACIONAMENTOS

### Padrão: Star Schema (1:N)

Todos os relacionamentos seguem o padrão **1:Muitos** entre Dimensões e Fato:

```
TEMPO       (1) ───── (N) FATO_FILME
FILME       (1) ───── (N) FATO_FILME
GÊNERO      (1) ───── (N) FATO_FILME
COMPANHIA   (1) ───── (N) FATO_FILME
GEOGRAFIA   (1) ───── (N) FATO_FILME
DIRETOR     (1) ───── (N) FATO_FILME
ATOR        (1) ───── (N) FATO_FILME
```

### Interpretação dos Relacionamentos

| Dimensão   | Interpretação                                              |
|------------|-----------------------------------------------------------|
| TEMPO      | Um ano pode ter múltiplos filmes registrados              |
| FILME      | Um filme pode aparecer múltiplas vezes (diferentes combinações) |
| GÊNERO     | Um gênero pode classificar múltiplos filmes               |
| COMPANHIA  | Uma companhia pode produzir múltiplos filmes              |
| GEOGRAFIA  | Um país pode produzir múltiplos filmes                    |
| DIRETOR    | Um diretor pode dirigir múltiplos filmes                  |
| ATOR       | Um ator pode atuar em múltiplos filmes                    |

---

## 📐 REGRAS DE NEGÓCIO

### RN001 - Integridade Referencial
**Regra**: Todo registro na tabela FATO deve referenciar registros válidos em TODAS as 7 dimensões  
**Implementação**: Foreign Keys obrigatórias (NOT NULL)  
**Justificativa**: Garantir consistência dimensional

### RN002 - Chaves Substitutas
**Regra**: Todas as dimensões utilizam chaves substitutas sequenciais (surrogate keys)  
**Implementação**: Colunas *_srk do tipo SERIAL  
**Justificativa**: Performance e independência de mudanças nos dados de origem

### RN003 - Unicidade Dimensional
**Regra**: Cada dimensão possui constraint UNIQUE em sua chave natural  
**Exemplos**: 
- dim_tempo: ano único
- dim_filme: mov_nky (ID natural) único
- dim_genero: nome único
**Justificativa**: Evitar duplicação de dados descritivos

### RN004 - Métricas Aditivas
**Regra**: Todas as métricas financeiras e quantitativas são aditivas (podem ser somadas)  
**Métricas Aditivas**: orçamento, receita, lucro, votos, elenco, equipe  
**Métricas Semi-Aditivas**: avaliação média, ROI, popularidade (requerem recálculo)  
**Justificativa**: Facilitar agregações e totalizações

### RN005 - Desnormalização
**Regra**: Dimensões são intencionalmente desnormalizadas para incluir atributos descritivos  
**Exemplo**: dim_tempo inclui mês_nome, tri_nome, etc (deriváveis mas armazenados)  
**Justificativa**: Otimização de queries (evitar JOINs e cálculos)

### RN006 - Flags Booleanas
**Regra**: Atributos booleanos utilizam prefixo "flg_" e armazenam TRUE/FALSE  
**Exemplos**: flg_adulto, flg_blockbuster, flg_feriado, flg_fim_semana  
**Justificativa**: Facilitar filtros e segmentações

### RN007 - Categorização
**Regra**: Valores numéricos possuem categorias correspondentes para análises qualitativas  
**Exemplo**: vlr_orcamento → cat_orcamento (Baixo, Médio, Alto)  
**Justificativa**: Suportar análises categóricas além de numéricas

### RN008 - Granularidade Temporal
**Regra**: A dimensão tempo suporta múltiplas hierarquias de análise  
**Hierarquias**: Dia/Mês/Trimestre/Ano/Década e Dia/Semana/Ano  
**Justificativa**: Flexibilidade em análises temporais

### RN009 - Códigos Padronizados
**Regra**: Códigos internacionais utilizam padrões reconhecidos  
**Exemplos**: 
- geo_codigo_iso: ISO 3166-1
- cod_idioma: ISO 639-1
**Justificativa**: Interoperabilidade e integração

### RN010 - Preservação Histórica
**Regra**: Não há DELETE ou UPDATE CASCADE na fato  
**Implementação**: Constraints sem cascata  
**Justificativa**: Preservar histórico analítico completo

---

## 🎨 CARACTERÍSTICAS DO MODELO

### ✅ Vantagens do Star Schema

1. **Simplicidade**
   - Estrutura intuitiva e fácil de entender
   - Navegação direta entre fato e dimensões
   - Facilita onboarding de analistas

2. **Performance**
   - JOINs otimizados (1 nível apenas)
   - Índices eficientes em chaves estrangeiras
   - Queries respondem rapidamente

3. **Flexibilidade**
   - Fácil adicionar novas dimensões
   - Fácil adicionar novos atributos
   - Suporta múltiplas perspectivas de análise

4. **Escalabilidade**
   - Cresce linearmente com dados
   - Particionamento simples
   - Manutenção facilitada

### 📊 Tipos de Análises Suportadas

- **Análise Temporal**: Evolução de receita ao longo dos anos, tendências por trimestre
- **Análise Categórica**: Performance por gênero, categoria de orçamento
- **Análise Geográfica**: Produção por país, continente, região
- **Análise de Talentos**: Desempenho de diretores e atores
- **Análise Financeira**: ROI, lucros, comparações orçamento vs receita
- **Análise de Popularidade**: Blockbusters, filmes mais votados, avaliações
- **Análise Multidimensional**: Combinação de múltiplas dimensões (ex: gênero + ano + país)

### 🔍 Exemplos de Questões de Negócio

1. Qual a receita total de filmes de Ação nos últimos 5 anos?
2. Quais diretores têm o melhor ROI médio?
3. Como a popularidade de gêneros evoluiu por década?
4. Quais países produzem os filmes com maior orçamento?
5. Qual a relação entre duração do filme e avaliação média?
6. Quantos blockbusters foram produzidos por companhia?
7. Qual o lucro médio por gênero e continente?
8. Quais atores aparecem nos filmes mais lucrativos?

---

## 📦 VOLUMETRIA ESTIMADA

| Entidade        | Tipo      | Registros | Crescimento |
|-----------------|-----------|-----------|-------------|
| TEMPO           | Dimensão  | ~17.000   | Baixo       |
| FILME           | Dimensão  | ~45.000   | Médio       |
| GÊNERO          | Dimensão  | ~20       | Muito Baixo |
| COMPANHIA       | Dimensão  | ~1.500    | Baixo       |
| GEOGRAFIA       | Dimensão  | ~100      | Muito Baixo |
| DIRETOR         | Dimensão  | ~3.000    | Médio       |
| ATOR            | Dimensão  | ~5.000    | Médio       |
| FATO_FILME      | Fato      | ~100.000  | Alto        |

---

## 🏗️ MODELO IMPLEMENTADO

**Status**: ✅ Operacional  
**Padrão**: Star Schema  
**Total de Entidades**: 8 (7 dimensões + 1 fato)  
**Total de Relacionamentos**: 7 (todos 1:N)  
**Total de Atributos**: 70  

---

**Última Atualização**: 2025-11-23
