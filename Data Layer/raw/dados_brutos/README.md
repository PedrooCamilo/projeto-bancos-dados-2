# 📁 Dados Brutos (RAW)

Esta pasta contém os **dados brutos** do projeto, que não são versionados no Git devido ao tamanho.

## 📥 Como Obter os Dados

Os arquivos CSV originais devem ser baixados do dataset **TMDB (The Movies Dataset)** no Kaggle:

🔗 **Link**: https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset

## 📦 Arquivos Necessários

Após baixar, coloque os seguintes arquivos nesta pasta:

- ✅ `movies_metadata.csv` (~45K filmes)
- ✅ `credits.csv` (~45K registros de créditos)
- ✅ `keywords.csv` (~46K palavras-chave)
- ✅ `ratings_small.csv` (~100K avaliações)

**Arquivos opcionais** (não usados no projeto atual):
- `links.csv`
- `links_small.csv`
- `ratings.csv` (arquivo completo, muito grande)

## 📊 Tamanho Estimado

- Total: ~1.5 GB (com ratings completo)
- Apenas arquivos necessários: ~200 MB

## ⚠️ Importante

Os arquivos `.csv` estão no `.gitignore` e **não devem** ser commitados no repositório.

---

**Última atualização**: Novembro 2025
