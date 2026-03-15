#!/bin/bash

# --- Color Palette ---
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# --- 1. Welcome & Token Check ---
clear
echo -e "${BLUE}[+] =============================================== [+]${NC}"
echo -e "${CYAN}[+]                RAFFIACTLY PROJECT               [+]${NC}"
echo -e "${CYAN}[+]             Full Automatic Installer            [+]${NC}"
echo -e "${BLUE}[+] =============================================== [+]${NC}"
echo -e "Credits: @Raffioffci2"

# Token dari config.js bot kamu
echo -ne "MASUKKAN AKSES TOKEN : "
read -r USER_TOKEN
if [ "$USER_TOKEN" != "raffi" ]; then
    echo -e "${RED}[✘] TOKEN SALAH!${NC}"
    exit 1
fi

# --- 2. Install Panel Utama ---
echo -e "${BLUE}[+] Memulai Install Mesin Panel...${NC}"
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

# --- 3. Inject Tema & Branding Raffiactly ---
echo -e "${CYAN}[+] Menerapkan Desain Raffiactly & Fix Login...${NC}"
cd /var/www/pterodactyl || exit
wget -q -O raffi.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
unzip -o raffi.zip
cp -rfT /root/pterodactyl /var/www/pterodactyl

# Ubah Nama Pterodactyl menjadi Raffiactly di semua file
sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

# --- 4. Fix Database & Akun Admin ---
php artisan migrate --force
php artisan config:clear
php artisan view:clear
php artisan session:table

# Create Admin Login: admin@raffi.com | Pass: raffi123
php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF

# --- 5. Build Frontend & Permissions ---
npm i -g yarn && yarn install && yarn build:production
chown -R www-data:www-data /var/www/pterodactyl/*
chmod -R 775 storage bootstrap/cache

# --- 6. Install Wings & Auto Create Node ---
echo -e "${CYAN}[+] Memasang Wings & Menghubungkan VPS...${NC}"
curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
systemctl enable --now wings

# Create Location
php artisan p:location:make <<EOF
Indonesia
Raffiactly-Node
EOF

# Create Node Otomatis dengan IP VPS
php artisan p:node:make <<EOF
Node-Raffiactly
Created-By-Bot
1
https
$(curl -s ifconfig.me)
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

echo -e "${GREEN}[✔] INSTALLASI RAFFIACTLY SELESAI TOTAL!${NC}"
