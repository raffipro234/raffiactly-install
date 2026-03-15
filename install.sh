#!/bin/bash

# --- Warna Raffiactly ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

# Ambil Argument dari Bot (panel / wings / node)
ACTION=$1

# --- 1. Welcome Banner Raffiactly ---
display_welcome() {
  clear
  echo -e "${CYAN}          .                                                      .${NC}"
  echo -e "${CYAN}        .n                   .                 .                  n.${NC}"
  echo -e "${CYAN}  .   .dP                  dP                   Bb                 9b.    .${NC}"
  echo -e "${CYAN} 4    qXb         .       dXp     .              dBp       .        dXp    t${NC}"
  echo -e "${CYAN} dXb  qXb         .       dXp     .              dBp       .        dXp    dXb${NC}"
  echo -e "${BLUE} [!] =================================================================== [!]${NC}"
  echo -e "${CYAN} [!]                 🚀 RAFFIACTLY ULTIMATE PROJECT 🚀                 [!]"
  echo -e "${CYAN} [!]               Powered by @Raffioffci2 | Mode: $ACTION             ${CYAN}[!]${NC}"
  echo -e "${BLUE} [!] =================================================================== [!]${NC}"
  sleep 2
}

# --- 2. Fungsi Install Panel (Full Branding & Login Fix) ---
install_panel() {
  echo -e "${BLUE}[+] Menginstall Engine & Branding Raffiactly...${NC}"
  
  # DNS Fix agar tidak error host
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
  
  # Auto Install Pterodactyl Resmi
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

  # Injeksi Tema & Ganti Nama ke Raffiactly
  cd /var/www/pterodactyl || exit
  wget -q -O theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
  unzip -o theme.zip
  cp -rfT /root/pterodactyl /var/www/pterodactyl
  
  # Branding Raffiactly (Cari & Ganti Semua Kata Pterodactyl)
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

  # --- FIX LOGIN TOTAL ---
  php artisan config:clear
  php artisan view:clear
  php artisan session:table
  php artisan key:generate --force
  php artisan migrate --force
  
  # Buat Akun Admin Pasti Jadi
  php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF

  # Izin Folder (Biar Gak Connection Refused/Error 500)
  chown -R www-data:www-data /var/www/pterodactyl/*
  chmod -R 775 storage bootstrap/cache
  
  npm i -g yarn && yarn install && yarn build:production
  systemctl restart nginx
  systemctl restart php8.1-fpm
  
  echo -e "${GREEN}[✔] PANEL RAFFIACTLY SIAP! LOGIN: admin@raffi.com | PASS: raffi123${NC}"
}

# --- 3. Fungsi Install Wings ---
install_wings() {
  echo -e "${BLUE}[+] Memasang Wings...${NC}"
  curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
  systemctl enable --now wings
  echo -e "${GREEN}[✔] WINGS BERHASIL TERPASANG!${NC}"
}

# --- 4. Fungsi Create Node ---
create_node() {
  echo -e "${BLUE}[+] Menghubungkan Node ke Panel...${NC}"
  cd /var/www/pterodactyl || exit
  
  php artisan p:location:make <<EOF
Indonesia
Raffiactly-Node
EOF

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
  echo -e "${GREEN}[✔] NODE BERHASIL DIBUAT!${NC}"
}

# --- Eksekusi Case ---
display_welcome
case $ACTION in
  "panel")
    install_panel
    ;;
  "wings")
    install_wings
    ;;
  "node")
    create_node
    ;;
  *)
    # Default jika tidak ada argument, jalankan panel
    install_panel
    ;;
esac
