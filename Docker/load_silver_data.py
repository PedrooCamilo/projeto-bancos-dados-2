#!/usr/bin/env python3
"""
Script de Carga Automática - Camada SILVER
Carrega dados dos CSVs processados para o PostgreSQL
"""

import os
import sys
import time
import pandas as pd
import psycopg2
from psycopg2.extras import execute_values
from pathlib import Path

def wait_for_postgres(config, max_retries=30, delay=2):
    """Aguarda o PostgreSQL ficar disponível"""
    print("⏳ Aguardando PostgreSQL ficar disponível...")
    
    for i in range(max_retries):
        try:
            conn = psycopg2.connect(**config)
            conn.close()
            print("✅ PostgreSQL está pronto!\n")
            return True
        except psycopg2.OperationalError:
            print(f"   Tentativa {i+1}/{max_retries}... aguardando {delay}s")
            time.sleep(delay)
    
    print("❌ Timeout: PostgreSQL não ficou disponível")
    return False

def load_csv_to_postgres(csv_path, table_schema, table_name, conn, cursor):
    """Carrega dados de um CSV para o PostgreSQL"""
    print(f"📥 Carregando {csv_path.name}...")
    
    # Ler CSV
    df = pd.read_csv(csv_path)
    print(f"   {len(df):,} registros lidos do CSV")
    
    # Limpar dados
    df_clean = df.dropna(subset=['id']).drop_duplicates(subset=['id'])
    print(f"   {len(df_clean):,} registros limpos (sem duplicatas/nulls)")
    
    # Preparar dados
    data_tuples = []
    for _, row in df_clean.iterrows():
        row_data = tuple(None if pd.isna(val) else val for val in row)
        data_tuples.append(row_data)
    
    # Criar SQL de inserção
    columns = ', '.join(df_clean.columns)
    placeholders = '%s'
    insert_sql = f"INSERT INTO {table_schema}.{table_name} ({columns}) VALUES %s ON CONFLICT (id) DO NOTHING"
    
    # Truncar tabela antes de inserir
    cursor.execute(f"TRUNCATE TABLE {table_schema}.{table_name};")
    conn.commit()
    
    # Inserir dados
    execute_values(cursor, insert_sql, data_tuples, page_size=1000)
    conn.commit()
    
    # Verificar quantidade inserida
    cursor.execute(f"SELECT COUNT(*) FROM {table_schema}.{table_name};")
    count = cursor.fetchone()[0]
    print(f"   ✅ {count:,} registros inseridos em {table_schema}.{table_name}\n")
    
    return count

def main():
    print("="*80)
    print("🚀 ETL AUTOMÁTICO - CAMADA SILVER → PostgreSQL")
    print("="*80 + "\n")
    
    # Configuração do banco
    db_config = {
        'dbname': os.getenv('POSTGRES_DB', 'movies_dw'),
        'user': os.getenv('POSTGRES_USER', 'postgres'),
        'password': os.getenv('POSTGRES_PASSWORD', 'postgres123'),
        'host': os.getenv('POSTGRES_HOST', 'localhost'),
        'port': os.getenv('POSTGRES_PORT', '5432')
    }
    
    print("📋 Configuração:")
    print(f"   Database: {db_config['dbname']}")
    print(f"   Host: {db_config['host']}:{db_config['port']}")
    print(f"   User: {db_config['user']}\n")
    
    # Aguardar PostgreSQL
    if not wait_for_postgres(db_config):
        sys.exit(1)
    
    # Caminho dos dados
    data_path = Path('/data')
    movies_csv = data_path / 'movies_full.csv'
    
    # Verificar se CSV existe
    if not movies_csv.exists():
        print(f"❌ Arquivo não encontrado: {movies_csv}")
        print("\n⚠️  Execute primeiro o notebook etl_raw_to_silver.ipynb para gerar os CSVs!")
        sys.exit(1)
    
    print(f"📂 Diretório de dados: {data_path}")
    print(f"📄 Arquivo principal: {movies_csv.name}\n")
    
    try:
        # Conectar ao banco
        print("🔌 Conectando ao PostgreSQL...")
        conn = psycopg2.connect(**db_config)
        cursor = conn.cursor()
        print("   ✅ Conexão estabelecida\n")
        
        # Carregar dados
        total = load_csv_to_postgres(
            csv_path=movies_csv,
            table_schema='silver',
            table_name='movies_raw',
            conn=conn,
            cursor=cursor
        )
        
        # Fechar conexão
        cursor.close()
        conn.close()
        
        print("="*80)
        print("✅ ETL CONCLUÍDO COM SUCESSO!")
        print("="*80)
        print(f"Total de registros carregados: {total:,}")
        print("Schema: silver")
        print("Tabela: movies_raw")
        print("="*80 + "\n")
        
    except Exception as e:
        print(f"\n❌ ERRO durante ETL: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == '__main__':
    main()
