#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/analitica"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/run_all_$(date +%Y%m%d).log"

mkdir -p "$LOG_DIR"

echo "===== RUN ALL START: $(date) =====" | tee "$LOG_FILE"

# --- FUNCION PARA EJECUTAR Y VALIDAR ---
run_step() {
    local script="$1"
    local name="$2"

    echo "▶ Ejecutando: $name ..." | tee -a "$LOG_FILE"

    bash "$script" >> "$LOG_FILE" 2>&1

    if [ $? -ne 0 ]; then
        echo "❌ ERROR: Falló $name" | tee -a "$LOG_FILE"
        return 1
    fi

    echo "✔ OK: $name" | tee -a "$LOG_FILE"
    return 0
}

# --- EJECUCIÓN SECUENCIAL ---
run_step "$BASE_DIR/scripts/backup_full.sh" "Backup FULL" || exit 1
run_step "$BASE_DIR/scripts/backup_maestras.sh" "Backup MAESTROS" || exit 1
run_step "$BASE_DIR/scripts/backup_transaccionales.sh" "Backup TRANSACCIONALES" || exit 1
run_step "$BASE_DIR/scripts/clean_old.sh" "Backup CLEAN_OLD" || exit 1

echo "✔ Todos los procesos terminaron correctamente." | tee -a "$LOG_FILE"

# --- GIT PUSH SOLO SI TODO FUE OK ---
cd "$BASE_DIR"

echo "▶ Subiendo cambios a GitHub..." | tee -a "$LOG_FILE"

git add . >> "$LOG_FILE" 2>&1
git commit -m "Backup automático $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE" 2>&1
git push origin main >> "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo "❌ ERROR: No se pudo hacer push a GitHub." | tee -a "$LOG_FILE"
    exit 1
fi

echo "✔ Push a GitHub completado." | tee -a "$LOG_FILE"
echo "===== RUN ALL END: $(date) =====" | tee -a "$LOG_FILE"
