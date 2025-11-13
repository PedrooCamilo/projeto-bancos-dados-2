#!/bin/bash
################################################################################
# Entrypoint Script para o Serviço ETL
# 
# Este script:
# 1. Aguarda o banco de dados ficar pronto
# 2. Executa o pipeline ETL
################################################################################

set -e

echo "════════════════════════════════════════════════════════════════════════════"
echo "🚀 Iniciando Serviço de ETL"
echo "════════════════════════════════════════════════════════════════════════════"

# Aguarda o banco de dados estar pronto
echo ""
echo "⏳ Aguardando o banco de dados ficar disponível..."
echo "   Host: $DB_HOST:$DB_PORT"

MAX_TRIES=30
COUNT=0

until python3 -c "import mysql.connector; mysql.connector.connect(host='$DB_HOST', port=$DB_PORT, user='$DB_USER', password='$DB_PASSWORD', database='$DB_NAME')" 2>/dev/null || [ $COUNT -eq $MAX_TRIES ]; do
    COUNT=$((COUNT + 1))
    echo "   Tentativa $COUNT de $MAX_TRIES..."
    sleep 2
done

if [ $COUNT -eq $MAX_TRIES ]; then
    echo ""
    echo "❌ Erro: Banco de dados não ficou disponível após $MAX_TRIES tentativas"
    echo "════════════════════════════════════════════════════════════════════════════"
    exit 1
fi

echo ""
echo "✅ Banco de dados está pronto!"
echo ""
echo "────────────────────────────────────────────────────────────────────────────"
echo ""

# Aguarda mais alguns segundos para garantir que o banco está totalmente pronto
sleep 5

# Executa o comando passado (normalmente o script ETL)
exec "$@"
