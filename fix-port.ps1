# Script para Resolver Problema da Porta 3306
# Execute como Administrador

Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host " Resolvendo Conflito de Porta 3306" -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se esta rodando como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[AVISO] Este script deve ser executado como Administrador!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Clique com botao direito no PowerShell e escolha 'Executar como Administrador'" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "Verificando o que esta usando a porta 3306..." -ForegroundColor Yellow
Write-Host ""

$connections = netstat -ano | Select-String ":3306"

if ($connections) {
    Write-Host "Encontrado:" -ForegroundColor Green
    Write-Host $connections
    Write-Host ""
    
    # Tentar parar o servico MySQL
    Write-Host "Tentando parar servicos MySQL..." -ForegroundColor Yellow
    
    $services = @("MySQL", "MySQL80", "MySQL57", "MySQL56")
    $stopped = $false
    
    foreach ($serviceName in $services) {
        try {
            $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
            if ($service) {
                if ($service.Status -eq 'Running') {
                    Write-Host "Parando servico: $serviceName" -ForegroundColor Yellow
                    Stop-Service -Name $serviceName -Force
                    Write-Host "[OK] Servico $serviceName parado!" -ForegroundColor Green
                    $stopped = $true
                } else {
                    Write-Host "Servico $serviceName ja esta parado" -ForegroundColor Gray
                }
            }
        } catch {
            # Servico nao existe, continuar
        }
    }
    
    if ($stopped) {
        Write-Host ""
        Write-Host "[SUCESSO] Porta 3306 liberada!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Agora voce pode executar:" -ForegroundColor Cyan
        Write-Host "  cd Docker" -ForegroundColor White
        Write-Host "  docker-compose up --build" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "[AVISO] Nenhum servico MySQL encontrado rodando" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "A porta pode estar sendo usada por outro programa." -ForegroundColor Yellow
        Write-Host "Voce pode:" -ForegroundColor Yellow
        Write-Host "  1) Fechar manualmente o programa que usa a porta 3306" -ForegroundColor White
        Write-Host "  2) Mudar a porta no docker-compose.yml para 3307" -ForegroundColor White
        Write-Host ""
        Write-Host "Para ver o PID do processo:" -ForegroundColor Cyan
        netstat -ano | Select-String ":3306"
    }
} else {
    Write-Host "[OK] Porta 3306 esta livre!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Voce pode executar:" -ForegroundColor Cyan
    Write-Host "  cd Docker" -ForegroundColor White
    Write-Host "  docker-compose up --build" -ForegroundColor White
}

Write-Host ""
Read-Host "Pressione Enter para sair"
