#!/bin/bash

# Ce script retourne l'utilisation actuelle du CPU en pourcentage.

# La commande "top" permet de surveiller les ressources du système.
# On utilise ici "grep" pour extraire la ligne contenant "Cpu(s)"
# Ensuite, "awk" sert à extraire la valeur d'utilisation.

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Affichage du résultat
echo "CPU Usage: $cpu_usage %"
