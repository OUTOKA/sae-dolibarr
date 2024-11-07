#!/bin/bash

# Variables de configuration
CSV_FILE="export_user_1.csv"
DB_HOST="localhost"
DB_USER="admin"
DB_PASS="admin"
DB_NAME="dolibarr"
TABLE_NAME="llx_user"

# Boucle pour lire le CSV et insérer dans MySQL
while IFS=',' read -r champ1 champ2 champ3; do
    # Créer une requête SQL
    SQL_QUERY="INSERT INTO $TABLE_NAME (champ1, champ2, champ3) VALUES ('$champ1', '$champ2', '$champ3');"

    # Exécuter la requête dans MySQL
    mysql -u "$DB_USER" -p "$DB_NAME" --password="$DB_PASS" 

done < "$CSV_FILE"
