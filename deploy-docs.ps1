Write-Host "Building MkDocs site..." -ForegroundColor Cyan

mkdocs build

if ($LASTEXITCODE -ne 0) {
    Write-Host "MkDocs build failed." -ForegroundColor Red
    exit 1
}

Write-Host "Adding changes..." -ForegroundColor Cyan
git add .

Write-Host "Committing changes..." -ForegroundColor Cyan
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "docs update $timestamp"

Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
git push

Write-Host "Deploying to GitHub Pages..." -ForegroundColor Cyan
mkdocs gh-deploy

Write-Host "Deployment complete!" -ForegroundColor Green