#!/bin/bash

# Ce script affiche le pourcentage d'utilisation du disque dur principal (/)

# "df" donne l’espace disque disponible et utilisé.
# "-h" = format lisible (ex: Go)
# "/" = on cible la racine du système
# "tail -1" = on saute l’en-tête
# "awk '{print $5}'" = on récupère la 5e colonne = pourcentage utilisé

disk_usage=$(df -h / | tail -1 | awk '{print $5}')

# Affichage
echo "Disk Usage: $disk_usage"
