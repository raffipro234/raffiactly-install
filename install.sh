#!/bin/bash

# Warna
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# --- LOGIKA OTOMATIS UNTUK BOT ---
# Jika bot memanggil dengan argument tertentu
ACTION=$1

install_dependencies() {
    apt update && apt install -y jq unzip wget curl sudo
}

# --- FUNGSI INSTALL PANEL RAFFIACTLY ---
install_panel_raffi() {
    echo -e "${BLUE}[+] MEMULAI INSTALL PANEL RAFFIACTLY...${NC}"
    # 1. Install Pterodactyl Standar dulu sebagai mesin
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

    # 2. Suntik Tema & Branding Raffiactly (BIAR BEDA!)
    cd /var/www/pterodactyl || exit
    wget -q -O raffi.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
    unzip -o raffi.zip
    cp -rfT /root/pterodactyl /var/www/pterodactyl
    
    # Ubah Nama Total
    sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
    find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +
    
    # Build Production
    npm i -g yarn && yarn install && yarn build:production
    php artisan view:clear
    sudo chown -R www-data:www-data /var/www/pterodactyl/*
    echo -e "${GREEN}[✔] PANEL RAFFIACTLY SUKSES!${NC}"
}

# --- FUNGSI INSTALL WINGS ---
install_wings_raffi() {
    echo -e "${BLUE}[+] MEMULAI INSTALL WINGS RAFFIACTLY...${NC}"
    curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
    systemctl enable --now wings
    echo -e "${GREEN}[✔] WINGS SUKSES!${NC}"
}

# --- FUNGSI CREATE NODE & LOC ---
create_node_raffi() {
    echo -e "${BLUE}[+] MEMBUAT NODE & LOKASI...${NC}"
    IP_VPS=$(curl -s ifconfig.me)
    cd /var/www/pterodactyl || exit
    
    # Create Location
    php artisan p:location:make <<EOF
Indonesia
Raffiactly-Loc
EOF

    # Create Node
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
    echo -e "${GREEN}[✔] NODE & LOC SUKSES!${NC}"
}

# --- EKSEKUSI BERDASARKAN INPUT BOT ---
install_dependencies

# Cek apakah bot minta install panel, wings, atau node
# (Kamu bisa atur di bot: command = bash install.sh panel)
if [[ "$ACTION" == "panel" ]]; then
    install_panel_raffi
elif [[ "$ACTION" == "wings" ]]; then
    install_wings_raffi
elif [[ "$ACTION" == "node" ]]; then
    create_node_raffi
else
    # Jika dijalankan manual/biasa
    install_panel_raffi
    create_node_raffi
    install_wings_raffi
fi
