#!/usr/bin/env python3

# -------------------------------------------------------------------
# Script : processCount.py
# Projet : EasyMonitor
# Auteur : Malek
# Rôle : Ce script utilise la bibliothèque psutil pour compter
#        le nombre de processus actifs sur la machine.
# -------------------------------------------------------------------
import psutil

pids = psutil.pids()

process_count = len(pids)
print(process_count)