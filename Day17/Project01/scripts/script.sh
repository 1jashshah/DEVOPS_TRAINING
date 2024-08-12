#!/bin/bash
 
# Variables
BACKUP_DIR="/var/backups/mysql"
MYSQL_USER="my_user"
MYSQL_PASSWORD="user_password"
MYSQL_DB="my_database"
 
# Date format for the backup file
DATE=$(date +\%F)
 
# Perform the backup
mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DB" > "$BACKUP_DIR/backup_$DATE.sql"
 
# Optional: Remove backups older than 7 days
find "$BACKUP_DIR" -type f -name '*.sql' -mtime +7 -exec rm {} \;
