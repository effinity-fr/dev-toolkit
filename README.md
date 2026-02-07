# 🚀 Environnement de Développement ADK

Ce dépôt contient le script d'automatisation permettant de configurer un environnement de développement standardisé chez **Effinity**.

## 📋 Ce que fait ce script

Le script `setup.sh` installe et configure :

* **[uv](https://www.google.com/search?q=https://astral.sh/uv/)** : Gestionnaire Python ultra-rapide.
* **GitHub CLI (`gh`)** : Authentification simplifiée sans clés SSH.
* **Cookiecutter** : Générateur de projets via templates.
* **GCP Impersonation** : Accès sécurisé à Google Cloud sans fichiers de clés JSON.

---

## 🛠️ Installation et Exécution

### 1. Pré-requis

* **macOS / Linux** : Avoir `curl` et `git` installés.
* **Windows** : Utilisez **Git Bash** (inclus avec Git for Windows) pour exécuter le script `.sh`.
* **GCP** : Le [gcloud CLI](https://cloud.google.com/sdk/docs/install) doit être installé sur votre machine.

### 2. Lancer le script

**Sur macOS et Linux :**

```bash
chmod +x setup.sh
./setup.sh

```

**Sur Windows (via Git Bash) :**

```bash
./setup.sh

```

*Note : Si vous êtes sous Windows, assurez-vous de lancer Git Bash en tant qu'administrateur pour l'installation des outils.*

---

## 🏗️ Générer un projet (Multi-plateforme)

Une fois le script terminé, utilisez **Cookiecutter** pour importer votre template. La commande est identique sur tous les OS grâce à `uv`.

**Commande universelle :**

```bash
uv tool run cookiecutter https://github.com/effinity-fr/cookiecutter-python-adk

```

---

## 🔐 Authentification Google Cloud (GCP)

Le script configure l'**Impersonation**. Cela signifie que vous utilisez vos identifiants personnels pour agir au nom d'un Service Account (SA) technique.

### Pourquoi l'impersonation ?

* **Pas de fichiers `.json**` : Plus de risque de fuite de clés sur votre disque dur.
* **Traçabilité** : On sait quel humain a utilisé le compte de service.

---

## 🆘 Troubleshooting (Dépannage)

### 🔴 Erreur d'Impersonation GCP

Si vous obtenez une erreur de type `Permission Denied` lors de l'étape GCP :

1. Vérifiez que vous êtes connecté avec le bon compte : `gcloud auth list`.
2. Assurez-vous d'avoir le rôle **"Service Account Token Creator"** sur le compte de service visé.
3. **Action corrective :** Demandez à votre admin de lancer cette commande pour vous :
```bash
gcloud iam service-accounts add-iam-policy-binding [SA_EMAIL] \
  --role="roles/iam.serviceAccountTokenCreator" \
  --member="user:[VOTRE_EMAIL_PRO]"

```



### 🔵 GitHub CLI sur Windows

Si le script ne parvient pas à installer `gh` automatiquement sur Windows :

* Ouvrez **PowerShell** en admin et tapez :
```powershell
winget install --id GitHub.cli

```


* Relancez ensuite le script `./setup.sh`.

### 🟢 Python non trouvé

Si `uv` est installé mais que la commande `python` ne répond pas :

* **macOS/Linux** : `source $HOME/.cargo/env`
* **Windows** : Redémarrez votre terminal Git Bash pour rafraîchir le `PATH`.

---

## 📖 Commandes utiles par OS

| Outil | macOS / Linux | Windows (PowerShell/CMD) |
| --- | --- | --- |
| **Mettre à jour gcloud** | `gcloud components update` | `gcloud components update` |
| **Vérifier l'accès** | `gcloud auth application-default print-access-token` | `gcloud auth application-default print-access-token` |
| **Forcer l'auth GitHub** | `gh auth login` | `gh auth login` |
