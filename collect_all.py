#!/usr/bin/env python3
import subprocess
import json
from datetime import datetime

# Fonction pour exécuter un script et récupérer son résultat
def run_script(script):
    return subprocess.check_output(script, shell=True).decode().strip()

# Dictionnaire avec les résultats
data = {
    "timestamp": datetime.now().isoformat(),
    "cpu": run_script("bash sondes/cpuUsage.sh"),
    "ram": run_script("bash sondes/ramUsage.sh"),
    "disk": run_script("bash sondes/diskUsage.sh"),
    "users": run_script("bash sondes/userCount.sh"),
    "processes": run_script("python3 sondes/processCount.py")
}

# Enregistrer dans data.json
with open("sondes/data.json", "a") as f:
    f.write(json.dumps(data) + "\n")

print("✅ Données enregistrées dans sondes/data.json")
