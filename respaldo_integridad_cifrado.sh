#!/bin/bash

# ===================================================
# SCRIPT DE RESPALDO, INTEGRIDAD Y CIFRADO
# Autor: Mary Araujo & Luis Sedano
# Fecha: 10-07-2025
# Descripción: Crea respaldo de base de datos,
# genera hash MD5 y cifra el respaldo con gocryptfs
# ===================================================

# === PARÁMETROS DEL RESPALDO ===
usuario_bd="luis"
password_bd="12345678"
nombre_bd="equipo"
directorio_respaldo="/tmp"
fecha=$(date +"%Y-%m-%d-%H-%M-%S")
archivo_sql="$directorio_respaldo/${nombre_bd}-${fecha}.sql"
archivo_md5="$archivo_sql.md5"

# === PARÁMETROS DE CIFRADO ===
carpeta_cifrada="$HOME/gocryptfs/backup-cifrado"
carpeta_montada="$HOME/gocryptfs/backup-descifrado"
archivo_pass="$HOME/.gocryptfs_keys/pwd.txt"

# === CREAR RESPALDO ===
echo "📦 Realizando respaldo de '$nombre_bd'..."
mysqldump -u$usuario_bd -p$password_bd $nombre_bd > "$archivo_sql"

if [ $? -eq 0 ]; then
    echo "✅ Respaldo creado: $archivo_sql"

    # === CREAR HASH MD5 ===
    echo "🔐 Generando archivo de integridad MD5..."
    md5sum "$archivo_sql" > "$archivo_md5"
    echo "✅ Hash creado: $archivo_md5"

    # === CIFRADO DEL RESPALDO ===
    echo "🔒 Preparando cifrado con gocryptfs..."

    # Crear carpetas si no existen
    mkdir -p "$carpeta_cifrada"
    mkdir -p "$carpeta_montada"

    # Montar sistema cifrado
    echo "🔑 Montando volumen cifrado..."
    gocryptfs -passfile "$archivo_pass" "$carpeta_cifrada" "$carpeta_montada"

    if [ $? -eq 0 ]; then
        echo "📁 Copiando respaldo cifrado..."
        cp "$archivo_sql" "$carpeta_montada/"
        cp "$archivo_md5" "$carpeta_montada/"
        
        # Desmontar volumen
        fusermount -u "$carpeta_montada"
        echo "✅ Respaldo cifrado y desmontado correctamente."
    else
        echo "❌ Error al montar volumen cifrado. Verifica la contraseña o ruta."
    fi
else
    echo "❌ Error en la creación del respaldo. Verifica los datos."
fi

