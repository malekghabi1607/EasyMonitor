import sqlite3

def create_config_table(cursor):
    cursor.execute('''CREATE TABLE IF NOT EXISTS config (
                        id INTEGER PRIMARY KEY,
                        cpu_threshold REAL,
                        disk_threshold REAL,
                        ram_threshold REAL,
                        user_threshold INTEGER,
                        process_threshold INTEGER,
                        history_threshold INTEGER
                      )''')

def insert_config_thresholds(cursor, thresholds):
    cursor.execute('''INSERT INTO config (cpu_threshold, disk_threshold, ram_threshold, 
                      user_threshold, process_threshold, history_threshold) 
                      VALUES (?, ?, ?, ?, ?, ?)''', thresholds)

def get_critical_thresholds():
    thresholds = []

    cpu_threshold = float(input("A partir de quel pourcentage d'utilisation CPU la situation est critique ? "))
    thresholds.append(cpu_threshold)

    disk_threshold = float(input("A partir de quel pourcentage d'utilisation du disque la situation est critique ? "))
    thresholds.append(disk_threshold)

    ram_threshold = float(input("A partir de quel pourcentage d'utilisation de la RAM la situation est critique ? "))
    thresholds.append(ram_threshold)

    user_threshold = int(input("A partir de combien d'utilisateurs connectés la situation est critique ? "))
    thresholds.append(user_threshold)

    process_threshold = int(input("A partir de combien de processus en cours d'exécution la situation est critique ? "))
    thresholds.append(process_threshold)

    history_threshold = int(input("Combien de minutes d'historique voulez-vous conserver dans les graphiques ? "))
    thresholds.append(history_threshold)

    return thresholds

if __name__ == "__main__":
    conn = sqlite3.connect('DB/stockage.db')
    cursor = conn.cursor()
    create_config_table(cursor)
    critical_thresholds = get_critical_thresholds()
    insert_config_thresholds(cursor, critical_thresholds)
    conn.commit()
    conn.close()
    print("Seuils critiques enregistrés avec succès dans la base de données.")
