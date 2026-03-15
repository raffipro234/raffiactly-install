#!/bin/bash

# --- Variabel Warna ---
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# --- 1. Welcome Banner (Tanpa Delay Agar Cepat) ---
clear
echo -e "${CYAN}🚀 RAFFIACTLY ULTIMATE PROJECT - FULL AUTO BYPASS 🚀${NC}"
echo -e "${PURPLE}Created By @Raffioffci2${NC}"

# --- 2. Auto Token Bypass ---
# Kita buat agar script bisa menerima token via pipe (echo "raffi" | bash)
# Jika tidak ada input dalam 2 detik, dia cek argumen pertama
read -t 2 -r INPUT_TOKEN
USER_TOKEN=${INPUT_TOKEN:-$1}

if [ "$USER_TOKEN" != "raffi" ]; then
    echo -e "${RED}[✘] TOKEN SALAH ATAU KOSONG!${NC}"
    exit 1
fi

# --- 3. Pre-Install (Anti Connection Refused) ---
apt update && apt install -y jq unzip wget curl sudo
systemctl stop nginx # Matikan dulu agar tidak bentrok saat install

# --- 4. Install Panel Raffiactly (Full Silent) ---
echo -e "${BLUE}[+] Installing Panel & Injecting Raffiactly Theme...${NC}"
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
Raffi
raffi123
$(curl -s ifconfig.me)
EOF

# --- 5. Branding & Fix Login (Suntikan Raffiactly) ---
cd /var/www/pterodactyl || exit
wget -q -O theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
unzip -o theme.zip
cp -rfT /root/pterodactyl /var/www/pterodactyl

# Ubah Nama Total
sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

# Jamu Agar Bisa Login (Anti Error 500)
php artisan config:clear
php artisan view:clear
php artisan session:table
php artisan key:generate --force
php artisan migrate --force

# Akun Admin Cadangan: admin@raffi.com | Pass: raffi123
php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF

# --- 6. Build & Permissions ---
npm i -g yarn && yarn install && yarn build:production
chown -R www-data:www-data /var/www/pterodactyl/*
chmod -R 775 storage bootstrap/cache

# --- 7. Wings & Node Auto ---
curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
systemctl enable --now wings

# Create Node
php artisan p:location:make <<EOF
Indonesia
Raffiactly-Node
EOF

php artisan p:node:make <<EOF
Node-Raffiactly
Auto-Created
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

systemctl restart nginx
echo -e "${GREEN}[✔] RAFFIACTLY BERHASIL TERPASANG TOTAL!${NC}"
