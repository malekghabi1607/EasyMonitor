#!/bin/bash

# Ce script affiche le nombre d'utilisateurs actuellement connectés

# "who" affiche les utilisateurs connectés
# "wc -l" compte le nombre de lignes = nombre d'utilisateurs

user_count=$(who | wc -l)

# Affichage
echo "Connected Users: $user_count"
