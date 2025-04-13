#!/usr/bin/env python3

# Ce script retourne le nombre total de processus actifs

import psutil  # psutil est une bibliothèque qui donne accès aux infos système

# On utilise psutil.pids() pour obtenir la liste de tous les PIDs (IDs de processus)
process_count = len(psutil.pids())

# Affichage
print(f"Process Count: {process_count}")
