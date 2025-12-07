#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/analitica"
source "$BASE_DIR/scripts/load_config.sh"

SQL_DIR="$BASE_DIR/sql/transacciones"
OUT_DIR="$BASE_DIR/backups/transacciones"

DATE=$(date +%Y-%m-%d)

# Crear carpetas necesarias
mkdir -p "$OUT_DIR/ventas"
mkdir -p "$OUT_DIR/compras"
mkdir -p "$OUT_DIR/detalle_ventas"
mkdir -p "$OUT_DIR/detalle_compras"
mkdir -p "$OUT_DIR/kardex"
mkdir -p "$OUT_DIR/detalle_kardex"
mkdir -p "$OUT_DIR/correlativos"

dump_sql() {
    local input_sql="$1"
    local folder="$2"
    local name="$(basename "$input_sql" .sql)"
    local output="$OUT_DIR/$folder/${name}_$DATE.csv"

    mariadb -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" "$DB_NAME" < "$input_sql" \
        | sed 's/\t/,/g' > "$output"
}

dump_sql "$SQL_DIR/ventas.sql" "ventas"
dump_sql "$SQL_DIR/detalle_ventas.sql" "detalle_ventas"
dump_sql "$SQL_DIR/compras.sql" "compras"
dump_sql "$SQL_DIR/detalle_compras.sql" "detalle_compras"
dump_sql "$SQL_DIR/kardex.sql" "kardex"
dump_sql "$SQL_DIR/detalle_kardex.sql" "detalle_kardex"
dump_sql "$SQL_DIR/correlativos.sql" "correlativos"

echo "✔️ Backups transaccionales generados correctamente en:"
echo "$OUT_DIR"
