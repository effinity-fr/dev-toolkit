# 🛠 GCP Dev-Toolkit - Accès Sécurisé RDP

---

## 🚀 Guide de démarrage (Utilisateur)

### 1. Pré-requis

Une seule fois sur votre poste, installez le **Google Cloud SDK** :

* [Télécharger l'installeur Windows](https://cloud.google.com/sdk/docs/install?hl=fr)
* Lancez l'installation et suivez les instructions. À la fin, une fenêtre s'ouvre, tapez `Y` pour vous connecter avec votre email Effinity.

### 2. Installation du raccourci

1. Récupérez le fichier `launcher.bat` dans de dépôt.
2. Placez-le sur votre **Bureau**.
3. **Double-cliquez** sur le fichier pour lancer la session.

> **Note :** La première fois, une fenêtre de navigateur peut s'ouvrir pour confirmer votre identité.

---

## 🎨 Personnalisation : Changer l'icône du raccourci

Pour éviter d'avoir une icône d'engrenage générique sur votre bureau, suivez ces étapes :

1. Faites un **clic droit** sur votre fichier `launcher.bat`.
2. Choisissez **Envoyer vers** > **Bureau (créer un raccourci)**.
3. Allez sur votre bureau, faites un **clic droit sur le nouveau raccourci** créé.
4. Cliquez sur **Propriétés**.
5. Dans l'onglet "Raccourci", cliquez sur le bouton **Changer d'icône...**.
6. *Note : Un message d'avertissement peut apparaître, cliquez sur OK.*
7. Choisissez une icône (par exemple le petit écran bleu ou le serveur) et validez par **OK**.
8. Renommez le raccourci en "Accès SQL Compta".

---

## 🛠 Administration (Pour les Devs/Ops)

### Structure du projet

* `connect.ps1` : Le moteur PowerShell. Il gère l'auth, le tunnel IAP et le lancement de MSTSC.
* `*.bat` : Scripts d'appel légers qui injectent les variables (Project ID, VM Name, Zone).

### Ajouter un nouvel accès

Pour créer un accès à une nouvelle machine (ex: Staging) :

1. Créez un nouveau fichier `.bat`.
2. Modifiez les variables au début du fichier :
```batch
SET PROJECT_ID=votre-projet-staging
SET VM_NAME=vm-web-staging
SET ZONE=europe-west1-b

```


3. Distribuez ce `.bat` aux personnes concernées.

### Troubleshooting

* **Erreur "IAP Permission Denied"** : Contacter l'équipe techique.
* **Script bloqué** : Si PowerShell bloque l'exécution, le `.bat` utilise déjà `-ExecutionPolicy Bypass`, ce qui devrait régler le problème dans 99% des cas.
