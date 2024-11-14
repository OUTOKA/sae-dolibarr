#!/bin/bash

# Configuration
API_URL="http://0.0.0.0:90/api/index.php/users" # URL de l'API Dolibarr
API_KEY="oZoO7U2y7oBz1UiFgiJg372TJ3W1rsS4"                                # Votre jeton API Dolibarr
CSV_FILE="export_user_1.csv"                   # Chemin du fichier CSV

# Vérifier si le fichier CSV existe
if [[ ! -f "$CSV_FILE" ]]; then
    echo "Le fichier CSV $CSV_FILE est introuvable."
    exit 1
fi

# Fonction pour ajouter un utilisateur
add_user() {
    local login="$1"
    local lastname="$2"
    local firstname="$3"
    local gender="$4"
    local email="$5"
    local city="$6"
    local phone="$7"

    # Construction de la requête JSON
    data=$(jq -n \
        --arg login "$login" \
        --arg lastname "$lastname" \
        --arg firstname "$firstname" \
        --arg gender "$gender" \
        --arg email "$email" \
        --arg city "$city" \
        --arg phone "$phone" \
        '{
            login: $login,
            lastname: $lastname,
            firstname: $firstname,
            gender: $gender,
            email: $email,
            city: $city,
            phone_pro: $phone
        }')

    # Envoi de la requête POST à l'API de Dolibarr
    response=$(curl -s -X POST "$API_URL" \
        -H "DOLAPIKEY: $API_KEY" \
        -H "Content-Type: application/json" \
        -d "$data")

    # Vérification de la réponse
    if echo "$response" | grep -q '"id":'; then
        echo "Utilisateur $firstname $lastname ajouté avec succès."
    else
        echo "ajout de l'utilisateur $firstname $lastname : $response"
    fi
}

# Lecture du fichier CSV et ajout de chaque utilisateur
while IFS=, read -r login lastname firstname gender email city phone; do
    # Vérifier que le login n'est pas vide
    if [[ -n "$login" && "$login" != "identifiant" ]]; then
        add_user "$login" "$lastname" "$firstname" "$gender" "$email" "$city" "$phone"
    else
        echo "Erreur : Le champ 'Login' est vide ou manquant pour l'utilisateur $firstname $lastname."
    fi
done < "$CSV_FILE"


