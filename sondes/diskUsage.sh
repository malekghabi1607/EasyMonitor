#!/bin/bash

# -------------------------------------------------------------------
# Script : diskUsage.sh
# Projet : EasyMonitor
# Auteur : Malek
# Rôle : Ce script récupère et affiche l'utilisation du disque dur
#        principal (partition racine /) en pourcentage.
# -------------------------------------------------------------------

# La commande "df -h" donne les informations sur l'espace disque.
# "-h" = format lisible pour les humains (Go / Mo)
# "/" = cible la partition racine
# "tail -1" saute la première ligne (en-tête)
# "awk '{print $5}'" récupère la 5ème colonne qui correspond au % utilisé.

disk_usage=$(df -h | awk '$NF=="/" {print $5}' | sed 's/%//')
echo "$disk_usage"
