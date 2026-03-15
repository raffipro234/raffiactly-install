#!/bin/bash

# Color
BLUE='\033[0;34m'        
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

display_welcome() {
  clear
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${CYAN}[+]           AUTO INSTALLER RAFFIACTLY             [+]${NC}"
  echo -e "${CYAN}[+]                © @Raffioffci2                   [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "𝗧𝗘𝗟𝗘𝗚𝗥𝗔𝗠 : @Raffioffci2"
  echo -e "𝗖𝗥𝗘𝗗𝗜𝗧𝗦  : Raffi"
  sleep 3
}

install_jq() {
  echo -e "${BLUE}[+] Installing Dependencies...${NC}"
  sudo apt update && sudo apt install -y jq unzip wget curl sudo
  clear
}

# --- FUNGSI INSTALL PANEL (Agar Bisa Login) ---
install_panel() {
  echo -e "${BLUE}[+] Memulai Instalasi Panel Raffiactly...${NC}"
  
  # Auto-install engine utama (Biar web gak refused)
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

  # Install Tema Raffiactly
  cd /var/www/pterodactyl || exit
  echo -e "${BLUE}[+] Mendownload Assets Raffiactly...${NC}"
  wget -q -O raffiactly.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
  unzip -o raffiactly.zip
  cp -rfT /root/pterodactyl /var/www/pterodactyl

  # Branding Branding
  echo -e "${CYAN}[+] Mengubah Branding menjadi Raffiactly...${NC}"
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

  # --- JAMU LOGIN (Biar Pasti Bisa Masuk) ---
  php artisan config:clear
  php artisan view:clear
  php artisan session:table
  php artisan key:generate --force
  php artisan migrate --force
  
  # Bikin Akun Admin (Login: admin@raffi.com | Pass: raffi123)
  php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF

  chown -R www-data:www-data /var/www/pterodactyl/*
  systemctl restart nginx
  
  echo -e "${GREEN}[✔] PANEL BERHASIL DIINSTAL!${NC}"
  echo -e "${YELLOW}Login: admin@raffi.com | Pass: raffi123${NC}"
  sleep 3
}

# --- FUNGSI CREATE NODE & LOCATION ---
create_node() {
  echo -e "${BLUE}[+] Membuat Lokasi & Node Baru...${NC}"
  read -p "Masukkan nama Node: " node_name
  read -p "Masukkan RAM (MB): " node_ram
  
  cd /var/www/pterodactyl || exit
  
  # Create Location
  php artisan p:location:make <<EOF
Indonesia
Raffi-Loc
EOF

  # Create Node
  php artisan p:node:make <<EOF
$node_name
Auto-Node
1
https
$(curl -s ifconfig.me)
yes
no
no
$node_ram
$node_ram
10240
10240
100
8080
2022
/var/lib/pterodactyl/volumes
EOF
  echo -e "${GREEN}[✔] NODE & LOCATION BERHASIL DIBUAT!${NC}"
  sleep 2
}

# --- JALANKAN PROSES AWAL ---
display_welcome
install_jq

# --- MENU DASHBOARD ---
while true; do
  clear
  echo -e "${CYAN}RAFFIACTLY ULTIMATE DASHBOARD${NC}"
  echo "1. Install Full Panel & Theme (Bisa Login)"
  echo "2. Install Wings"
  echo "3. Create Node & Location"
  echo "4. Uninstall Panel"
  echo "x. Exit"
  echo -e "${BLUE}-----------------------------------------------${NC}"
  read -p "Pilih menu: " PILIH
  
  case "$PILIH" in
    1) install_panel ;;
    2) curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings ;;
    3) create_node ;;
    4) bash <(curl -s https://pterodactyl-installer.se) <<EOF
y
y
y
y
EOF
    ;;
    x) exit 0 ;;
    *) echo "Pilihan tidak valid!" ; sleep 1 ;;
  esac
done
