#### Antoine DIDIERJEAN
#### Hugo BIENVENU

# SAE51 - projet 3 Installation d’un ERP/CRM

---

## Qu'est ce que Dolibarr ? 

Dolibarr ERP & CRM est un logiciel moderne conçu pour gérer efficacement votre activité, que vous soyez une entreprise, une association ou autre. Intuitif et modulaire, il vous permet d'activer uniquement les fonctionnalités dont vous avez besoin, comme la gestion des contacts, des fournisseurs, des factures, des commandes, des stocks ou encore de l'agenda.

## Comment configurer le docker-compose : 

Nous avons récupérer le docker-compose via le lien : [https://hub.docker.com/r/dolibarr/dolibarr](https://hub.docker.com/r/dolibarr/dolibarr)
# Déploiement de Dolibarr avec Docker  

Ce guide explique comment configurer et exécuter Dolibarr ERP & CRM en utilisant Docker et Docker Compose.  

## Prérequis  
- **Docker** et **Docker Compose** doivent être installés sur votre machine.  
- Assurez-vous d'avoir les permissions nécessaires pour créer et monter des volumes locaux.  

## Fichier docker-compose.yml

Voici le fichier **docker-compose.yml** :  

```bash
yaml
services:
    mariadb:
        image: mariadb:11.6.2
        environment:
            MYSQL_ROOT_PASSWORD: root
            MYSQL_DATABASE: dolibarr
        volumes:
            - /home/dolibarr_mariadb:/var/lib/mysql

    web:
        image: dolibarr/dolibarr:20.0.0
        environment:
            DOLI_DB_HOST: mariadb
            DOLI_DB_USER: root
            DOLI_DB_PASSWORD: root
            DOLI_DB_NAME: dolibarr
            DOLI_URL_ROOT: 'http://127.0.0.1:90'
            DOLI_ADMIN_LOGIN: 'admin'
            DOLI_ADMIN_PASSWORD: 'admin'
            DOLI_INIT_DEMO: 0
            WWW_USER_ID: 1000
            WWW_GROUP_ID: 1000
        ports:
            - "90:80"
        links:
            - mariadb
        volumes:
            - /home/dolibarr_documents:/var/www/documents1
            - /home/dolibarr_custom:/var/www/html/custom1
```

Ce fichier `docker-compose.yml` configure et déploie deux conteneurs afin d'exécuter Dolibarr ERP & CRM avec Docker.  

## Services configurés  

### 1. **MariaDB**  
Ce service installe une base de données relationnelle MariaDB, utilisée par Dolibarr pour stocker toutes ses données.  
- **Image** : `mariadb:11.6.2`.  
- **Volumes** :  
  - Les données sont sauvegardées sur votre machine dans le répertoire :  
    `/home/dolibarr_mariadb`.  
- **Configuration** :  
  - Le mot de passe root et le nom de la base de données (`dolibarr`) sont définis via des variables d’environnement.  

---

### 2. **Dolibarr (web)**  
Ce service installe et exécute l'application Dolibarr ERP & CRM, accessible via un navigateur.  
- **Image** : `dolibarr/dolibarr:20.0.0`.  
- **Volumes** :  
  - `/home/dolibarr_documents` : Stocke les documents générés par Dolibarr (devis, factures, etc.).  
  - `/home/dolibarr_custom` : Stocke les fichiers de personnalisation.  
- **Ports** :  
  - Dolibarr est accessible à l'adresse : [http://127.0.0.1:90](http://127.0.0.1:90).  

---

# Première prise en main de Dolibarr    

### Prérequis  
Avant de commencer, assurez-vous que les conditions suivantes sont remplies :  
- Un serveur web installé (Apache, Nginx, etc.).  
- PHP (version compatible avec Dolibarr).  
- Une base de données (MySQL, MariaDB, ou PostgreSQL).  

### Arrivé sur Dolibarr
Dolibarr est accessible à l'adresse : [http://127.0.0.1:90](http://127.0.0.1:90).  
- Connexion :
  - **USER** : admin
  - **MOT DE PASSE** : admin

Se rendre dans le menu "Configuration" puis "Modules/Application".
Selectionner ensuite les modules souhaité comme par exemple : "Utilisateur & Groupes", "Expedition"...
Activer ensuite ces modules.

---

# Script d'importation de données vers Dolibarr via l'API REST  

Ce script en Bash permet d'importer des données depuis un fichier CSV dans une table cible de Dolibarr via son API REST. Il utilise `curl` pour envoyer les requêtes HTTP et `jq` pour manipuler les données JSON.

---

## Prérequis  

Avant d'utiliser ce script, assurez-vous d'avoir les éléments suivants :  
1. **Un serveur Dolibarr** avec l'API REST activée.  
2. **Une clé API valide** pour accéder à l'API Dolibarr.  
3. **Les outils suivants installés sur votre système** :  
   - `bash`  
   - `curl`  
   - `jq` (pour manipuler les JSON).  
   - Si `jq` n'est pas installé, vous pouvez l'ajouter avec :  
     ```bash
     sudo apt install jq
     ```

---

## Utilisation  

# Script d'importation de données vers Dolibarr via l'API REST  

```bash
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
```

