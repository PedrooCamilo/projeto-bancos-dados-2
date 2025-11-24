# Estrutura Real das Tabelas GOLD

## Observação Importante
Os documentos DER, DLD, MER e Mnemônicos foram criados com uma estrutura diferente da implementação real.

**Esta é a estrutura REAL implementada no banco de dados:**

### dim_tempo
- tmp_srk (PK)
- dta_completa
- ano_lancamento
- mes_numero
- mes_nome
- mes_abrev
- dia_numero
- dia_semana
- nom_dia_semana
- tri_numero
- tri_nome
- sem_numero
- dec_inicio
- flg_feriado
- flg_fim_semana

### dim_filme
- mov_srk (PK)
- mov_nky (chave natural)
- mov_titulo
- mov_titulo_original
- cod_idioma
- cod_imdb
- txt_sinopse
- txt_tagline
- url_homepage
- url_poster
- cat_status
- cat_orcamento
- cat_receita
- cat_duracao

### dim_genero
- gnr_srk (PK)
- gnr_nome
- gnr_descricao
- gnr_categoria

### dim_companhia
- cmp_srk (PK)
- cmp_nome
- cmp_tipo

### dim_geografia
- geo_srk (PK)
- geo_pais
- geo_codigo_iso
- geo_continente
- geo_regiao

### dim_diretor
- dir_srk (PK)
- dir_nome
- dir_nome_completo

### dim_ator
- act_srk (PK)
- act_nome
- act_nome_completo

### fto_filme
- fto_srk (PK)
- mov_fky (FK → dim_filme)
- tmp_fky (FK → dim_tempo)
- gnr_fky (FK → dim_genero)
- cmp_fky (FK → dim_companhia)
- geo_fky (FK → dim_geografia)
- dir_fky (FK → dim_diretor)
- act_fky (FK → dim_ator)
- vlr_orcamento
- vlr_receita
- vlr_lucro
- pct_roi
- med_avaliacao
- qtd_votos
- med_popularidade
- dur_minutos
- qtd_elenco
- qtd_equipe
- flg_adulto
- flg_blockbuster

---

**Última Atualização**: 2025-11-23
