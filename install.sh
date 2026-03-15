#!/bin/bash

# --- Warna ---
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# --- 1. Branding Header ---
clear
echo -e "${BLUE}[+] =============================================== [+]${NC}"
echo -e "${CYAN}[+]                RAFFIACTLY PROJECT               [+]${NC}"
echo -e "${CYAN}[+]             Full Branding & Login Fix           [+]${NC}"
echo -e "${BLUE}[+] =============================================== [+]${NC}"
echo -e "Credits: @Raffioffci2"

# --- 2. Security Token ---
echo -ne "${YELLOW}MASUKKAN AKSES TOKEN : ${NC}"
read -r USER_TOKEN
if [ "$USER_TOKEN" != "raffi" ]; then
    echo -e "${RED}[✘] TOKEN SALAH!${NC}"
    exit 1
fi

# --- 3. Install Panel & Inject Tema ---
echo -e "${BLUE}[+] Menginstall Panel & Tema Raffiactly...${NC}"

# Jalankan installer resmi tapi dengan input otomatis
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

# --- 4. Proses Branding Raffiactly (Agar Nama Berubah) ---
cd /var/www/pterodactyl || exit
wget -q -O raffi_theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
unzip -o raffi_theme.zip
cp -rfT /root/pterodactyl /var/www/pterodactyl

# Ubah Nama Total
sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

# --- 5. PERBAIKAN LOGIN (WAJIB) ---
echo -e "${CYAN}[+] Memperbaiki Sistem Login...${NC}"
php artisan migrate --force
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan session:table # Menyiapkan tabel session agar bisa login

# Buat Akun Admin yang PASTI BISA LOGIN
# Ingat: Email admin@raffi.com | Pass: raffi123
php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF

# --- 6. Build Frontend & Permissions ---
npm i -g yarn && yarn install && yarn build:production
sudo chown -R www-data:www-data /var/www/pterodactyl/*
chmod -R 755 storage bootstrap/cache

# --- 7. Install Wings & Node ---
echo -e "${BLUE}[+] Memasang Wings & Node...${NC}"
curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
systemctl enable --now wings

# Create Loc & Node
php artisan p:location:make <<EOF
Indonesia
Raffiactly-Node
EOF

php artisan p:node:make <<EOF
Node-Raffiactly
Node-Raffi
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

echo -e "${GREEN}==================================================${NC}"
echo -e "${CYAN}      RAFFIACTLY SELESAI! LOGIN SEKARANG:        ${NC}"
echo -e "${WHITE}  Email: admin@raffi.com                         ${NC}"
echo -e "${WHITE}  Pass: raffi123                                 ${NC}"
echo -e "${GREEN}==================================================${NC}"
