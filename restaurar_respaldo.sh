#!/bin/bash

# ================================================
# RESTAURACIÓN DE RESPALDO MySQL
# Autor: Mary Araujo & Luis Sedano
# ================================================

RESPALDO_SQL=$(ls -t /tmp/equipo-*.sql | head -n 1)
MYSQL_USER="luis"
MYSQL_PASS="12345678"
BASE_DATOS="equipo"

echo "♻️ Restaurando respaldo: $RESPALDO_SQL"

# Validar que el archivo exista
if [[ ! -f "$RESPALDO_SQL" ]]; then
    echo "❌ Error: El respaldo no existe en $RESPALDO_SQL"
    exit 1
fi

# Verificar que la base exista o crearla
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" -e "CREATE DATABASE IF NOT EXISTS $BASE_DATOS;"

# Restaurar el respaldo
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$BASE_DATOS" < "$RESPALDO_SQL"

# Confirmar restauración
echo "🔍 Verificando tablas restauradas:"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" -e "SHOW TABLES FROM $BASE_DATOS;"

echo "✅ Restauración completada correctamente."

