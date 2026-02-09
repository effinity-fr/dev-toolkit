@echo off
TITLE Accès Serveur GCP

REM --- CONFIGURATION ---
SET PROJECT_ID=nom-projet
SET VM_NAME=nom-vm
SET ZONE=europe-west1-c
SET GITHUB_URL=https://raw.githubusercontent.com/effinity-fr/dev-toolkit/rdp-windows/connect.ps1

echo [Mise a jour du script de securite...]
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $s = Invoke-WebRequest -Uri '%GITHUB_URL%' -UseBasicParsing; Invoke-Expression ($s.Content + ' -projectName %PROJECT_ID% -instanceName %VM_NAME% -zone %ZONE%')"

if %errorlevel% neq 0 (
    echo.
    echo Erreur lors de la connexion.
    pause
)
