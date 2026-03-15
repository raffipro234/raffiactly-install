#!/bin/bash

# Color
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# --- 1. Persiapan Awal ---
apt update && apt install -y jq unzip wget curl sudo

# --- 2. Install Panel & Branding Raffiactly ---
install_panel() {
    echo -e "${BLUE}[+] MEMULAI INSTALL PANEL RAFFIACTLY...${NC}"
    
    # Install Pterodactyl Otomatis (Settingan Default)
    bash <(curl -s https://pterodactyl-installer.se) <<EOF
0
raffi
raffi
raffi
raffi
Asia/Jakarta
admin@raffi.com
admin@raffi.com
raffiadmin
raffi
raffi123
$(curl -s ifconfig.me)
EOF

    # --- SUNTIK TEMA & BRANDING (WAJIB) ---
    cd /var/www/pterodactyl || exit
    wget -q -O raffi.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
    unzip -o raffi.zip
    cp -rfT /root/pterodactyl /var/www/pterodactyl
    
    # Ubah Nama Sistem
    sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
    find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

    # --- FIX LOGIN & DATABASE ---
    echo -e "${CYAN}[+] Menyinkronkan Database & Build...${NC}"
    php artisan migrate --force
    php artisan db:seed --force
    
    # Build Production
    npm i -g yarn && yarn install && yarn build:production
    
    # Fix Permission (Biar gak 500 error)
    php artisan view:clear
    php artisan config:clear
    sudo chown -R www-data:www-data /var/www/pterodactyl/*
    
    # Membuat Akun Admin Otomatis (BIAR BISA LOGIN)
    # Email: admin@raffi.com | Pass: raffi123
    php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF

    echo -e "${GREEN}[✔] PANEL RAFFIACTLY SIAP! LOGIN: admin@raffi.com | PASS: raffi123${NC}"
}

# --- 3. Install Wings ---
install_wings() {
    echo -e "${BLUE}[+] MEMULAI INSTALL WINGS...${NC}"
    curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
    systemctl enable --now wings
}

# --- 4. Create Node & Location ---
create_node() {
    echo -e "${BLUE}[+] MENGHUBUNGKAN NODE...${NC}"
    IP_VPS=$(curl -s ifconfig.me)
    cd /var/www/pterodactyl || exit
    
    php artisan p:location:make <<EOF
Indonesia
Raffiactly-Node
EOF

    php artisan p:node:make <<EOF
Node-Raffiactly
Node-Raffi
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
}

# Jalankan semua proses
install_panel
create_node
install_wings
