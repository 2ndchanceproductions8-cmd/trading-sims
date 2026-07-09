# Publishes the latest trading dashboards to the public GitHub Pages site.
# Called automatically at the end of each bot run. Safe to run by hand too.
$ErrorActionPreference = "Stop"
$site   = "C:\Users\Justin\Projects\trading-sims-site"
$sources = @{
    "daytrader.html" = "C:\Users\Justin\Projects\daytrader-sim\dashboard.html"
    "scout.html"     = "C:\Users\Justin\Projects\trading-scout\dashboard.html"
}

Set-Location $site

# Not launched yet? Skip quietly so bot runs don't error before the site exists.
git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) { Write-Host "Site not launched yet; skipping publish."; exit 0 }
git remote get-url origin *> $null
if ($LASTEXITCODE -ne 0) { Write-Host "No remote yet; skipping publish."; exit 0 }

$changed = $false

foreach ($name in $sources.Keys) {
    $src = $sources[$name]
    if (-not (Test-Path $src)) { Write-Host "skip $name (source not found)"; continue }
    $html = Get-Content $src -Raw
    # Inject a noindex tag so search engines don't list the dashboards.
    if ($html -notmatch 'name="robots"') {
        $html = $html -replace '(?i)<head>', '<head><meta name="robots" content="noindex, nofollow">'
    }
    $dest = Join-Path $site $name
    $existing = if (Test-Path $dest) { Get-Content $dest -Raw } else { "" }
    if ($html -ne $existing) {
        Set-Content -Path $dest -Value $html -Encoding UTF8
        $changed = $true
        Write-Host "updated $name"
    }
}

if (-not $changed) { Write-Host "No dashboard changes; nothing to publish."; exit 0 }

git add -A
$stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Update dashboards $stamp" | Out-Null
git push origin main | Out-Null
Write-Host "Published to GitHub Pages at $stamp."
