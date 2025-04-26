#!/bin/bash

DB_PATH="DB/stockage.db"
OUTPUT_DIR="graph"
OUTPUT_FILE="$OUTPUT_DIR/process_count.png"

# Crée le dossier de sortie
mkdir -p "$OUTPUT_DIR"

# Récupère la limite depuis la base ou utilise 100 si rien n'est trouvé
history_threshold=$(sqlite3 "$DB_PATH" "SELECT history_threshold FROM config ORDER BY id DESC LIMIT 1;")
LIMIT=${history_threshold:-100}

# Exporte les données de la base dans un CSV
sqlite3 -header -csv "$DB_PATH" \
"SELECT date_heure_scan, processCount FROM monitoring ORDER BY date_heure_scan DESC LIMIT $LIMIT;" > "$OUTPUT_DIR/process_data.csv"

# Inverse l'ordre des données pour l'affichage
tac "$OUTPUT_DIR/process_data.csv" > "$OUTPUT_DIR/process_data_sorted.csv"

# Génère le graphique avec gnuplot (dans un dossier qui existe)
gnuplot << EOF
set datafile separator ","
set terminal png size 900,500
set output "$OUTPUT_FILE"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M"
set xlabel "Date et heure"
set ylabel "Process Count"
set title "Evolution du nombre de processus"
set grid
plot "$OUTPUT_DIR/process_data_sorted.csv" using 1:2 with lines title "Process Count"
EOF

# Nettoyage
rm "$OUTPUT_DIR/process_data.csv" "$OUTPUT_DIR/process_data_sorted.csv"

echo "Graphique généré : $OUTPUT_FILE"