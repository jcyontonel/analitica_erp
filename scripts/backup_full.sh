#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/analitica"
source "$BASE_DIR/scripts/load_config.sh"

DATE=$(date +"%Y-%m-%d")
OUT="$HOME/analitica/backups/full/erp_full_$DATE.sql"

mariadb-dump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$OUT"

echo "✔️ Backup FULL generado: $OUT"