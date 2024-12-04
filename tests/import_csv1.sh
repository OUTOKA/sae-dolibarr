#!/bin/bash

# Configurations de base
API_URL="https://0.0.0.0:90/api/index.php"
API_KEY="oZoO7U2y7oBz1UiFgiJg372TJ3W1rsS4"

# Vérifier si jq est installé
if ! command -v jq &> /dev/null; then
    echo "Erreur : 'jq' n'est pas installé. Installez-le avec 'sudo apt install jq' (ou équivalent)."
    exit 1
fi

# Demander le fichier CSV à l'utilisateur
read -p "Entrez le chemin du fichier CSV à importer : " CSV_FILE

# Vérifier si le fichier existe
if [[ ! -f "$CSV_FILE" ]]; then
    echo "Erreur : le fichier $CSV_FILE n'existe pas."
    exit 1
fi

# Demander la table d'importation
echo "Tables disponibles pour l'importation :"
echo "1. Utilisateurs (users)"
echo "2. Tiers (thirdparties)"
echo "3. Produits (products)"
read -p "Entrez le numéro de la table dans laquelle importer (ex: 1) : " TABLE_OPTION

# Assigner la table correspondante
case $TABLE_OPTION in
    1)
        TABLE="users"
        ;;
    2)
        TABLE="thirdparties"
        ;;
    3)
        TABLE="products"
        ;;
    *)
        echo "Erreur : option de table invalide."
        exit 1
        ;;
esac

# Fonction pour importer chaque utilisateur
function add_entry {
    local data="$1"
    local response

    # Envoyer la requête d'importation
    response=$(curl -s -X POST "$API_URL/$TABLE" \
        -H "DOLAPIKEY: $API_KEY" \
        -H "Content-Type: application/json" \
        -d "$data")

    # Vérifier la réponse de l'API
    if echo "$response" | jq -e '.error' &> /dev/null; then
        echo "Erreur lors de l'importation : $(echo "$response" | jq '.error.message')"
    else
        echo "Importation réussie pour l'entrée : $(echo "$data" | jq '.login, .email')"
    fi
}

# Lire le fichier CSV et importer les entrées
while IFS=, read -r identifiant nom prenom genre email ville telephone; do
    # Vérifier que le champ 'identifiant' n'est pas vide
    if [[ -n "$identifiant" && "$identifiant" != "identifiant" ]]; then
        # Construire les données JSON en fonction de la table
        if [[ "$TABLE" == "users" ]]; then
            data=$(jq -n --arg login "$identifiant" --arg lastname "$nom" --arg firstname "$prenom" \
                      --arg gender "$genre" --arg email "$email" --arg town "$ville" --arg phone "$telephone" \
                      '{login: $login, lastname: $lastname, firstname: $firstname, gender: $gender, email: $email, town: $town, phone_pro: $phone}')
        elif [[ "$TABLE" == "thirdparties" ]]; then
            data=$(jq -n --arg name "$nom" --arg town "$ville" --arg email "$email" --arg phone "$telephone" \
                      '{name: $name, town: $town, email: $email, phone: $phone}')
        elif [[ "$TABLE" == "products" ]]; then
            data=$(jq -n --arg ref "$ref" --arg label "$label" --arg price "$price" \
                      '{ref: $ref, label: $label, price: $price}')
        fi

        # Appeler la fonction pour importer
        add_entry "$data"
    fi
done < "$CSV_FILE"

echo "Importation terminée."

