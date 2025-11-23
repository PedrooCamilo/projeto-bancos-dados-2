#!/bin/bash
# Script para aguardar PostgreSQL estar pronto antes de carregar dados

set -e

host="$1"
shift
cmd="$@"

echo "⏳ Aguardando PostgreSQL estar pronto em $host:5432..."

until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$host" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q' 2>/dev/null; do
  >&2 echo "   PostgreSQL ainda não está pronto - aguardando..."
  sleep 2
done

>&2 echo "✅ PostgreSQL está pronto!"
echo "🚀 Iniciando carga de dados..."

exec $cmd
