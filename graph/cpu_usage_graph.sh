#!/bin/bash

DB_PATH="DB/stockage.db"
OUTPUT_DIR="graph"
OUTPUT_FILE="$OUTPUT_DIR/cpu_usage.png"

# Crée le dossier de sortie si besoin
mkdir -p "$OUTPUT_DIR"

# Récupère la limite (depuis la base, ou par défaut à 100)
history_threshold=$(sqlite3 "$DB_PATH" "SELECT history_threshold FROM config ORDER BY id DESC LIMIT 1;")
LIMIT=${history_threshold:-100}

# Exporte les données (du plus récent au plus ancien)
sqlite3 -header -csv "$DB_PATH" \
"SELECT date_heure_scan, cpuUsage FROM monitoring ORDER BY date_heure_scan DESC LIMIT $LIMIT;" > "$OUTPUT_DIR/cpu_data.csv"

# Inverse pour avoir du plus ancien au plus récent (mieux pour un graphique)
tac "$OUTPUT_DIR/cpu_data.csv" > "$OUTPUT_DIR/cpu_data_sorted.csv"

# Génère le graphique avec gnuplot
gnuplot << EOF
set datafile separator ","
set terminal png size 900,500
set output "$OUTPUT_FILE"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M"
set xlabel "Date et heure"
set ylabel "CPU Usage (%)"
set title "Evolution du CPU Usage"
set grid
plot "$OUTPUT_DIR/cpu_data_sorted.csv" using 1:2 with lines title "CPU Usage"
EOF

# Nettoyage
rm "$OUTPUT_DIR/cpu_data.csv" "$OUTPUT_DIR/cpu_data_sorted.csv"

echo "Graphique généré : $OUTPUT_FILE"