#!/bin/bash

# Variables de configuration
CSV_FILE="data.csv"
API_URL="https://votre_dolibarr.com/api/index.php"
API_TOKEN="votre_clef_API"  # Remplacez par votre clé API

# Boucle pour lire le CSV
while IFS=',' read -r champ1 champ2 champ3; do
    # Préparer les données en JSON
    DATA_JSON=$(jq -n \
                  --arg champ1 "$champ1" \
                  --arg champ2 "$champ2" \
                  --arg champ3 "$champ3" \
                  '{field1: $champ1, field2: $champ2, field3: $champ3}')

    # Envoyer les données à l'API Dolibarr
    curl -X POST "$API_URL/resource" \
         -H "DOLAPIKEY: $API_TOKEN" \
         -H "Content-Type: application/json" \
         -d "$DATA_JSON"

done < "$CSV_FILE"
