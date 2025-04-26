#!/bin/bash

# Chemin vers la base de données
DB_PATH="DB/stockage.db"
OUTPUT_DIR="graph"
OUTPUT_FILE="$OUTPUT_DIR/ram_usage.png"

# Création du dossier de sortie s'il n'existe pas
mkdir -p "$OUTPUT_DIR"

# Récupération automatique du nombre de points à afficher depuis la base (ou 100 si vide)
history_threshold=$(sqlite3 "$DB_PATH" "SELECT history_threshold FROM config ORDER BY id DESC LIMIT 1;")
LIMIT=${history_threshold:-100}

# Extraction des données RAM depuis la base, du plus récent au plus ancien
sqlite3 -header -csv "$DB_PATH" \
"SELECT date_heure_scan, ramUsage FROM monitoring ORDER BY date_heure_scan DESC LIMIT $LIMIT;" > "$OUTPUT_DIR/ram_data.csv"

# Inversion pour un affichage du plus ancien au plus récent sur le graphique
tac "$OUTPUT_DIR/ram_data.csv" > "$OUTPUT_DIR/ram_data_sorted.csv"

# Génération du graphique avec gnuplot (image enregistrée dans un dossier qui existe !)
gnuplot << EOF
set datafile separator ","
set terminal png size 900,500
set output "$OUTPUT_FILE"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M"
set xlabel "Date et heure"
set ylabel "RAM Usage (%)"
set title "Evolution du RAM Usage"
set grid
plot "$OUTPUT_DIR/ram_data_sorted.csv" using 1:2 with lines title "RAM Usage"
EOF

# Suppression des fichiers CSV temporaires
rm "$OUTPUT_DIR/ram_data.csv" "$OUTPUT_DIR/ram_data_sorted.csv"

# Message de succès pour l'utilisateur
echo "Graphique généré : $OUTPUT_FILE"