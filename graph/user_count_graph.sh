#!/bin/bash

# Dossier de sortie du graphique
OUTPUT_DIR="graph"
OUTPUT_FILE="$OUTPUT_DIR/user_count.png"

# Crée le dossier s'il n'existe pas
mkdir -p "$OUTPUT_DIR"

# Récupère la limite (history_threshold) ou 100 par défaut
history_threshold=$(sqlite3 DB/stockage.db "SELECT history_threshold FROM config ORDER BY id DESC LIMIT 1;")
limit=${history_threshold:-100}

# Exporte les données dans un fichier temporaire
sqlite3 DB/stockage.db "SELECT date_heure_scan, userCount FROM monitoring ORDER BY date_heure_scan DESC LIMIT $limit;" > "$OUTPUT_DIR/user_data.csv"

# Inverse les lignes (du plus vieux au plus récent) pour le graphique
tac "$OUTPUT_DIR/user_data.csv" > "$OUTPUT_DIR/user_data_sorted.csv"

# Génère le graphique avec gnuplot
gnuplot <<EOF
set terminal png size 900,500
set output "$OUTPUT_FILE"
set title "Nombre d'utilisateurs connectés - Historique"
set xlabel "Date et Heure"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%d/%m\n%H:%M"
set ylabel "Nombre d'utilisateurs"
set grid
plot "$OUTPUT_DIR/user_data_sorted.csv" using 1:2 with linespoints title "Utilisateurs"
EOF

# Nettoyage fichier temporaire
rm "$OUTPUT_DIR/user_data.csv" "$OUTPUT_DIR/user_data_sorted.csv"

echo "Graphique généré : $OUTPUT_FILE"