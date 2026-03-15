#!/bin/bash

# Color
BLUE='\033[0;34m'        
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- Identitas ---
display_welcome() {
  clear
  echo -e "${BLUE}🚀 RAFFIACTLY ULTIMATE PROJECT - FULL AUTO BYPASS 🚀${NC}"
  echo -e "${CYAN}Created By @Raffioffci2${NC}"
  echo -e "-------------------------------------------------------"
}

# --- Token Check ---
check_token() {
  echo -en "${BLUE}[*] MASUKKAN AKSES TOKEN : ${NC}"
  read -r USER_TOKEN
  if [ "$USER_TOKEN" != "raffi" ]; then
    echo -e "${RED}[X] TOKEN SALAH ATAU KOSONG!${NC}"
    exit 1
  fi
}

# --- Fix Error 403 & Install Panel ---
install_panel() {
  echo -e "${BLUE}[+] Memulai Instalasi & Perbaikan Permission...${NC}"
  
  # Generate Password Acak (Biar gak statis di script)
  RANDOM_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
  ADMIN_EMAIL="admin@$(curl -s ifconfig.me | tr '.' '-').com"

  # Install Core
  bash <(curl -s https://pterodactyl-installer.se) <<EOF
0
raffi
raffi
raffi
raffi
Asia/Jakarta
$ADMIN_EMAIL
$ADMIN_EMAIL
raffiadmin
Raffi
$RANDOM_PASS
$(curl -s ifconfig.me)
EOF

  # FORCE BRANDING & FIX 403
  cd /var/www/pterodactyl || exit
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  sed -i "s/'name' => .*/'name' => 'Raffiactly',/g" config/app.php
  
  # Perbaikan Permission (Obat 403 Forbidden)
  chmod -R 755 storage bootstrap/cache
  chown -R www-data:www-data /var/www/pterodactyl/*
  
  # Finalisasi Database
  php artisan config:clear
  php artisan view:clear
  php artisan migrate --force
  systemctl restart nginx

  # --- OUTPUT KE BOT / TERMINAL ---
  echo -e "\n${GREEN}[✔] INSTALASI BERHASIL!${NC}"
  echo -e "${CYAN}DETAIL LOGIN TELAH DI-GENERATE:${NC}"
  echo -e "URL      : http://$(curl -s ifconfig.me)"
  echo -e "User     : $ADMIN_EMAIL"
  echo -e "Password : $RANDOM_PASS"
  echo -e "-------------------------------------------------------"
  echo -e "${RED}SIMPAN DATA INI, TIDAK ADA DI DALAM SCRIPT!${NC}"
  sleep 5
}

# --- Install Wings (Bypass DNS) ---
install_wings() {
  echo -e "${BLUE}[+] Install Wings via IP...${NC}"
  IP_VPS=$(curl -s ifconfig.me)
  bash <(curl -sL https://get.pterodactyl.io) <<EOF
y
y
y
y
$IP_VPS
EOF
  systemctl enable --now wings
}

# --- Logic Menu ---
display_welcome
check_token

while true; do
  echo -e "\n1. Install Panel (Fix 403 & Auto Pass)"
  echo "2. Install Wings"
  echo "x. Exit"
  read -p "Pilih: " PILIH
  case "$PILIH" in
    1) install_panel ;;
    2) install_wings ;;
    x) exit 0 ;;
  esac
done
