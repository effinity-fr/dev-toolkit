param(
    [Parameter(Mandatory=$true)]$projectName,
    [Parameter(Mandatory=$true)]$instanceName,
    [Parameter(Mandatory=$true)]$zone = "europe-west1-c",
    [Parameter(Mandatory=$false)]$localPort = "7000"
)

Write-Host "--- Connexion Sécurisée GCP : $instanceName ---" -ForegroundColor Cyan

# 1. Vérification gcloud
if (!(Get-Command gcloud -ErrorAction SilentlyContinue)) {
    Write-Host "ERREUR : Google Cloud SDK non détecté." -ForegroundColor Red
    Pause; exit
}

# 2. Authentification
$authCheck = gcloud auth list --filter=status:ACTIVE --format="value(account)"
if (!$authCheck) {
    Write-Host "Connexion Google requise..." -ForegroundColor Yellow
    gcloud auth login
}

# 3. Ouverture du tunnel IAP (en arrière-plan)
Write-Host "Ouverture du tunnel sur localhost:$localPort..." -ForegroundColor Cyan
$processArgs = "compute start-iap-tunnel $instanceName 3389 --zone=$zone --project=$projectName --local-host-port=localhost:$localPort"
Start-Process gcloud -ArgumentList $processArgs -NoNewWindow

# 4. Lancement RDP
Write-Host "Lancement de la session RDP dans 3 secondes..." -ForegroundColor Green
Start-Sleep -Seconds 3
mstsc.exe /v:localhost:$localPort
