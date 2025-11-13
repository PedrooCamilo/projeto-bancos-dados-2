# ============================================================================
# Script de Inicializacao - Sistema de Analise de Filmes
# PowerShell Script para Windows
# ============================================================================

Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host " Sistema de Analise de Filmes - Ponto de Controle 1" -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se Docker esta instalado
Write-Host "Verificando pre-requisitos..." -ForegroundColor Yellow
Write-Host ""

try {
    $dockerVersion = docker --version
    Write-Host "[OK] Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERRO] Docker nao encontrado!" -ForegroundColor Red
    Write-Host "       Por favor, instale o Docker Desktop: https://www.docker.com/products/docker-desktop" -ForegroundColor Red
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

try {
    $composeVersion = docker-compose --version
    Write-Host "[OK] Docker Compose encontrado: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERRO] Docker Compose nao encontrado!" -ForegroundColor Red
    Write-Host "       Por favor, instale o Docker Compose" -ForegroundColor Red
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host ""

# Verificar se os arquivos CSV existem
Write-Host "Verificando arquivos de dados..." -ForegroundColor Yellow

$csvPath = Join-Path $PSScriptRoot "Data Layer\raw\dados_brutos"
$requiredFiles = @("movies_metadata.csv", "credits.csv", "keywords.csv", "ratings_small.csv")
$missingFiles = @()

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $csvPath $file
    if (Test-Path $filePath) {
        Write-Host "   [OK] $file" -ForegroundColor Green
    } else {
        Write-Host "   [X] $file (FALTANDO)" -ForegroundColor Red
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "[ERRO] Arquivos CSV faltando!" -ForegroundColor Red
    Write-Host "       Por favor, coloque os arquivos na pasta:" -ForegroundColor Red
    Write-Host "       $csvPath" -ForegroundColor Red
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host ""
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host " Iniciando o Sistema" -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

# Perguntar ao usuario o que fazer
Write-Host "Escolha uma opcao:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1) Iniciar sistema (docker-compose up)" -ForegroundColor White
Write-Host "  2) Iniciar e reconstruir (docker-compose up --build)" -ForegroundColor White
Write-Host "  3) Parar sistema (docker-compose down)" -ForegroundColor White
Write-Host "  4) Resetar tudo (down -v + up --build)" -ForegroundColor White
Write-Host "  5) Ver logs" -ForegroundColor White
Write-Host "  6) Conectar ao MySQL" -ForegroundColor White
Write-Host "  0) Sair" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Digite sua escolha (0-6)"

$dockerPath = Join-Path $PSScriptRoot "Docker"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Iniciando sistema..." -ForegroundColor Green
        Set-Location $dockerPath
        docker-compose up
    }
    "2" {
        Write-Host ""
        Write-Host "Reconstruindo e iniciando sistema..." -ForegroundColor Green
        Set-Location $dockerPath
        docker-compose up --build
    }
    "3" {
        Write-Host ""
        Write-Host "Parando sistema..." -ForegroundColor Yellow
        Set-Location $dockerPath
        docker-compose down
        Write-Host ""
        Write-Host "[OK] Sistema parado!" -ForegroundColor Green
    }
    "4" {
        Write-Host ""
        Write-Host "Resetando tudo (isso vai apagar os dados)..." -ForegroundColor Yellow
        $confirm = Read-Host "Tem certeza? (s/n)"
        if ($confirm -eq "s" -or $confirm -eq "S") {
            Set-Location $dockerPath
            docker-compose down -v
            Write-Host ""
            Write-Host "Reconstruindo..." -ForegroundColor Green
            docker-compose up --build
        } else {
            Write-Host "[CANCELADO] Operacao cancelada" -ForegroundColor Red
        }
    }
    "5" {
        Write-Host ""
        Write-Host "Mostrando logs..." -ForegroundColor Green
        Write-Host "(Pressione Ctrl+C para sair)" -ForegroundColor Yellow
        Write-Host ""
        Set-Location $dockerPath
        docker-compose logs -f
    }
    "6" {
        Write-Host ""
        Write-Host "Conectando ao MySQL..." -ForegroundColor Green
        Write-Host "Credenciais:" -ForegroundColor Yellow
        Write-Host "  - Database: movies_db" -ForegroundColor White
        Write-Host "  - User: app_user" -ForegroundColor White
        Write-Host "  - Password: app_password" -ForegroundColor White
        Write-Host ""
        docker exec -it movies_mysql_db mysql -u app_user -pmovies_db
    }
    "0" {
        Write-Host ""
        Write-Host "Ate logo!" -ForegroundColor Cyan
        exit 0
    }
    default {
        Write-Host ""
        Write-Host "[ERRO] Opcao invalida!" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host " Concluido!" -ForegroundColor Green
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

if ($choice -eq "1" -or $choice -eq "2") {
    Write-Host "Para conectar ao banco de dados:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Host: localhost" -ForegroundColor White
    Write-Host "  Port: 3306" -ForegroundColor White
    Write-Host "  Database: movies_db" -ForegroundColor White
    Write-Host "  User: app_user" -ForegroundColor White
    Write-Host "  Password: app_password" -ForegroundColor White
    Write-Host ""
    Write-Host "  Ou execute novamente este script e escolha opcao 6" -ForegroundColor Cyan
    Write-Host ""
}

Read-Host "Pressione Enter para sair"
