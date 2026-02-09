# 🚀 Environnement de Développement ADK

Ce dépôt contient le script d'automatisation permettant de configurer un environnement de développement standardisé Python ADK chez **Effinity**.

## 📋 Ce que fait ce script

Le script `setup_dev_adk_python.sh` installe et configure :

* **[uv](https://astral.sh/uv/)** : Gestionnaire Python ultra-rapide.
* **GitHub CLI (`gh`)** : Authentification simplifiée sans clés SSH.
* **Cookiecutter** : Générateur de projets via templates.
* **GCP Impersonation** : Accès sécurisé à Google Cloud sans fichiers de clés JSON.

---

## 🛠️ Installation et Exécution

### 1. Pré-requis

* **macOS / Linux** : Avoir `curl` et `git` installés.
* **Windows** : Utilisez **Git Bash** (inclus avec Git for Windows) pour exécuter le script `.sh`.
* **GCP** : Le [gcloud CLI](https://cloud.google.com/sdk/docs/install) doit être installé sur votre machine.

#### Méthode rapide (Recommandée)

Ouvrez votre terminal (ou Git Bash sur Windows) et lancez cette commande pour exécuter le script directement sans cloner le dépôt :

```bash
curl -sSL https://raw.githubusercontent.com/effinity-fr/dev-toolkit/refs/heads/main/python/adk/setup_dev_adk_python.sh | bash

```

#### Méthode manuelle

Si vous préférez cloner le dépôt pour explorer les scripts :

```bash
git clone https://github.com/effinity-fr/dev-toolkit.git
cd dev-toolkit/python/adk/
chmod +x setup_dev_adk_python.sh
./setup_dev_adk_python.sh

```

---

### ⚠️ Note importante pour l'exécution directe

L'utilisation de `curl | bash` est très pratique, mais voici deux points à garder en tête :

1. **Windows** : Cette commande fonctionne parfaitement dans **Git Bash**. Dans un PowerShell classique, la syntaxe serait différente, il est donc fortement conseillé d'utiliser l'environnement Git Bash.
2. **Droits** : Si le script doit installer des paquets système (via `apt` ou `brew`), il pourra demander votre mot de passe administrateur en cours de route.


### 2. Lancer le script

**Sur macOS et Linux :**

```bash
chmod +x setup_dev_adk_python.sh
./setup_dev_adk_python.sh

```

**Sur Windows (via Git Bash) :**

```bash
./setup_dev_adk_python.sh

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

## 🔒 Sécurité et Confidentialité

* **Transparence** : Le script est open-source. Nous vous encourageons à lire le contenu de `setup.sh` avant exécution pour comprendre les modifications apportées à votre système.
* **Données sensibles** : Le script ne stocke aucun mot de passe. L'authentification GitHub et GCP se fait via les flux officiels (`gh auth` et `gcloud auth`) utilisant votre navigateur.
* **Impersonation** : L'accès aux ressources GCP ne se fait pas via des clés statiques, mais par impersonation de compte de service, révocable à tout moment par l'administrateur.

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


* Relancez ensuite le script `./setup_dev_adk_python.sh`.

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
