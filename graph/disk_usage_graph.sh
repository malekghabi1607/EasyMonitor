#!/bin/bash

DB_PATH="DB/stockage.db"
OUTPUT_DIR="graph"
OUTPUT_FILE="$OUTPUT_DIR/disk_usage.png"

# Crée le dossier de sortie s'il n'existe pas
mkdir -p "$OUTPUT_DIR"

# Récupère le nombre de points à afficher depuis la base (ou 100 par défaut)
history_threshold=$(sqlite3 "$DB_PATH" "SELECT history_threshold FROM config ORDER BY id DESC LIMIT 1;")
LIMIT=${history_threshold:-100}

# Exporter les données depuis la base (du plus récent au plus ancien)
sqlite3 -header -csv "$DB_PATH" \
"SELECT date_heure_scan, diskUsage FROM monitoring ORDER BY date_heure_scan DESC LIMIT $LIMIT;" > "$OUTPUT_DIR/disk_data.csv"

# Inverse pour afficher du plus ancien au plus récent
tac "$OUTPUT_DIR/disk_data.csv" > "$OUTPUT_DIR/disk_data_sorted.csv"

# Utiliser gnuplot pour générer le graphique
gnuplot << EOF
set datafile separator ","
set terminal png size 900,500
set output "$OUTPUT_FILE"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M"
set xlabel "Date et heure"
set ylabel "Disk Usage (%)"
set title "Evolution du Disk Usage"
set grid
plot "$OUTPUT_DIR/disk_data_sorted.csv" using 1:2 with lines title "Disk Usage"
EOF

# Supprimer les fichiers CSV temporaires
rm "$OUTPUT_DIR/disk_data.csv" "$OUTPUT_DIR/disk_data_sorted.csv"

echo "Graphique généré : $OUTPUT_FILE"