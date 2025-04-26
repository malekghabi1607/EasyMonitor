#!/usr/bin/env python3

# -------------------------------------------------------------------
# Script : cleanData.py
# Projet : EasyMonitor
# Auteur : Malek
# Rôle : Supprimer les anciennes données de la base SQLite
#        Gérer un historique propre (7 jours par exemple)
# -------------------------------------------------------------------

import sqlite3

# Connexion à la base de données
db_path = "./DB/stockage.db"
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

print("Nettoyage des anciennes données en cours...")

# Suppression des anciennes données dans la table monitoring (> 7 jours)
cursor.execute("DELETE FROM monitoring WHERE date_heure_scan < datetime('now', '-7 days')")

# Suppression des anciennes alertes CERT (> 30 jours par exemple)
cursor.execute("DELETE FROM cert_alerts WHERE date < date('now', '-30 days')")

# Valider les modifications
conn.commit()

print("Nettoyage terminé avec succès.")

# Fermer la connexion
conn.close()
