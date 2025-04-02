import requests
from bs4 import BeautifulSoup
import sqlite3

# Fonction pour récupérer les informations d'une alerte CERT
def get_cert_alert_info(alert):
    date = alert.find(class_='item-date').text.strip()
    ref = alert.find(class_='item-ref').text.strip()
    title = alert.find(class_='item-title').text.strip()
    status = alert.find(class_='item-status').text.strip()
    return date, ref, title, status

url = "http://www.cert.ssi.gouv.fr/"

# Récupération du contenu HTML de la page
response = requests.get(url)
html_content = response.content

soup = BeautifulSoup(html_content, "html.parser")

conn = sqlite3.connect('DB/stockage.db')
cursor = conn.cursor()

cursor.execute('''CREATE TABLE IF NOT EXISTS cert_alerts (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    date TEXT,
                    ref TEXT UNIQUE,
                    title TEXT,
                    status TEXT
                )''')

# Récupération des éléments contenant les alertes
alerts = soup.select('.item.cert-alert')

for alert in alerts:
    date, ref, title, status = get_cert_alert_info(alert)
    
    # Vérification si l'alerte existe déjà dans la base de données par la référence
    cursor.execute("SELECT ref FROM cert_alerts WHERE ref=?", (ref,))
    existing_alert = cursor.fetchone()
    
    if existing_alert is None:
        cursor.execute("INSERT INTO cert_alerts (date, ref, title, status) VALUES (?, ?, ?, ?)", (date, ref, title, status))
        print(f"Alerte insérée : {ref}")
    
conn.commit()
conn.close()
