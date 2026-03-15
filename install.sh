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
  echo -e "${CYAN}[+]                AUTO INSTALLER THEMA             [+]${NC}"
  echo -e "${CYAN}[+]                  © RAFFIACTLY                   [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "𝗧𝗘𝗟𝗘𝗚𝗥𝗔𝗠 : @Raffioffci2"
  echo -e "𝗖𝗥𝗘𝗗𝗜𝗧𝗦  : Raffi"
  sleep 3
}

install_jq() {
  echo -e "${BLUE}[+] Installing JQ...${NC}"
  sudo apt update && sudo apt install -y jq unzip wget
  clear
}

check_token() {
  echo -e "${YELLOW}MASUKKAN AKSES TOKEN :${NC}"
  read -r USER_TOKEN
  if [ "$USER_TOKEN" != "raffi" ]; then
    echo -e "${RED}Token Salah!${NC}"
    exit 1
  fi
  clear
}

install_theme() {
  # Pilih Tema (Sama seperti sebelumnya)
  THEME_URL="https://github.com/gitfdil1248/thema/raw/main/C2.zip"
  
  cd /var/www/pterodactyl || exit
  
  echo -e "${BLUE}[+] Mendownload Assets Raffiactly...${NC}"
  wget -q -O raffiactly.zip "$THEME_URL"
  unzip -o raffiactly.zip
  
  # --- BAGIAN PALING PENTING: MENGUBAH NAMA PTERODACTYL MENJADI RAFFIACTLY ---
  echo -e "${CYAN}[+] Mengubah Branding Sistem menjadi Raffiactly...${NC}"
  
  # Ubah di file .env (Nama Panel)
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  
  # Ubah di file Konfigurasi App
  sed -i "s/'name' => .*/'name' => 'Raffiactly',/g" config/app.php
  
  # Ubah paksa di file Blade (Tampilan Atas/Navbar)
  find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +
  
  # --- Proses Build ---
  echo -e "${BLUE}[+] Memulai Build Production...${NC}"
  sudo npm i -g yarn
  yarn install
  yarn build:production
  
  # Clear Cache agar perubahan langsung terlihat
  php artisan view:clear
  php artisan config:clear
  php artisan cache:clear
  
  # Fix Permissions
  sudo chown -R www-data:www-data /var/www/pterodactyl/*
  
  echo -e "${GREEN}[✔] RAFFIACTLY BERHASIL DIINSTAL!${NC}"
  sleep 2
}

# --- Jalankan Script ---
display_welcome
install_jq
check_token
install_theme

# Menu Utama (Opsional untuk Wings/Node)
while true; do
  clear
  echo -e "${CYAN}RAFFIACTLY DASHBOARD${NC}"
  echo "1. Install Wings"
  echo "2. Create Node"
  echo "x. Exit"
  read -r PILIH
  case "$PILIH" in
    1) curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings ;;
    2) # Jalankan fungsi create_node yang tadi
       ;;
    x) exit 0 ;;
  esac
done
