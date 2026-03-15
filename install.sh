#!/bin/bash

# --- Color Palette ---
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# --- 1. Welcome Banner Keren ---
display_welcome() {
  clear
  echo -e "${CYAN}          .                                                      .${NC}"
  echo -e "${CYAN}        .n                   .                 .                  n.${NC}"
  echo -e "${CYAN}  .   .dP                  dP                   Bb                 9b.    .${NC}"
  echo -e "${CYAN} 4    qXb         .       dXp     .              dBp       .        dXp    t${NC}"
  echo -e "${CYAN} dXb  qXb         .       dXp     .              dBp       .        dXp    dXb${NC}"
  echo -e "${BLUE} [!] =================================================================== [!]${NC}"
  echo -e "${CYAN} [!]                 ${WHITE}🚀 RAFFIACTLY ULTIMATE PROJECT 🚀${CYAN}                 [!]"
  echo -e "${CYAN} [!]${NC}               ${PURPLE}Powered by @Raffioffci2 | Version 1.0.0${NC}             ${CYAN}[!]${NC}"
  echo -e "${BLUE} [!] =================================================================== [!]${NC}"
  echo -e ""
  echo -e "${WHITE}  - DEVELOPER :${NC} ${CYAN}Raffi${NC}"
  echo -e "${WHITE}  - TELEGRAM  :${NC} ${CYAN}@Raffioffci2${NC}"
  echo -e "${WHITE}  - STATUS    :${NC} ${GREEN}PREMIUM PRIVATE SCRIPT${NC}"
  echo -e ""
  echo -e "${BLUE} [*] Starting system initialization...${NC}"
  sleep 3
}

# --- 2. Token Check ---
check_token() {
  echo -ne "${YELLOW}MASUKKAN AKSES TOKEN : ${NC}"
 read -t 5 -r USER_TOKEN
if [ "$USER_TOKEN" != "raffi" ]; then
    echo "TOKEN SALAH!"
    exit 1
fi
}

# --- 3. Auto Install Panel & Branding ---
install_panel() {
  echo -e "${BLUE}[+] Menginstall Mesin Panel (Auto Input)...${NC}"
  
  # Install Pterodactyl Standar (Otomatis)
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

  echo -e "${CYAN}[+] Menyuntikkan Tema & Branding Raffiactly...${NC}"
  cd /var/www/pterodactyl || exit
  
  # Download & Pasang Tema
  wget -q -O raffi.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
  unzip -o raffi.zip
  cp -rfT /root/pterodactyl /var/www/pterodactyl
  
  # Ubah Nama Sistem Secara Total
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

  # --- FIX LOGIN & DATABASE ---
  php artisan migrate --force
  php artisan config:clear
  php artisan view:clear
  php artisan session:table
  php artisan key:generate --force

  # Buat Akun Admin (Bisa Login)
  php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF

  # Build Production & Permissions
  npm i -g yarn && yarn install && yarn build:production
  chown -R www-data:www-data /var/www/pterodactyl/*
  chmod -R 775 storage bootstrap/cache
}

# --- 4. Install Wings & Node ---
install_wings_node() {
  echo -e "${BLUE}[+] Memasang Wings & Menghubungkan VPS...${NC}"
  curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
  systemctl enable --now wings

  # Create Location
  php artisan p:location:make <<EOF
Indonesia
Raffiactly-Node
EOF

  # Create Node
  php artisan p:node:make <<EOF
Node-Raffiactly
Auto-Created-By-Bot
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
}

# --- Jalankan Semua Fungsi ---
display_welcome
check_token
install_panel
install_wings_node

echo -e "${GREEN}==================================================${NC}"
echo -e "${CYAN}      RAFFIACTLY BERHASIL TERPASANG TOTAL!       ${NC}"
echo -e "${WHITE}  Login Email: admin@raffi.com                   ${NC}"
echo -e "${WHITE}  Login Pass : raffi123                          ${NC}"
echo -e "${GREEN}==================================================${NC}"
