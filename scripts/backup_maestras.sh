#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/analitica"
source "$BASE_DIR/scripts/load_config.sh"

SQL_DIR="$BASE_DIR/sql/maestros"
BACKUP_DIR="$BASE_DIR/backups/maestros"

mkdir -p "$BACKUP_DIR"

dump_sql() {
    local input_sql="$1"
    local name="$(basename "$input_sql" .sql)"
    local output="$BACKUP_DIR/${name}.csv"

    mariadb -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" "$DB_NAME" < "$input_sql" \
        | sed 's/\t/,/g' > "$output"
}

dump_sql "$SQL_DIR/clientes.sql"
dump_sql "$SQL_DIR/productos.sql"
dump_sql "$SQL_DIR/proveedores.sql"
dump_sql "$SQL_DIR/categorias.sql"
dump_sql "$SQL_DIR/tipo_documentos.sql"
dump_sql "$SQL_DIR/tipo_unidades.sql"
dump_sql "$SQL_DIR/empresas.sql"
dump_sql "$SQL_DIR/users.sql"


echo "✔️ Backup de tablas maestras actualizado en $BACKUP_DIR"