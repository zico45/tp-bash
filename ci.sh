#!/bin/bash
set -Eeuo pipefail

# Argument 1 : URL du dépôt à tester
URL="${1:-}"
if [ -z "$URL" ]; then
    echo "Usage : $0 <url_du_depot>" >&2
    exit 1
fi

DEPOT_DIR="ci_workspace"
LOG="ci.log"

# Fonction de journalisation horodatée (écran + fichier)
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

# Étape 1 : cloner ou mettre à jour
recuperer_depot() {
    if [ -d "$DEPOT_DIR/.git" ]; then
        log "Mise à jour du dépôt..."
        git -C "$DEPOT_DIR" pull
    else
        log "Clonage du dépôt..."
        git clone "$URL" "$DEPOT_DIR"
    fi
}

# Étape 2 : "tests" simulés
lancer_tests() {
    log "Exécution des tests..."
    if [ ! -d "$DEPOT_DIR" ] || [ -z "$(ls -A "$DEPOT_DIR")" ]; then
        log "ECHEC : dépôt vide ou absent."
        return 1
    fi
    for script in "$DEPOT_DIR"/*.sh; do
        [ -e "$script" ] || continue
        if bash -n "$script"; then
            log "OK : syntaxe de $script"
        else
            log "ECHEC : syntaxe de $script"
            return 1
        fi
    done
    return 0
}

log "=== Début du pipeline ==="
recuperer_depot

if lancer_tests; then
    log "=== Pipeline réussi ==="
    exit 0
else
    log "=== Pipeline en échec ==="
    exit 1
fi
