# Quick GitHub Upload Script
# Быстрая загрузка на GitHub за одну команду

param(
    [string]$Username = $(Read-Host "GitHub username"),
    [string]$Token = $(Read-Host -AsSecureString "GitHub Personal Access Token (или нажмите Enter чтобы использовать SSH)"),
    [string]$RepoName = "tester-panel-backend",
    [string]$UseSsh = $false
)

# Конвертировать к обычной строке если нужно
if ($Token -is [System.Security.SecureString]) {
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Token)
    $Token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
}

Write-Host ""
Write-Host "====================================== " -ForegroundColor Cyan
Write-Host "GitHub Upload Helper                " -ForegroundColor Cyan
Write-Host "====================================== " -ForegroundColor Cyan
Write-Host ""

# Git status
Write-Host "[1/4] Проверка Git статуса..." -ForegroundColor Yellow
git status --short

Write-Host ""
Write-Host "[2/4] Текущие remote репозитории:" -ForegroundColor Yellow
git remote -v

Write-Host ""
Write-Host "[3/4] Добавление remote..." -ForegroundColor Yellow

if ($Token -and $Token -ne "") {
    # HTTPS с токеном
    $remoteUrl = "https://${Token}@github.com/${Username}/${RepoName}.git"
    Write-Host "Используется HTTPS с Personal Access Token" -ForegroundColor Green
}
else {
    # SSH
    $remoteUrl = "git@github.com:${Username}/${RepoName}.git"
    Write-Host "Используется SSH" -ForegroundColor Green
}

# Удалить старый remote если существует
git remote remove origin 2>$null

# Добавить новый remote
git remote add origin $remoteUrl

Write-Host "✓ Remote добавлен: $remoteUrl" -ForegroundColor Green

Write-Host ""
Write-Host "[4/4] Загрузка на GitHub..." -ForegroundColor Yellow
Write-Host "Это может занять минуту..." -ForegroundColor Gray

# Убедиться что на main ветке
git branch -M main

# Push
try {
    git push -u origin main
    Write-Host ""
    Write-Host "====================================== " -ForegroundColor Green
    Write-Host "✓ УСПЕШНО ЗАГРУЖЕНО!               " -ForegroundColor Green
    Write-Host "====================================== " -ForegroundColor Green
    Write-Host ""
    Write-Host "Ваш репозиторий:" -ForegroundColor Cyan
    Write-Host "https://github.com/${Username}/${RepoName}" -ForegroundColor Cyan
    Write-Host ""
    
    # Предложить открыть в браузере
    $open = Read-Host "Открыть в браузере? (y/n)"
    if ($open -eq "y" -or $open -eq "Y") {
        Start-Process "https://github.com/${Username}/${RepoName}"
    }
}
catch {
    Write-Host ""
    Write-Host "❌ ОШИБКА при загрузке:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Возможные причины:" -ForegroundColor Yellow
    Write-Host "1. Неверный GitHub username или токен" -ForegroundColor Yellow
    Write-Host "2. SSH ключ не настроен (для SSH режима)" -ForegroundColor Yellow
    Write-Host "3. Репозиторий ещё не создан на GitHub" -ForegroundColor Yellow
}
