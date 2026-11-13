# Réponses aux questions de réflexion

## Exercice 2.1
**Que donne `chmod 644` sur un fichier ? Est-il exécutable par son propriétaire ?**

`chmod 644` donne `rw-r--r--` : le propriétaire peut lire et écrire (6 = 4+2), le groupe et les autres peuvent seulement lire (4). Le fichier n'est pas exécutable par son propriétaire, car il n'a pas le droit `x` (valeur 1). Un `./test.sh` donne « Permission denied ».

## Exercice 2.2
**Pourquoi utilise-t-on des guillemets autour de `"$UTILISATION"` dans le test `if` ?**

Pour que le test reçoive toujours un argument, même si la variable est vide ou contient des espaces. Sans guillemets, une variable vide disparaît et la commande devient `[ -ge 80 ]`, ce qui provoque l'erreur « unary operator expected ». Avec les guillemets, la syntaxe du test reste correcte.

## Exercice 2.3
**Que se passe-t-il si on enlève `set -Eeuo pipefail` et que `tar` échoue ? Le script continue-t-il à tort ?**

Oui, le script continue à tort. Sans `set -e`, Bash ignore l'échec de `tar` et exécute la suite : il affiche « Archive créée » et « Sauvegarde terminée » alors que la sauvegarde n'existe pas ou est incomplète. Avec `set -Eeuo pipefail`, le script s'arrête dès l'erreur avec un code de retour non nul, ce qui évite de croire à tort que la sauvegarde a réussi.

## Exercice 2.4
**Pourquoi cron nécessite-t-il des chemins absolus ?**

Cron ne lance pas la commande depuis le dossier du projet (en général depuis le dossier personnel) et son `PATH` est très réduit. Les chemins relatifs comme `./backup.sh` ou `data` sont donc introuvables. Avec des chemins absolus (`/home/zakari/tp-bash/backup.sh`), la commande fonctionne quel que soit le dossier de départ.

## Exercice 2.5
**Quelles étapes ajouter pour un vrai pipeline CI ? Quels points de défaillance gérer ?**

Étapes à ajouter : déclenchement automatique (webhook à chaque push, ou cron), installation des dépendances, vrais tests (unitaires, qualité du code), build, déploiement, notifications (mail, Slack) et conservation des logs.

Points de défaillance à gérer avec des codes de retour : échec réseau ou authentification lors du `git clone`/`git pull`, dépôt vide ou introuvable, dépendances impossibles à installer, tests en échec, build en échec, droits insuffisants, manque d'espace disque. Chaque étape doit renvoyer un code non nul (`exit 1`) en cas d'erreur pour arrêter le pipeline et signaler l'échec.
