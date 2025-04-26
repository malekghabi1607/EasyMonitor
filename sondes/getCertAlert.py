#!/usr/bin/env python3

# -------------------------------------------------------------------
# Script : getCertAlert.py
# Projet : EasyMonitor
# Auteur : Malek
# Rôle : Récupérer les dernières alertes CERT-FR
#        et les insérer dans la base cert_alerts si elles sont nouvelles
# -------------------------------------------------------------------

import requests
from bs4 import BeautifulSoup
import sqlite3

# Fonction pour extraire les infos d'une alerte
def get_cert_alert_info(alert):
    date = alert.find(class_='item-date').text.strip()
    ref = alert.find(class_='item-ref').text.strip()
    title = alert.find(class_='item-title').text.strip()
    status = alert.find(class_='item-status').text.strip()
    return date, ref, title, status

# URL officielle
url = "http://www.cert.ssi.gouv.fr/"

# Récupération du contenu HTML
response = requests.get(url)
html_content = response.content
soup = BeautifulSoup(html_content, "html.parser")

# Connexion à la base (chemin absolu recommandé)
conn = sqlite3.connect("/home/malek/EasyMonitor/DB/stockage.db")
cursor = conn.cursor()

# Créer la table cert_alerts si elle n'existe pas
cursor.execute('''
    CREATE TABLE IF NOT EXISTS cert_alerts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        ref TEXT UNIQUE,
        title TEXT,
        status TEXT
    )
''')

# Initialiser le compteur de nouvelles alertes
new_alerts = 0

# Récupérer les blocs contenant les alertes
alerts = soup.select('.item.cert-alert')

for alert in alerts:
    date, ref, title, status = get_cert_alert_info(alert)
    
    # Vérifier si l’alerte existe déjà
    cursor.execute("SELECT ref FROM cert_alerts WHERE ref = ?", (ref,))
    existing_alert = cursor.fetchone()
    
    if existing_alert is None:
        cursor.execute("INSERT INTO cert_alerts (date, ref, title, status) VALUES (?, ?, ?, ?)", (date, ref, title, status))
        print(f"✅ Alerte insérée : {ref}")
        new_alerts += 1

# Feedback utilisateur clair
if new_alerts == 0:
    print("🔁 Aucune nouvelle alerte.")

# Sauvegarde et fermeture
conn.commit()
conn.close()