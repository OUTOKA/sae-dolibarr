# SAE51 - projet 3 Installation d’un ERP/CRM

---

## Qu'est ce que Dolibarr ? 

Dolibarr ERP & CRM est un logiciel moderne conçu pour gérer efficacement votre activité, que vous soyez une entreprise, une associationetc... Intuitif et modulaire, il vous permet d'activer uniquement les fonctionnalités dont vous avez besoin, comme la gestion des contacts, des fournisseurs, des factures, des commandes, des stocks ou encore de l'agenda.

## Comment configurer le docker-compose : 

Nous l'avons récupérer le docker-compose via le lien : https://hub.docker.com/r/dolibarr/dolibarr
# Déploiement de Dolibarr avec Docker  

Ce guide explique comment configurer et exécuter Dolibarr ERP & CRM en utilisant Docker et Docker Compose.  

## Prérequis  
- **Docker** et **Docker Compose** doivent être installés sur votre machine.  
- Assurez-vous d'avoir les permissions nécessaires pour créer et monter des volumes locaux.  

## Fichier docker-compose.yml

Voici la configuration complète du fichier :  

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


## Première prise en main de Dolibarr    

### Prérequis  
Avant de commencer, assurez-vous que les conditions suivantes sont remplies :  
- Un serveur web installé (Apache, Nginx, etc.).  
- PHP (version compatible avec Dolibarr).  
- Une base de données (MySQL, MariaDB, ou PostgreSQL).  

### Arrivé sur Dolibarr
Pour se rendre sur Dolibarr, nous devons entrer l'URL http://127.0.0.1:90
Connexion : admin / admin

Se rendre dans le menu "Configuration" puis "Modules/Application".
Selectionner ensuite les modules souhaité comment par exemple : "Utilisateur & Groupes", "Expedition"...

