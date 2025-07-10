
#!/bin/bash

# ================================
# SCRIPT PARA ACTUALIZACIÓN Y CONFIGURACIÓN DE ZONA HORARIA
# Autor: Mary Araujo
# Fecha: 10-07-2025
# ================================

echo "🛠️ Iniciando actualización del sistema..."
sudo apt update && sudo apt upgrade -y

echo "✅ Sistema actualizado."

echo ""
echo "⏰ Mostrando configuración actual de fecha, hora y zona horaria:"
timedatectl

echo ""
echo "🌐 Estableciendo zona horaria a America/Mexico_City..."
sudo timedatectl set-timezone America/Mexico_City

echo ""
echo "🔁 Activando sincronización automática con NTP..."
sudo timedatectl set-ntp true

echo ""
echo "✅ Verificando configuración final:"
timedatectl

echo ""
echo "🔎 Verificando sincronización NTP:"
timedatectl show-timesync --all

echo ""
echo "✅ Script finalizado correctamente. El servidor está actualizado y con la hora configurada."

