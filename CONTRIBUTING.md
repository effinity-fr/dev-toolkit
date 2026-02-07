# 🤝 Contribuer au Dev-Toolkit Effinity

Merci de l'intérêt que vous portez à l'amélioration de nos outils ! Nous encourageons les contributions pour rendre cet environnement de développement encore plus robuste.

## 📋 Comment contribuer ?

### 1. Rapporter un Bug
Si vous trouvez un bug (particulièrement sur un OS spécifique), merci de créer une **Issue** en précisant :
* Votre système d'exploitation et sa version.
* La version de `gcloud` et `gh` installée.
* Le message d'erreur complet du terminal.

### 2. Proposer une Amélioration
1. **Forkez** le repository.
2. Créez une branche descriptive (`git checkout -b feature/nom-de-votre-idee`).
3. Testez votre modification sur votre machine.
4. Soumettez une **Pull Request** vers la branche `main`.

---

## 🛠️ Règles de Code (Bash)

Pour maintenir ce toolkit propre et facile à maintenir, nous suivons ces principes :

* **Modularité** : Si vous ajoutez une nouvelle fonctionnalité, essayez de la rendre optionnelle ou de l'isoler dans une fonction.
* **Sécurité** : 
    * Utilisez `set -e` pour arrêter le script en cas d'erreur.
    * Ne mettez **jamais** de secrets, de tokens ou d'identifiants en dur.
    * Préférez l'usage de variables d'environnement ou de saisies utilisateur.
* **Compatibilité** : Vérifiez que vos commandes fonctionnent sur **macOS** et **Linux (Debian/Ubuntu)**. Pour Windows, testez dans **Git Bash**.
* **Style** : Utilisez des commentaires clairs pour chaque bloc de code complexe.

---

## 🧪 Tester vos modifications

Avant de soumettre une PR, vérifiez que le script principal s'exécute sans erreur de syntaxe :

```bash
bash -n nom_du_script.sh