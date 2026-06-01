#!/bin/bash

# Asegurar que sea ejecutado con sudo
if [[ $EUID -ne 0 ]]; then
   echo "Por favor, ejecútalo como root: sudo ./install.sh"
   exit 1
fi

# --- ARTE ROUBIAN ---
clear
echo "======================================================"
echo "    ____  ____  __  __ ____  ___    _    _   _ "
echo "   |  _ \| __ )|  |  | __ )/ _ \  / \  | \ | |"
echo "   | |_) |  _ \| |  | | _ \ (_) |/ _ \ |  \| |"
echo "   |  _ <| |_) | |__| |_) \__, / ___ \| |\  |"
echo "   |_| \_\____/ \____/____/  /_/_/   \_\_| \_|"
echo "                                              "
echo "         --- THE ROUBIAN OS INSTALLER ---     "
echo "======================================================"
echo ""

# 1. Instalar Kernel XanMod
echo "[1/5] Instalando Kernel XanMod..."
wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list
apt update && apt install -y linux-xanmod-x64v3

# 2. Instalar paquetes de hardware y entorno
echo "[2/5] Instalando programas, drivers y control de hardware..."
apt update && apt install -y \
    xorg openbox polybar picom kitty rofi feh curl git \
    nitrogen pcmanfm lxappearance thunar build-essential unzip \
    fonts-font-awesome \
    network-manager network-manager-gnome \
    pulseaudio pavucontrol alsa-utils \
    bluez bluez-tools blueman \
    brightnessctl acpi

# 3. Instalación de Fuentes
echo "[3/5] Configurando fuentes..."
mkdir -p /usr/local/share/fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip -q JetBrainsMono.zip -d /usr/local/share/fonts/
fc-cache -fv
rm JetBrainsMono.zip

# 4. Despliegue de Configuración
echo "[4/5] Desplegando configuraciones..."
USER_HOME=$(eval echo ~$SUDO_USER)
mkdir -p "$USER_HOME/.config"

# Copiar configuración desde la carpeta 'config' del repo
cp -r config/* "$USER_HOME/.config/"

# Copiar fondo de pantalla
if [ -d "assets" ]; then
    mkdir -p "$USER_HOME/Pictures/Wallpapers"
    cp assets/* "$USER_HOME/Pictures/Wallpapers/"
fi

# 5. Habilitar servicios
echo "[5/5] Activando servicios del sistema..."
systemctl enable --now NetworkManager
systemctl enable --now bluetooth

# Aplicar permisos
chown -R $SUDO_USER:$SUDO_USER "$USER_HOME/.config"
chown -R $SUDO_USER:$SUDO_USER "$USER_HOME/Pictures/Wallpapers"
chmod +x "$USER_HOME/.config/openbox/scripts/"* 2>/dev/null

echo ""
echo "======================================================"
echo " ROUBIAN INSTALADO. AHORA TIENES:"
echo " - Wi-Fi/Red (NetworkManager)"
echo " - Bluetooth (Blueman)"
echo " - Audio (PulseAudio)"
echo " - Brillo (Brightnessctl)"
echo " REINICIA PARA CARGAR EL KERNEL XANMOD."
echo "======================================================"
