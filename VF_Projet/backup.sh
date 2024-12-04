#!/bin/bash

# Configurations
BACKUP_DIR="/home/outoka/sae-dolibarr/backups_dolibarr"
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
