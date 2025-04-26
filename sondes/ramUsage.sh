#!/bin/bash

# -------------------------------------------------------------------
# Script : ramUsage.sh
# Projet : EasyMonitor
# Auteur : Malek
# Rôle : Ce script récupère l'utilisation de la mémoire RAM 
#        et l'affiche uniquement en pourcentage numérique (exemple : 32)
#        Ce résultat sera stocké dans la base par insertData.sh
# -------------------------------------------------------------------

# La commande "free -m" permet d'afficher les informations mémoire en Mo (MegaOctets).
# On récupère les valeurs Totales et Utilisées de la RAM (colonnes 2 et 3)
# awk permet d'extraire uniquement ces colonnes.

#!/bin/bash

ram_usage=$(free | awk '/Mem/ {printf("%.2f", $3/$2 * 100)}')
echo "$ram_usage"
