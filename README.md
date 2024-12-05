#### Antoine DIDIERJEAN
#### Hugo BIENVENU

# SAE51 - projet 3 Installation d’un ERP/CRM

---

## Qu'est ce que Dolibarr ? 

Dolibarr est un logiciel moderne conçu pour gérer efficacement votre activité, que vous soyez une entreprise, une association ou autre. Intuitif et modulaire, il vous permet d'activer uniquement les fonctionnalités dont vous avez besoin, comme la gestion des contacts, des fournisseurs, des factures, des commandes, des stocks ou encore de l'agenda.

## Fonctionnalités principales
### CRM
- Suivi des clients/prospects.
- Opportunités commerciales.
- E-mailing.

### Gestion commerciale
- **Devis et commandes** : Création, suivi, conversion en factures.
- **Facturation** : Génération de factures, rappels, gestion des paiements.
- **Produits/Services** : Stock, prix, alertes de seuil.

### Finances
- Suivi des comptes bancaires, flux financiers.
- Rapports financiers, gestion de la TVA.

### Projets
- Planification et gestion des tâches.
- Suivi via diagrammes de Gantt.

### RH
- Suivi des employés.
- Gestion des congés et paies.

### Stock
- Gestion multi-entrepôts.
- Suivi en temps réel des niveaux de stock.

### E-commerce
- Intégration avec WooCommerce, Prestashop.
- Portail client.

### Autres
- GED (Gestion des documents).
- Modules pour associations.

## Architecture et Modules
- **Modulable** : Activez/désactivez les fonctionnalités selon vos besoins.
- **Plugins** : Extensible via Dolistore (marketplace officielle).

## Base de données
- **Nombre de tables** : Plus de 300 (varie selon les modules activés).
- **Exemples de tables** :
  - `llx_users` : Utilisateurs.
  - `llx_facture` : Factures.
  - `llx_projet` : Projets.
  - `llx_product` : Produits.

## Points forts
- **Gratuit et open-source**.
- **Communauté active** pour support et extensions.
- **Sécurité** : Gestion fine des droits d’accès.
- **Portabilité** : Fonctionne sur Windows, Linux, macOS, Docker.

## API REST
- Permet l’accès aux données (listes de tables, contenus).
- Configurable via un jeton d’authentification.

## Conclusion
Dolibarr est une solution puissante, simple à utiliser, et adaptée à des besoins variés. Idéale pour centraliser la gestion des activités d'une organisation.


### Toutes les manipulations qui vont suivre peuvent être réalisées dans dossier VF_Projet qui se situe à la racine de notre repository.

## Comment configurer le docker-compose : 

