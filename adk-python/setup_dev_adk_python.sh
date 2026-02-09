#!/bin/bash

# ==============================================================================
# ⚠️  DISCLAIMER / AVERTISSEMENT
# ==============================================================================
# Ce script est fourni par Effinity pour automatiser l'onboarding technique.
# 
# ACTIONS EFFECTUÉES :
# - Installation d'outils (uv, gh cli, cookiecutter).
# - Configuration locale de Git (user.name, user.email).
# - Authentification GitHub et Google Cloud (Impersonation).
#
# PRÉ-REQUIS :
# - Google Cloud CLI (gcloud) doit être installé.
# - Un compte GitHub actif.
#
# UTILISATION :
# Ce script modifie des configurations locales et installe des binaires.
# L'utilisateur est responsable de l'exécution de ce script sur son poste.
# ==============================================================================

# Empêcher l'exécution si une erreur survient
set -e

echo "🚀 Préparation de l'environnement ADK - Python"

# 1. Détection de l'OS
OS_TYPE="$(uname)"
case "$OS_TYPE" in
    Linux*)     PLATFORM=Linux;;
    Darwin*)    PLATFORM=macOS;;
    CYGWIN*|MINGW*|MSYS*) PLATFORM=Windows;;
    *)          PLATFORM="UNKNOWN"
esac

# 2. Installation de UV (si absent)
if ! command -v uv &> /dev/null; then
    echo "⚡ Installation de 'uv'..."
    if [ "$PLATFORM" = "Windows" ]; then
        powershell.exe -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
        export PATH="$PATH:$HOME/.cargo/bin"
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
        source $HOME/.cargo/env
    fi
else
    echo "✅ 'uv' est déjà présent."
fi

# 3. Configuration de GitHub CLI
echo "🛠️ Configuration de GitHub..."
if ! command -v gh &> /dev/null; then
    echo "📥 Installation de GitHub CLI..."
    if [ "$PLATFORM" = "macOS" ]; then
        brew install gh
    elif [ "$PLATFORM" = "Linux" ]; then
        type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
        && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt update \
        && sudo apt install gh -y
    elif [ "$PLATFORM" = "Windows" ]; then
        echo "⚠️ Merci d'installer GitHub CLI manuellement sur Windows ou via 'winget install --id GitHub.cli'"
    fi
fi

# 4. Vérification de l'authentification GitHub
if ! gh auth status &> /dev/null; then
    echo "🔐 Connexion à GitHub requise..."
    gh auth login -h github.com -p https -w
else
    echo "✅ Déjà authentifié sur GitHub."
fi

# 5. Configuration Git basique si absente
if [ -z "$(git config --global user.email)" ]; then
    read -p "Entrez votre email professionnel GitHub : " GH_EMAIL
    git config --global user.email "$GH_EMAIL"
fi

# 6. Installation de Python via UV
echo "🐍 Configuration de Python via uv..."
uv python install 3.14 --quiet

# 7. Installation de Cookiecutter via UV
echo "📦 Installation de Cookiecutter..."
uv tool install cookiecutter --force

# 8. Authentification GCP avec Impersonation
if ! command -v gcloud &> /dev/null; then
    echo "❌ Erreur : gcloud CLI non trouvé. Merci de l'installer : https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# 9. Saisie utilisateur obligatoire
echo -e "\n🔐 Configuration de l'accès GCP..."
while [[ ! $SA_EMAIL =~ ^[a-z0-9-]+@[a-z0-9-]+\.iam\.gserviceaccount\.com$ ]]; do
    read -p "📧 Entrez l'email du Service Account à impersonner : " SA_EMAIL
    if [[ ! $SA_EMAIL =~ ^[a-z0-9-]+@[a-z0-9-]+\.iam\.gserviceaccount\.com$ ]]; then
        echo "⚠️ Format invalide. L'email doit finir par .iam.gserviceaccount.com"
    fi
done

NEEDS_AUTH=true

# 10. Vérification de l'auth actuelle
if gcloud auth application-default print-access-token &>/dev/null; then
    # On vérifie si l'identité actuelle peut déjà générer un token pour ce SA
    if gcloud auth application-default print-access-token --impersonate-service-account="$SA_EMAIL" &>/dev/null; then
        echo "✅ Authentification GCP déjà active pour $SA_EMAIL."
        NEEDS_AUTH=false
    fi
fi

if [ "$NEEDS_AUTH" = true ]; then
    echo "🔐 Lancement de l'authentification (Navigateur)..."
    # On connecte l'utilisateur et on configure l'impersonation pour l'ADC
    gcloud auth application-default login --impersonate-service-account="$SA_EMAIL"
fi

echo -e "\n---------------------------------------------------"
echo "✨ CONFIGURATION TERMINÉE !"
echo "---------------------------------------------------"