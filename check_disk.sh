#!/bin/bash

# Seuil : premier argument, ou 80 par défaut
SEUIL=${1:-80}

# Pourcentage d'utilisation de la partition racine
UTILISATION=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : espace disque utilisé à ${UTILISATION}% (seuil : ${SEUIL}%)"
    exit 1
else
    echo "OK : espace disque utilisé à ${UTILISATION}% (seuil : ${SEUIL}%)"
    exit 0
fi
