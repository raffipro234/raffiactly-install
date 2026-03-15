#!/bin/bash

# --- Warna ---
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m'

# --- 1. Welcome Raffiactly ---
clear
echo -e "${CYAN}🚀 RAFFIACTLY ULTIMATE PROJECT - FULL AUTO BYPASS 🚀${NC}"
echo -e "${PURPLE}Created By @Raffioffci2${NC}"

# --- 2. Hardcoded Token Bypass ---
# Kita langsung set token di sini agar tidak perlu menunggu input bot
VALID_TOKEN="raffi"
USER_TOKEN=$1 # Bot harus kirim lewat argumen: bash install.sh raffi

if [ "$USER_TOKEN" != "$VALID_TOKEN" ]; then
    echo -e "${RED}[X] TOKEN TIDAK VALID!${NC}"
    exit 1
fi

echo -e "${GREEN}[V] TOKEN DITERIMA! MEMULAI INSTALASI...${NC}"

# --- 3. Fix Connection Refused & DNS ---
# Menambah DNS Google agar tidak error 'Could not resolve host'
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apt update && apt install -y jq unzip wget curl sudo

# --- 4. Install Panel (Full Auto) ---
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

# --- 5. Branding & Fix Login ---
cd /var/www/pterodactyl || exit
wget -q -O theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
unzip -o theme.zip
cp -rfT /root/pterodactyl /var/www/pterodactyl

# Ubah Nama Raffiactly
sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

# Fix Login Error 500
php artisan config:clear
php artisan view:clear
php artisan session:table
php artisan key:generate --force
php artisan migrate --force
chown -R www-data:www-data /var/www/pterodactyl/*
chmod -R 775 storage bootstrap/cache

systemctl restart nginx
echo -e "${GREEN}[✔] RAFFIACTLY SUKSES TERPASANG!${NC}"
