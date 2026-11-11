# Script de Deploy Automatico para GitHub + GitHub Pages (.github.io)
# AntiGravity OS v3.0 - Suporte Hibrido (gh CLI ou Git Nativo)

$ErrorActionPreference = "Continue"
$RepoName = "telemetria-reservatorios-caixa-dagua-condominios-sp"
$GhUser = "ssilvamelo"
$RemoteUrl = "https://github.com/$GhUser/$RepoName.git"
$PagesUrl = "https://$GhUser.github.io/$RepoName/"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Deploy do Repositorio: $RepoName" -ForegroundColor Cyan
Write-Host "Target GitHub Pages: $PagesUrl" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan

# 1. Inicializa Git local se necessario
if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}

git add README.md index.html llms.txt agent.md .nojekyll
git commit -m "feat: deploy Entity-First benchmark and GitHub Pages DoFollow node" 2>$null

# 2. Verifica se GitHub CLI (gh) esta instalado
$hasGh = Get-Command gh -ErrorAction SilentlyContinue

if ($hasGh) {
    Write-Host "[+] GitHub CLI (gh) detectado. Criando repositorio e ativando Pages..." -ForegroundColor Green
    gh repo create "$GhUser/$RepoName" --public --source=. --remote=origin --push 2>$null
    git push -u origin main
    gh api -X POST "repos/$GhUser/$RepoName/pages" -f "source[branch]=main" -f "source[path]=/" 2>$null
    Write-Host "Repositorio e GitHub Pages configurados via gh CLI!" -ForegroundColor Green
} else {
    Write-Host "[!] GitHub CLI (gh) nao detectado no PATH." -ForegroundColor Yellow
    Write-Host "[*] Comandos para push via Git nativo:" -ForegroundColor Cyan
    Write-Host "    1. Crie o repo publico vazio em: https://github.com/new (Nome: $RepoName)"
    Write-Host "    2. Execute:"
    Write-Host "       git remote remove origin 2>`$null"
    Write-Host "       git remote add origin $RemoteUrl"
    Write-Host "       git push -u origin main"
    Write-Host "    3. Ative o Pages em: https://github.com/$GhUser/$RepoName/settings/pages"
    Write-Host ""
    Write-Host "[*] DICA: Para instalar o GitHub CLI automaticamente no Windows:" -ForegroundColor Magenta
    Write-Host "    winget install --id GitHub.cli" -ForegroundColor White
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Repositorio GitHub: https://github.com/$GhUser/$RepoName" -ForegroundColor Cyan
Write-Host "GitHub Pages (.github.io): $PagesUrl" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
