#!/usr/bin/env python3

max_lignes = 100
fichier = "sondes/data.json"

try:
    with open(fichier, "r") as f:
        lignes = f.readlines()

    if len(lignes) > max_lignes:
        lignes = lignes[-max_lignes:]

    with open(fichier, "w") as f:
        f.writelines(lignes)

    print(f"✅ {fichier} nettoyé – {len(lignes)} lignes conservées.")

except FileNotFoundError:
    print("❌ Fichier data.json introuvable.")
