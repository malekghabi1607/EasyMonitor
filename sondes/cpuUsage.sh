#!/bin/bash

# -------------------------------------------------------------------
# Script : cpuUsage.sh
# Projet : EasyMonitor
# Auteur : Malek
# Rôle : Récupère le pourcentage total du CPU (user + system)
#        Retourne un entier sans symbole pour insertion en base
# -------------------------------------------------------------------
#!/bin/bash

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
echo "$cpu_usage"