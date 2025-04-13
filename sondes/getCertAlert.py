#!/usr/bin/env python3
import requests # type: ignore
from bs4 import BeautifulSoup # type: ignore
import sqlite3

# Fonction pour récupérer les infos d'une alerte CERT
def get_cert_alert_info(alert):
    date = alert.find(class_='item-date').text.strip()
    ref = alert.find(class_='item-ref').text.strip()
    title = alert.find(class_='item-title').text.strip()
    status = alert.find(class_='item-status').text.strip()
    return date, ref, title, status

# Récupérer le contenu de la page
url = "https://www.cert.ssi.gouv.fr/"
response = requests.get(url)
soup = BeautifulSoup(response.content, "html.parser")

# Connexion à la base SQLite
conn = sqlite3.connect('DB/stockage.db')
cursor = conn.cursor()

cursor.execute('''CREATE TABLE IF NOT EXISTS cert_alerts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    ref TEXT UNIQUE,
    title TEXT,
    status TEXT
)''')

# Récupérer la première alerte
alert = soup.select_one('.item.cert-alert')
if alert:
    date, ref, title, status = get_cert_alert_info(alert)
    cursor.execute("SELECT ref FROM cert_alerts WHERE ref=?", (ref,))
    if cursor.fetchone() is None:
        cursor.execute("INSERT INTO cert_alerts (date, ref, title, status) VALUES (?, ?, ?, ?)", (date, ref, title, status))
        print(f"✅ Nouvelle alerte ajoutée : {ref}")
    else:
        print("🔁 Aucune nouvelle alerte.")

conn.commit()
conn.close()
