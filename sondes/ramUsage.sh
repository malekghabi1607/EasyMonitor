#!/bin/bash

# Ce script affiche l'utilisation de la RAM en pourcentage.

# "free -m" donne les infos mémoire en Mo
# On extrait les lignes contenant "Mem:"
# awk calcule le % utilisé : (used / total) * 100

read total used <<< $(free -m | awk '/Mem:/ {print $2, $3}')
ram_usage=$(( 100 * used / total ))

# Affichage
echo "RAM Usage: $ram_usage %"
