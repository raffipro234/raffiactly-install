#!/bin/bash

# --- Warna & Branding ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. Welcome Banner (Langsung Jalan)
clear
echo -e "${CYAN}🚀 RAFFIACTLY ULTIMATE - AUTO DEPLOY 🚀${NC}"
echo -e "${CYAN}Powered by @Raffioffci2${NC}"
sleep 2

# 2. Persiapan System & DNS (Agar tidak Error Host)
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apt update && apt install -y jq unzip wget curl sudo

# 3. Install Panel Pterodactyl (Full Otomatis Tanpa Tanya)
echo -e "${BLUE}[+] Installing Engine...${NC}"
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

# 4. Injeksi Tema & Branding Raffiactly
echo -e "${BLUE}[+] Injecting Raffiactly Identity...${NC}"
cd /var/www/pterodactyl || exit
wget -q -O theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
unzip -o theme.zip
cp -rfT /root/pterodactyl /var/www/pterodactyl

# Ganti Nama Pterodactyl -> Raffiactly
sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

# 5. FIX LOGIN TOTAL (Penyebab Login Gagal/Error 500)
echo -e "${GREEN}[+] Fixing Login & Permissions...${NC}"
php artisan config:clear
php artisan view:clear
php artisan cache:clear
php artisan session:table
php artisan key:generate --force
php artisan migrate --force

# Buat User Admin yang PASTI BISA LOGIN
# Email: admin@raffi.com | Pass: raffi123
php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF

# Build Aset & Fix Folder (Wajib agar tidak Connection Refused)
npm i -g yarn && yarn install && yarn build:production
chown -R www-data:www-data /var/www/pterodactyl/*
chmod -R 775 storage bootstrap/cache

# 6. Install Wings & Restart Service
curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
systemctl enable --now wings
systemctl restart nginx
systemctl restart php8.1-fpm

echo -e "${GREEN}[✔] RAFFIACTLY BERHASIL TERPASANG!${NC}"
echo -e "🌐 Web: $(curl -s ifconfig.me)"
echo -e "📧 Login: admin@raffi.com | 🔑 Pass: raffi123"
