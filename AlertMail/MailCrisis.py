import sqlite3
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def get_config_data():
    conn = sqlite3.connect('DB/stockage.db')
    cursor = conn.cursor()
    cursor.execute('SELECT cpu_threshold, disk_threshold, ram_threshold, user_threshold, process_threshold FROM config ORDER BY id DESC LIMIT 1')
    config_data = cursor.fetchone()
    conn.close()
    return config_data

def get_current_values():
    conn = sqlite3.connect('DB/stockage.db')
    cursor = conn.cursor()
    cursor.execute('SELECT cpuUsage, diskUsage, processCount, ramUsage, userCount FROM monitoring ORDER BY id DESC LIMIT 1')
    monitoring_data = cursor.fetchone()  # Utiliser fetchone() au lieu de fetchall()
    conn.close()
    return monitoring_data

# crisisState est un dictionnaire qui contient les valeurs actuelles et un booléen indiquant si la valeur actuelle dépasse le seuil critique(=True) ou non(=False)
def check_thresholds(current_values, config_values):
    crisisState = {
        "CPU": (current_values[0], current_values[0] > config_values[0]),
        "Disk": (current_values[1], current_values[1] > config_values[1]),
        "Process": (current_values[2], current_values[2] > config_values[4]),
        "RAM": (current_values[3], current_values[3] > config_values[2]),
        "User": (current_values[4], current_values[4] > config_values[3])
    }
    return crisisState

def sendAlertMail(crisisState):
    smtp_server = "smtp.gmail.com"
    smtp_port = 465
    smtp_username = "malekghabi129@gmail.com"
    smtp_password = "umzz apxv wulk tmik"
    receiver_email = "malekghabi129@gmail.com"


    message = MIMEMultipart()
    message["From"] = smtp_username
    message["To"] = receiver_email
    message["Subject"] = "Alerte de monitoring"

    # Corps du message
    body = "Problèmes rencontrés :\n" + "\n".join([f"{k}: {v[0]} (Seuil critique: {v[1]})" for k, v in crisisState.items() if v[1]]) 
    message.attach(MIMEText(body, "plain"))

    # Envoi de l'e-mail
    try:
        with smtplib.SMTP_SSL(smtp_server, smtp_port) as server:
            server.login(smtp_username, smtp_password)
            server.sendmail(smtp_username, receiver_email, message.as_string())
        print("E-mail d'alerte envoyé avec succès.")
    except Exception as e:
        print("Une erreur s'est produite lors de l'envoi de l'e-mail d'alerte:", e)

if __name__ == "__main__":
    config_data = get_config_data()
    current_values = get_current_values()

    if config_data and current_values:
        crisisState = check_thresholds(current_values, config_data)
        #verifier si une des valeurs actuelles dépasse le seuil critique
        if any([v[1] for v in crisisState.values()]):sendAlertMail(crisisState)
    else:
        print("Impossible de récupérer les données actuelles ou de configuration.")
