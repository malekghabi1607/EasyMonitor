#!/bin/bash

# -------------------------------------------------------
# Script : testSondes.sh
# Auteur : Malek
# Rôle : Tester toutes les sondes avec affichage clair dans le terminal
# -------------------------------------------------------

SONDES_DIR="/home/malek/EasyMonitor/sondes"

# Récupérer les valeurs des sondes
RAM=$(bash $SONDES_DIR/ramUsage.sh)
CPU=$(bash $SONDES_DIR/cpuUsage.sh)
DISK=$(bash $SONDES_DIR/diskUsage.sh)
USERS=$(bash $SONDES_DIR/userCount.sh)
PROCESS=$(python3 $SONDES_DIR/processCount.py)
ALERTE=$(python3 $SONDES_DIR/getCertAlert.py)

echo "========== TEST DES SONDES =========="
echo "[RAM]           => RAM Usage: $RAM %"
echo "[CPU]           => CPU Usage: $CPU %"
echo "[DISQUE]        => Disk Usage: $DISK %"
echo "[UTILISATEURS]  => Connected Users: $USERS"
echo "[PROCESSUS]     => Process Count: $PROCESS"
echo "[ALERTE CERT]   => $ALERTE"
echo "======================================"