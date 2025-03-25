# 🖥️ EasyMonitor

## 🔍 Description
EasyMonitor est un outil simple pour surveiller l’état des serveurs et détecter les problèmes ⚠️.  
Ce projet a été réalisé dans le cadre du cours **Administration des Systèmes d’Exploitation** (L2 - S4, CERI, Université d’Avignon).

---
## 🧩 Fonctionnalités principales

- **Collecte d’informations système** (CPU, RAM, disque, utilisateurs…)
- **Stockage des données et archivage historique**
- **Détection de situations critiques et envoi d'alertes**
- **Visualisation des données (graphiques)**
- **Interface Web de consultation**

---

## 🛠️ Technologies utilisées

- **Bash**
- **Python** (avec `psutil`, `flask`, `rrdtool`, etc.)
- **rrdtool / sqlite** pour le stockage
- **Flask / BeautifulSoup / Jinja2** pour le front-end

---

## 📬 Alertes
Des emails sont envoyés automatiquement en cas de :
- Surcharge CPU ou RAM
- Disque plein
- Serveur inactif > 30 minutes
- Alerte de sécurité du CERT

---

## 📈 Visualisation
Les données sont affichées sous forme de graphiques (évolution dans le temps) grâce à des outils comme `pygal`, `gnuplot` ou `rrdtool`.

---

## 🌐 Interface Web
L’interface web permet de consulter :
- Les données collectées
- Les historiques graphiques
- Les alertes en cours

---

## 📂 Structure du projet

```bash
EasyMonitor/
├── collect/            # Scripts de collecte des données (Python & Bash)
│   ├── sondes_cpu.sh / .py
│   ├── sondes_ram.sh / .py
│   └── ...
│
├── storage/            # Modules de stockage et d'archivage
│   ├── gestion_sqlite.py
│   ├── parseur_cert.py
│   └── ...
│
├── alerts/             # Détection de crises et envoi d'alertes par mail
│   ├── detecteur.py
│   ├── mailer.py
│   └── ...
│
├── web/                # Interface Web (Flask, HTML, templates Jinja)
│   ├── app.py
│   ├── templates/
│   └── static/
│
├── utils/              # Fonctions utilitaires (facultatif)
│   └── helpers.py
│
├── data/               # Fichiers de logs, historiques, bases de données
│   └── ...
│
├── README.md           # Description du projet
├── LICENSE             # Licence (MIT, GPL, etc.)
├── requirements.txt    # Dépendances Python à installer
└── .gitignore          # Fichiers à ignorer par Git
```

---

## 📣 Auteurs
Projet réalisé par [GHABI Malek] 

