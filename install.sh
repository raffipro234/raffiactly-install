#!/bin/bash

# --- Warna & Branding ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Ambil Argument (panel/wings/node)
ACTION=$1

# 1. Welcome Banner
display_welcome() {
  clear
  echo -e "${CYAN}🚀 RAFFIACTLY ULTIMATE PROJECT 🚀${NC}"
  echo -e "${PURPLE}Created By @Raffioffci2 | Mode: $ACTION${NC}"
  echo -e "${BLUE}========================================${NC}"
}

# 2. Fungsi Install Panel
install_panel() {
  echo -e "${BLUE}[+] Menginstall Engine & Branding Raffiactly...${NC}"
  
  # Install Pterodactyl (Full Auto)
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

  # Injeksi Tema & Fix Nama
  cd /var/www/pterodactyl || exit
  wget -q -O theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
  unzip -o theme.zip
  cp -rfT /root/pterodactyl /var/www/pterodactyl
  
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

  # --- JAMU FIX LOGIN (AGAR TIDAK ERROR 500) ---
  php artisan config:clear
  php artisan view:clear
  php artisan session:table
  php artisan key:generate --force
  php artisan migrate --force
  
  # Buat User Admin: admin@raffi.com | Pass: raffi123
  php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF

  chown -R www-data:www-data /var/www/pterodactyl/*
  chmod -R 775 storage bootstrap/cache
  systemctl restart nginx
  echo -e "${GREEN}[✔] PANEL RAFFIACTLY SIAP!${NC}"
}

# 3. Fungsi Wings
install_wings() {
  echo -e "${BLUE}[+] Memasang Wings...${NC}"
  curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
  systemctl enable --now wings
  echo -e "${GREEN}[✔] WINGS BERHASIL TERPASANG!${NC}"
}

# 4. Fungsi Node
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

# --- Eksekusi Berdasarkan Perintah Bot ---
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
    echo -e "${RED}Gunakan argument: panel, wings, atau node${NC}"
    ;;
esac
