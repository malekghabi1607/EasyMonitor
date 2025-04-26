#!/bin/bash

# -------------------------------------------------------------------
# Script : userCount.sh
# Projet : EasyMonitor
# Auteur : Malek
# Rôle : Ce script récupère et affiche le nombre d'utilisateurs 
#        actuellement connectés à la machine.
# -------------------------------------------------------------------

# La commande "who" affiche les utilisateurs connectés.
# "wc -l" compte le nombre de lignes donc le nombre d'utilisateurs.

connected_users=$(who | wc -l)
echo "$connected_users"

