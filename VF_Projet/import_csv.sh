#!/bin/bash

# Configuration de base
API_URL="http://0.0.0.0:90/api/index.php"
API_KEY="oZoO7U2y7oBz1UiFgiJg372TJ3W1rsS4"

# Vérifier si jq est installé
if ! command -v jq &> /dev/null; then
    echo "Erreur : 'jq' n'est pas installé. Installez-le avec 'sudo apt install jq' (ou équivalent)."
    exit 1
fi

# Demander le fichier CSV à l'utilisateur
read -p "Entrez le chemin du fichier CSV à importer : " CSV_FILE

# Vérifier si le fichier CSV existe
if [[ ! -f "$CSV_FILE" ]]; then
    echo "Erreur : le fichier $CSV_FILE n'existe pas."
    exit 1
fi

# Demander la table d'importation
read -p "Entrez le nom de la table cible (par exemple, 'users', 'thirdparties', 'products') : " TABLE

# Fonction pour importer une ligne
import_entry() {
    local data="$1"
    local response

    # Envoi de la requête POST
	response=$(curl -s -w "\nHTTP_CODE:%{http_code}" -X POST "$API_URL/$TABLE" \
		-H "DOLAPIKEY: $API_KEY" \
    	-H "Content-Type: application/json" \
    	-d "$data")

	# Extraire le code HTTP
	http_code=$(echo "$response" | grep "HTTP_CODE" | sed 's/.*HTTP_CODE://')

    echo "Importation n° : $response"

	}

# Lecture du fichier CSV et construction des données JSON
echo "Lecture du fichier CSV et importation dans la table '$TABLE'..."
header_read=false
keys=()

while IFS=, read -r line; do
    # Lire la première ligne comme les clés (colonnes)
    if ! $header_read; then
        IFS=',' read -ra keys <<< "$line" # Sauvegarder les noms de colonnes
        header_read=true
        continue
    fi

    # Lire les valeurs
    IFS=',' read -ra values <<< "$line"

    # Construire dynamiquement le JSON
    json_data=$(jq -n '{data: {}}')
    for i in "${!keys[@]}"; do
        key=${keys[i]}
        value=${values[i]}
        json_data=$(echo "$json_data" | jq --arg k "$key" --arg v "$value" '.data[$k] = $v')
    done

    # Extraire la section "data" en JSON propre
    json_data=$(echo "$json_data" | jq '.data')

    # Appeler la fonction pour importer l'entrée
    import_entry "$json_data"

done < "$CSV_FILE"

echo "Importation terminée."

