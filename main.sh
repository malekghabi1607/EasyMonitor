#!/bin/bash

# ------------------------------------------------------------------------------
# Script principal : main.sh
# Auteur : Malek
# Rôle : Orchestrer tout le pipeline EasyMonitor :
#        - Lancer les sondes
#        - Enregistrer les données
#        - Créer des sauvegardes
#        - Gérer les alertes CERT
#        - Générer les graphiques
#        - Envoyer des alertes email si crise
# ------------------------------------------------------------------------------

# Toujours commencer dans le dossier du script
cd "$(dirname "$0")"

# Définition des chemins
DB_PATH="./DB/stockage.db"
SONDES_DIR="./sondes"
BACKUP_DIR="./save"


# ------------------------------------------------------------------------------
# Créer la table principale si elle n'existe pas
# ------------------------------------------------------------------------------
sqlite3 "$DB_PATH" "CREATE TABLE IF NOT EXISTS monitoring (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_heure_scan DATETIME DEFAULT CURRENT_TIMESTAMP
);"

# ------------------------------------------------------------------------------
# Fonction pour ajouter dynamiquement une colonne si une nouvelle sonde apparaît
# ------------------------------------------------------------------------------
add_column() {
    local column_name="$1"
    local query="ALTER TABLE monitoring ADD COLUMN \"$column_name\" REAL;"
    sqlite3 "$DB_PATH" "$query"
}

# Initialisation des variables pour stocker les noms/valeurs des sondes
all_data=""
sonde_names=""

# Affichage dans le terminal
echo "-------------------"
echo "$(date +"%Y-%m-%d %T")"
echo "-------------------"

# ------------------------------------------------------------------------------
# Exécuter toutes les sondes du dossier (sauf getCertAlert.py)
# ------------------------------------------------------------------------------
for filename in "$SONDES_DIR"/*; do
    if [[ $filename != *getCertAlert.py ]]; then
        sondename=$(basename "$filename" | cut -f1 -d '.')  # Nom de la sonde

        # Ajouter dynamiquement la colonne si elle n'existe pas
        if ! sqlite3 "$DB_PATH" ".schema monitoring" | grep -qE "\b$sondename\b"; then
            add_column "$sondename"
        fi

        # Exécuter la sonde selon le type de fichier
        if [[ $filename == *.py ]]; then
            data=$(python3 "$filename")
        elif [[ $filename == *.sh ]]; then
            data=$(bash "$filename")
        else
            continue
        fi

        echo "$sondename : $data"  # Affichage dans le terminal

        # Remplacer la virgule par un point (cas 9,2 → 9.2)
        data=$(echo "$data" | sed 's/,/./')

        # Ajouter le nom et la valeur à la chaîne
        sonde_names+=", $sondename"
        all_data+=", $data"
    fi
done

# ------------------------------------------------------------------------------
# Insertion des données dans la base
# ------------------------------------------------------------------------------
sonde_names=$(echo "$sonde_names" | sed 's/^,//')   # Supprimer la première virgule
all_data=$(echo "$all_data" | sed 's/^,//')

sqlite3 "$DB_PATH" "INSERT INTO monitoring (${sonde_names}) VALUES (${all_data});"

# ------------------------------------------------------------------------------
# Limiter à 100 lignes dans la base (supprimer les plus anciennes)
# ------------------------------------------------------------------------------
count=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM monitoring;")
if [ "$count" -gt 100 ]; then
    sqlite3 "$DB_PATH" "DELETE FROM monitoring WHERE id = (SELECT id FROM monitoring ORDER BY date_heure_scan ASC LIMIT 1);"
fi

# ------------------------------------------------------------------------------
# Exécuter la sonde CERT-FR pour récupérer les alertes
# ------------------------------------------------------------------------------
python3 sondes/getCertAlert.py

# ------------------------------------------------------------------------------
# Sauvegarde automatique (tous les 10 scans dans CreateBackup.sh)
# ------------------------------------------------------------------------------
bash save/CreateBackup.sh

# ------------------------------------------------------------------------------
# Gestion des arguments (_save / _restore / _config)
# ------------------------------------------------------------------------------
current_backup=$(ls -t "$BACKUP_DIR" | head -n1)

case "$1" in
    "_save")
        bash save/CreateBackup.sh manuel
        ;;
    "_restore")
        echo "🔁 Restauration de la base depuis la dernière sauvegarde"
        cp "save/$current_backup" "$DB_PATH"
        ;;
    "_config")
        python3 config.py
        ;;
esac
/*
# ------------------------------------------------------------------------------
# Génération des graphiques selon la période choisie (config.py)
# ------------------------------------------------------------------------------
limit_data=$(sqlite3 "$DB_PATH" "SELECT history_threshold FROM config ORDER BY id DESC LIMIT 1;")

for graph_script in graph/*_graph.sh; do
    bash "$graph_script" "$limit_data" >/dev/null 2>&1
done

# ------------------------------------------------------------------------------
# Envoi d'email si seuils dépassés (alerte de crise)
# ------------------------------------------------------------------------------
python3 AlertMail/MailCrisis.py