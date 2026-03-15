#!/bin/bash

# --- Color Palette ---
BLUE='\033[0;34m'       
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# --- 1. Branding Header ---
clear
echo -e "${PURPLE}[+] =============================================== [+]${NC}"
echo -e "${CYAN}[+]           RAFFIACTLY ULTIMATE INSTALLER         [+]${NC}"
echo -e "${CYAN}[+]             Created By @Raffioffci2             [+]${NC}"
echo -e "${PURPLE}[+] =============================================== [+]${NC}"
echo -e ""

# --- 2. Check Token ---
echo -ne "${YELLOW}MASUKKAN AKSES TOKEN : ${NC}"
read -r USER_TOKEN
if [ "$USER_TOKEN" != "raffi" ]; then
    echo -e "${RED}[✘] TOKEN SALAH!${NC}"
    exit 1
fi

# --- 3. Fungsi Utama Install & Fix ---
install_raffi_total() {
    echo -e "${BLUE}[+] Menyiapkan Direktori & Izin...${NC}"
    cd /var/www/pterodactyl || { echo -e "${RED}Folder tidak ditemukan!${NC}"; exit 1; }

    # Mendownload Tema Basis
    echo -e "${BLUE}[+] Mendownload Assets Raffiactly...${NC}"
    wget -q -O raffi_theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
    unzip -o raffi_theme.zip
    cp -rfT /root/pterodactyl /var/www/pterodactyl

    # --- INJEKSI BRANDING RAFFIACTLY ---
    echo -e "${CYAN}[+] Menerapkan Branding Raffiactly...${NC}"
    sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
    find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

    # --- FIX "NO INPUT FILE SPECIFIED" & ERROR 500 ---
    echo -e "${BLUE}[+] Memperbaiki Izin File & Cache...${NC}"
    
    # 1. Pastikan owner adalah www-data (sangat penting!)
    sudo chown -R www-data:www-data /var/www/pterodactyl/*
    
    # 2. Rebuild Database & Tampilan
    php artisan migrate --force
    php artisan view:clear
    php artisan config:clear
    php artisan cache:clear
    
    # 3. Jalankan Build Production
    npm i -g yarn
    yarn install
    yarn build:production
    
    # 4. Sekali lagi fix izin setelah build
    sudo chown -R www-data:www-data /var/www/pterodactyl/*
    chmod -R 755 storage bootstrap/cache

    echo -e "${GREEN}[✔] RAFFIACTLY BERHASIL DIPERBAIKI & DIINSTAL!${NC}"
}

# --- 4. Fungsi Auto Node ---
setup_node() {
    echo -e "${BLUE}[+] Membuat Node & Lokasi Otomatis...${NC}"
    IP_VPS=$(curl -s ifconfig.me)
    php artisan p:location:make <<EOF
Indonesia
Raffiactly Location
EOF

    php artisan p:node:make <<EOF
Node-Raffiactly
Node Created By Bot
1
https
$IP_VPS
yes
no
no
4096
4096
10240
10240
100
8080
2022
/var/lib/pterodactyl/volumes
EOF
    echo -e "${GREEN}[✔] Node Siap!${NC}"
}

# --- Eksekusi ---
install_raffi_total
setup_node

echo -e ""
echo -e "${PURPLE}==================================================${NC}"
echo -e "${GREEN}      Selesai! Silakan Refresh Browser Anda.      ${NC}"
echo -e "${PURPLE}==================================================${NC}"
