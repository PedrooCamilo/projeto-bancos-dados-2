"""
╔══════════════════════════════════════════════════════════════════════════════╗
║                    JOB ETL - RAW para SILVER                                 ║
║                  Sistema de Análise de Filmes                                ║
╚══════════════════════════════════════════════════════════════════════════════╝

Descrição:
    Script de ETL (Extract, Transform, Load) que processa os dados brutos da
    camada RAW e carrega na camada SILVER (banco de dados MySQL).

Funcionalidades:
    1. Extração dos arquivos CSV da camada RAW
    2. Transformação e limpeza dos dados
    3. Carga no banco de dados MySQL (Silver Layer)

Autor: Sistema de Análise de Filmes
Versão: 1.0
Data: 2024
"""

import pandas as pd
import ast
import warnings
from sqlalchemy import create_engine, text
from datetime import datetime
import os
import sys

# Suprime warnings desnecessários
warnings.filterwarnings('ignore')


class ETLPipeline:
    """Classe principal do pipeline ETL"""
    
    def __init__(self, db_config, data_path):
        """
        Inicializa o pipeline ETL
        
        Args:
            db_config (dict): Configurações de conexão do banco de dados
            data_path (str): Caminho para a pasta com os arquivos CSV
        """
        self.db_config = db_config
        self.data_path = data_path
        self.engine = None
        self.df_movies = None
        self.df_credits = None
        self.df_keywords = None
        self.df_ratings = None
        self.df_movies_final = None
        
        print("═" * 80)
        print("🎬 ETL Pipeline - Sistema de Análise de Filmes")
        print("═" * 80)
        
    def connect_database(self):
        """Estabelece conexão com o banco de dados"""
        print("\n📡 Conectando ao banco de dados...")
        
        try:
            connection_string = (
                f"mysql+mysqlconnector://{self.db_config['user']}:"
                f"{self.db_config['password']}@{self.db_config['host']}:"
                f"{self.db_config['port']}/{self.db_config['database']}"
            )
            self.engine = create_engine(connection_string)
            
            # Testa a conexão
            with self.engine.connect() as conn:
                print("✅ Conexão estabelecida com sucesso!")
                return True
                
        except Exception as e:
            print(f"❌ Erro ao conectar ao banco de dados: {e}")
            return False
    
    def extract(self):
        """Extrai dados dos arquivos CSV"""
        print("\n" + "─" * 80)
        print("📥 FASE 1: EXTRAÇÃO (Extract)")
        print("─" * 80)
        
        try:
            # Carrega movies_metadata.csv
            print("\n📄 Carregando movies_metadata.csv...")
            movies_path = os.path.join(self.data_path, 'movies_metadata.csv')
            self.df_movies = pd.read_csv(movies_path)
            print(f"   ✓ {len(self.df_movies):,} filmes carregados")
            
            # Carrega credits.csv
            print("📄 Carregando credits.csv...")
            credits_path = os.path.join(self.data_path, 'credits.csv')
            self.df_credits = pd.read_csv(credits_path)
            print(f"   ✓ {len(self.df_credits):,} registros de créditos carregados")
            
            # Carrega keywords.csv
            print("📄 Carregando keywords.csv...")
            keywords_path = os.path.join(self.data_path, 'keywords.csv')
            self.df_keywords = pd.read_csv(keywords_path)
            print(f"   ✓ {len(self.df_keywords):,} registros de palavras-chave carregados")
            
            # Carrega ratings_small.csv
            print("📄 Carregando ratings_small.csv...")
            ratings_path = os.path.join(self.data_path, 'ratings_small.csv')
            self.df_ratings = pd.read_csv(ratings_path)
            print(f"   ✓ {len(self.df_ratings):,} avaliações carregadas")
            
            print("\n✅ Extração concluída com sucesso!")
            return True
            
        except FileNotFoundError as e:
            print(f"\n❌ Erro: Arquivo não encontrado - {e}")
            return False
        except Exception as e:
            print(f"\n❌ Erro durante a extração: {e}")
            return False
    
    def transform(self):
        """Transforma e limpa os dados"""
        print("\n" + "─" * 80)
        print("🔄 FASE 2: TRANSFORMAÇÃO (Transform)")
        print("─" * 80)
        
        # Etapa 1: Limpeza de IDs inválidos
        print("\n🧹 Etapa 1: Limpeza de IDs inválidos")
        original_count = len(self.df_movies)
        
        self.df_movies['id'] = pd.to_numeric(self.df_movies['id'], errors='coerce')
        self.df_movies.dropna(subset=['id'], inplace=True)
        self.df_movies['id'] = self.df_movies['id'].astype(int)
        
        removed_count = original_count - len(self.df_movies)
        print(f"   ✓ {removed_count} registros com ID inválido removidos")
        
        # Converte IDs das outras tabelas
        self.df_credits['id'] = self.df_credits['id'].astype(int)
        self.df_keywords['id'] = self.df_keywords['id'].astype(int)
        
        # Etapa 2: Mesclagem dos DataFrames
        print("\n🔗 Etapa 2: Mesclagem dos DataFrames")
        self.df_movies = pd.merge(self.df_movies, self.df_credits, on='id', how='left')
        self.df_movies = pd.merge(self.df_movies, self.df_keywords, on='id', how='left')
        print(f"   ✓ DataFrames mesclados: {self.df_movies.shape}")
        
        # Remove duplicatas
        original_count = len(self.df_movies)
        self.df_movies.drop_duplicates(subset=['id'], keep='first', inplace=True)
        duplicates_removed = original_count - len(self.df_movies)
        print(f"   ✓ {duplicates_removed} duplicatas removidas")
        
        # Etapa 3: Conversão de tipos de dados
        print("\n🔢 Etapa 3: Conversão de tipos de dados")
        
        self.df_movies['budget'] = pd.to_numeric(
            self.df_movies['budget'], errors='coerce'
        ).fillna(0).astype(int)
        
        self.df_movies['popularity'] = pd.to_numeric(
            self.df_movies['popularity'], errors='coerce'
        ).fillna(0).astype(float)
        
        self.df_movies['release_date'] = pd.to_datetime(
            self.df_movies['release_date'], errors='coerce'
        )
        
        self.df_movies['adult'] = self.df_movies['adult'] == 'True'
        self.df_movies['video'] = self.df_movies['video'] == 'True'
        
        print("   ✓ Tipos de dados convertidos")
        
        # Etapa 4: Extração de dados JSON
        print("\n📦 Etapa 4: Extração de dados JSON")
        
        self.df_movies['genres'] = self.df_movies['genres'].apply(
            lambda x: self._extract_json_data(x, 'name')
        )
        
        self.df_movies['cast'] = self.df_movies['cast'].apply(
            lambda x: self._extract_json_data(x, 'name', limit=3)
        )
        
        self.df_movies['keywords'] = self.df_movies['keywords'].apply(
            lambda x: self._extract_json_data(x, 'name')
        )
        
        self.df_movies['director'] = self.df_movies['crew'].apply(
            self._get_director
        )
        
        self.df_movies['belongs_to_collection'] = self.df_movies['belongs_to_collection'].apply(
            self._get_collection_name
        )
        
        self.df_movies['production_companies'] = self.df_movies['production_companies'].apply(
            lambda x: self._extract_json_data(x, 'name', limit=3)
        )
        
        self.df_movies['production_countries'] = self.df_movies['production_countries'].apply(
            lambda x: self._extract_json_data(x, 'name')
        )
        
        self.df_movies['spoken_languages'] = self.df_movies['spoken_languages'].apply(
            lambda x: self._extract_json_data(x, 'name')
        )
        
        print("   ✓ Dados JSON extraídos e processados")
        
        # Etapa 5: Seleção e preparação final
        print("\n✂️ Etapa 5: Seleção de colunas finais")
        
        colunas_finais = [
            'id', 'title', 'overview', 'release_date', 'budget', 'revenue', 'runtime',
            'popularity', 'status', 'tagline', 'vote_average', 'vote_count', 'imdb_id',
            'original_language', 'genres', 'production_companies', 'production_countries',
            'spoken_languages', 'belongs_to_collection'
        ]
        
        self.df_movies_final = self.df_movies[colunas_finais].copy()
        
        # Preenche valores nulos de strings com string vazia
        for col in self.df_movies_final.select_dtypes(include='object').columns:
            self.df_movies_final[col] = self.df_movies_final[col].fillna('')
        
        print(f"   ✓ DataFrame final preparado: {self.df_movies_final.shape}")
        
        # Transformação da tabela RATINGS
        print("\n🌟 Etapa 6: Transformação da tabela RATINGS")
        
        self.df_ratings.rename(columns={
            'userId': 'user_id',
            'movieId': 'movie_id',
            'timestamp': 'rating_timestamp'
        }, inplace=True)
        
        self.df_ratings['rating_timestamp'] = pd.to_datetime(
            self.df_ratings['rating_timestamp'], unit='s'
        )
        
        # Filtra apenas avaliações de filmes que existem na base
        valid_movie_ids = self.df_movies_final['id'].unique()
        original_ratings = len(self.df_ratings)
        self.df_ratings = self.df_ratings[self.df_ratings['movie_id'].isin(valid_movie_ids)]
        filtered_ratings = original_ratings - len(self.df_ratings)
        
        print(f"   ✓ {filtered_ratings} avaliações de filmes inexistentes removidas")
        print(f"   ✓ {len(self.df_ratings):,} avaliações válidas")
        
        print("\n✅ Transformação concluída com sucesso!")
        return True
    
    def load(self):
        """Carrega dados no banco de dados"""
        print("\n" + "─" * 80)
        print("📤 FASE 3: CARGA (Load)")
        print("─" * 80)
        
        try:
            # Limpa as tabelas antes de carregar
            print("\n🧹 Limpando tabelas existentes...")
            with self.engine.connect() as connection:
                with connection.begin():
                    connection.execute(text("SET FOREIGN_KEY_CHECKS = 0;"))
                    connection.execute(text("TRUNCATE TABLE ratings;"))
                    connection.execute(text("TRUNCATE TABLE movies;"))
                    connection.execute(text("SET FOREIGN_KEY_CHECKS = 1;"))
            print("   ✓ Tabelas limpas")
            
            # Carrega tabela MOVIES
            print("\n📥 Carregando tabela MOVIES...")
            self.df_movies_final.to_sql(
                'movies',
                con=self.engine,
                if_exists='append',
                index=False,
                chunksize=1000
            )
            print(f"   ✓ {len(self.df_movies_final):,} filmes carregados")
            
            # Carrega tabela RATINGS
            print("\n📥 Carregando tabela RATINGS...")
            self.df_ratings.to_sql(
                'ratings',
                con=self.engine,
                if_exists='append',
                index=False,
                chunksize=5000
            )
            print(f"   ✓ {len(self.df_ratings):,} avaliações carregadas")
            
            print("\n✅ Carga concluída com sucesso!")
            return True
            
        except Exception as e:
            print(f"\n❌ Erro durante a carga: {e}")
            return False
    
    def run(self):
        """Executa o pipeline completo de ETL"""
        start_time = datetime.now()
        
        print(f"\n🕐 Início: {start_time.strftime('%Y-%m-%d %H:%M:%S')}")
        
        # Conecta ao banco
        if not self.connect_database():
            return False
        
        # Executa ETL
        if not self.extract():
            return False
            
        if not self.transform():
            return False
            
        if not self.load():
            return False
        
        # Finalização
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        
        print("\n" + "═" * 80)
        print("✅ PIPELINE ETL CONCLUÍDO COM SUCESSO!")
        print("═" * 80)
        print(f"🕐 Término: {end_time.strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"⏱️  Duração: {duration:.2f} segundos")
        print(f"📊 Resumo:")
        print(f"   • Filmes carregados: {len(self.df_movies_final):,}")
        print(f"   • Avaliações carregadas: {len(self.df_ratings):,}")
        print(f"   • Usuários únicos: {self.df_ratings['user_id'].nunique():,}")
        print("═" * 80)
        
        return True
    
    # ═══════════════════════════════════════════════════════════════════════
    # Métodos auxiliares
    # ═══════════════════════════════════════════════════════════════════════
    
    @staticmethod
    def _extract_json_data(data, key_to_extract, limit=None):
        """Extrai dados de strings JSON"""
        if isinstance(data, str) and data.startswith('['):
            try:
                list_of_items = ast.literal_eval(data)
                if list_of_items:
                    if limit:
                        list_of_items = list_of_items[:limit]
                    names = [item.get(key_to_extract, '') for item in list_of_items]
                    return ', '.join(filter(None, names))
            except (ValueError, SyntaxError):
                return ''
        return ''
    
    @staticmethod
    def _get_director(crew_data):
        """Extrai o nome do diretor da crew"""
        if isinstance(crew_data, str) and crew_data.startswith('['):
            try:
                crew_list = ast.literal_eval(crew_data)
                for member in crew_list:
                    if member.get('job') == 'Director':
                        return member.get('name', '')
            except (ValueError, SyntaxError):
                return ''
        return ''
    
    @staticmethod
    def _get_collection_name(data):
        """Extrai o nome da coleção"""
        if isinstance(data, str) and data.startswith('{'):
            try:
                collection_dict = ast.literal_eval(data)
                return collection_dict.get('name', '')
            except (ValueError, SyntaxError):
                return ''
        return ''


# ═══════════════════════════════════════════════════════════════════════════
# EXECUÇÃO PRINCIPAL
# ═══════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    # Configurações do banco de dados
    DB_CONFIG = {
        'user': 'app_user',
        'password': 'app_password',
        'host': 'db',  # Nome do serviço no docker-compose
        'port': '3306',
        'database': 'movies_db'
    }
    
    # Caminho dos dados brutos
    DATA_PATH = '/app/data/raw/dados_brutos'
    
    # Cria e executa o pipeline
    try:
        pipeline = ETLPipeline(DB_CONFIG, DATA_PATH)
        success = pipeline.run()
        
        # Retorna código de saída apropriado
        sys.exit(0 if success else 1)
        
    except KeyboardInterrupt:
        print("\n\n⚠️  Pipeline interrompido pelo usuário")
        sys.exit(1)
    except Exception as e:
        print(f"\n\n❌ Erro fatal: {e}")
        sys.exit(1)
