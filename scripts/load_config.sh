#!/data/data/com.termux/files/usr/bin/bash

CONFIG_FILE="$HOME/analitica/config/db.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: No se encontró el archivo de configuración: $CONFIG_FILE"
    exit 1
fi

# Cargar variables
source "$CONFIG_FILE"