Nous avons récupérer le docker-compose via le lien : [https://hub.docker.com/r/dolibarr/dolibarr](https://hub.docker.com/r/dolibarr/dolibarr)
# Déploiement de Dolibarr avec Docker  

Ce guide explique comment configurer et exécuter Dolibarr en utilisant Docker et Docker Compose.  

## Prérequis  
- **Docker** et **Docker Compose** doivent être installés sur votre machine.  
- Assurez-vous d'avoir les permissions nécessaires pour créer et monter des volumes locaux.  

## Fichier docker-compose

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

Ce fichier configure et déploie deux conteneurs afin d'exécuter Dolibarr avec Docker.

## Lancement des conteneurs

1- Créer un fichier nommé docker-compose.yml puis y copier le contenu du fichier présent juste au-dessus.

2- Dans le même répertoire que le docker-compose, lancer la commande:
```bash
docker-compose up --build
```
(Si lors du lancement, cette erreur apparait pour le serveur web : 

web_1      | [INIT] => As UID / GID have changed from default, update ownership for files in /var/ww ...

Entrez la commande : ``` sudo chown -R www-data:www-data /var/www``` )

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

# Importation de données vers Dolibarr via l'API   

Nous avons réaliser un script en Bash qui permet d'importer des données depuis un fichier CSV dans une table cible de Dolibarr via son API. Il utilise `curl` pour envoyer les requêtes HTTP et `jq` pour manipuler les données JSON.

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

### Script import_csv.sh 

```bash
#!/bin/bash

# Configuration de base
API_URL="http://0.0.0.0:90/api/index.php"
API_KEY="<API utilisateur>"

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

## Étapes principales du fonctionnement  

1. **Configuration de base** :  
   - Le script définit l'URL de l'API et la clé API nécessaires pour interagir avec Dolibarr.  

2. **Vérification des outils nécessaires** :  
   - Le script vérifie si `jq` est installé, car il est indispensable pour manipuler les données JSON.  

3. **Demande d'informations utilisateur** :  
   - Le chemin du fichier CSV à importer, un fichier exemple se trouve dans le VF_Final sous le nom de users.csv  
   - La table cible de Dolibarr où les données doivent être ajoutées (exemple : `users`).  

4. **Lecture du fichier CSV** :  
   - La première ligne du fichier est l'en-tête, utilisée pour définir les clés des données.  
   - Les lignes suivantes contiennent les données qui seront transformées en objets JSON.  

5. **Construction et envoi des requêtes API** :  
   - Chaque ligne du fichier CSV est convertie en un objet JSON.  
   - Ce JSON est envoyé à Dolibarr via une requête HTTP POST, en utilisant `curl`.  

6. **Affichage des résultats** :  
   - Le script affiche les réponses de l'API pour chaque envoi, ce qui permet de vérifier
  
## Utilisation du script import_csv.sh 
1- Dans un premier temps il faut copier ce script dans un fichier nommé import_csv.sh (sinon il se trouve dans le répertoir VF_Final dans notre repository)

2- Modifiez le script en remplaçant la parie <API utilisateur> dans les variables par l'API d'un utilisateur. Pour trouver l'API d'un utilisateur (l'admin par exemple) se rendre sur le serveur Dolibarr, aller dans l'onglet Utilisateurs & Groupes, Liste des utilisateurs, en sélectionner un puis cliquer sur modifier. Vous aurez alors la possibilité de générer une clé API. Vous n'aurez alors plus qu'à la copier/coller à l'emplacement dédié dans le script.

3- Une fois ces étapes réalisées, lancez le script en vous plaçant dans le même répertoire que le script puis en entrant la commande :
``` ./import_csv.sh ```

4- Dans un premier temps vous devrez alors entrer le chemin complet de votre fichier CSV puis ensuite entrer la table correspondante au fichier.

### Les Tables
Pour trouver les différentes tables possibles à utiliser avec le script import_csv.sh, il vous suffit de vous rendre à l'url http://http://127.0.0.1:90/api/index.php/explorer/

Ensuite, en haut à droite, entrez votre clé API puis cliquez sur Explore. Vous trouverez ainsi la liste des tables accessibles.

# Système de Backup

```
#!/bin/bash

# Création répertoire pour stocker les sauvegardes
mkdir /home/backups_dolibarr

# Configurations
BACKUP_DIR="/home/backups_dolibarr"
DB_NAME="dolibarr"
DB_USER="root"
DB_PASS="root"
FILES_DIR="/home/dolibarr_documents /home/dolibarr_custom"

# Date
DATE=$(date +"%Y-%m-%d")

# Sauvegarde des fichiers
tar -czvf $BACKUP_DIR/dolibarr_files_$DATE.tar.gz $FILES_DIR

# Sauvegarde de la base de données
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/dolibarr_db_$DATE.sql
```
Ce script permet de réaliser une sauvegarde de l'état du serveur et de la placer dans un un dossier spécial nommé backups_dolibarr.

Les fichiers de sauvegarde sont nommé avec la date du jour même et sont également compressé pour ne pas prendre trop de place.

Ce script réalise en même temps une sauvegarde dae la base de données afin d'avoir toutes les données disponible dans le cas d'un Plan de Reprise d'Activité.

Afin qu'une sauvegarde soit réalisée tous les jours à 2h du matin on peut utiliser cron avec a commande ```0 2 * * * /bin/bash /chemin/vers/backup.sh```
en indiquant le chemin correspondant au script.
 
