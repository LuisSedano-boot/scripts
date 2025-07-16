#!/bin/bash

# ===================================================
# CONTINUIDAD DEL NEGOCIO: copia, simula fallo y restaura
# Autor: Mary Araujo & Luis Sedano
# ===================================================

RESPALDO_ORIGEN=$(ls -t /tmp/equipo-*.sql | head -n 1)
BACKUP_DIR="/var/infraestructura/backups"
MYSQL_USER="luis"
MYSQL_PASS="12345678"
BASE_DATOS="equipo"

echo "📁 Creando carpeta de respaldo si no existe..."
mkdir -p "$BACKUP_DIR"

# Validar que el respaldo exista
if [[ ! -f "$RESPALDO_ORIGEN" ]]; then
    echo "❌ Error: No se encontró $RESPALDO_ORIGEN"
    exit 1
fi

# Copiar respaldo a infraestructura
cp "$RESPALDO_ORIGEN" "$BACKUP_DIR/"
RESPALDO_COPIA="$BACKUP_DIR/$(basename "$RESPALDO_ORIGEN")"

echo "✅ Copia guardada en: $RESPALDO_COPIA"

# Simular pérdida (eliminar base de datos)
echo "⚠️ Simulando fallo: eliminando base de datos '$BASE_DATOS'..."
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" -e "DROP DATABASE IF EXISTS $BASE_DATOS; CREATE DATABASE $BASE_DATOS;"

# Restaurar desde copia
echo "♻️ Restaurando desde copia de seguridad..."
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$BASE_DATOS" < "$RESPALDO_COPIA"

# Confirmar recuperación
echo "🔍 Verificando tablas recuperadas:"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" -e "SHOW TABLES FROM $BASE_DATOS;"

echo "✅ Continuidad del negocio comprobada. BD restaurada desde copia."

