#!/bin/bash
set -Eeuo pipefail

# Dossier à sauvegarder (argument 1, par défaut : data)
DOSSIER="${1:-data}"
DEST="backups"
HORODATAGE=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$DEST/backup_${HORODATAGE}.tar.gz"

# Vérifier que le dossier existe
if [ ! -d "$DOSSIER" ]; then
    echo "Erreur : le dossier '$DOSSIER' n'existe pas." >&2
    exit 1
fi

mkdir -p "$DEST"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Sauvegarde de '$DOSSIER' vers '$ARCHIVE'"
tar -czf "$ARCHIVE" "$DOSSIER"
echo "Archive créée : $ARCHIVE"

# Supprimer les sauvegardes de plus de 7 jours
echo "Nettoyage des sauvegardes de plus de 7 jours..."
for fichier in "$DEST"/backup_*.tar.gz; do
    if [ -n "$(find "$fichier" -mtime +7)" ]; then
        rm "$fichier"
        echo "Supprimé : $fichier"
    fi
done

echo "Sauvegarde terminée."
exit 0
