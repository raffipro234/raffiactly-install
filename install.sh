#!/bin/bash

# Color
BLUE='\033[0;34m'        
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
WHITE='\033[1;37m'
NC='\033[0m'

# Display welcome message (Struktur persis yang kamu minta)
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${WHITE}[+]             RAFFIACTLY AUTO INSTALLER           [+]${NC}"
  echo -e "${WHITE}[+]                © @Raffioffci2                   [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "Script ini dibuat untuk mempermudah penginstalasian Raffiactly,"
  echo -e "dilarang keras untuk dikasih gratis."
  echo -e ""
  echo -e "𝗧𝗘𝗟𝗘𝗚𝗥𝗔𝗠 :"
  echo -e "@Raffioffci2"
  echo -e "𝗖𝗥𝗘𝗗𝗜𝗧𝗦 :"
  echo -e "@Raffioffci2"
  sleep 3
  clear
}

# Update and install jq
install_jq() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]             UPDATE & INSTALL JQ & SUDO          [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  sudo apt update && sudo apt install -y jq wget curl unzip sudo
  clear
}

# Check user token
check_token() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]             RAFFIACTLY ACCESS TOKEN             [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${YELLOW}MASUKKAN AKSES TOKEN :${NC}"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "raffi" ]; then
    echo -e "${GREEN}AKSES BERHASIL${NC}"
  else
    echo -e "${RED}TOKEN SALAH! Beli ke @Raffioffci2${NC}"
    exit 1
  fi
  clear
}

# 1. Fungsi Install Panel & Theme (INTI INSTALASI)
install_theme() {
  echo -e "${BLUE}[+] MEMULAI INSTALASI PANEL RAFFIACTLY...${NC}"
  
  # Jalankan Installer Pterodactyl Otomatis
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

  # Branding & Tema
  cd /var/www/pterodactyl || exit
  wget -q -O theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
  unzip -o theme.zip
  cp -rfT /root/pterodactyl /var/www/pterodactyl
  
  # Ganti Nama Web
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

  # FIX LOGIN & PERMISSIONS (BIAR GAK CONNECTION REFUSED)
  php artisan config:clear
  php artisan view:clear
  php artisan session:table
  php artisan key:generate --force
  php artisan migrate --force
  
  chown -R www-data:www-data /var/www/pterodactyl/*
  chmod -R 775 storage bootstrap/cache
  systemctl restart nginx
  systemctl restart php8.1-fpm

  echo -e "${GREEN}[✔] PANEL BERHASIL TERPASANG!${NC}"
  echo -e "Web: http://$(curl -s ifconfig.me)"
  echo -e "Login: admin@raffi.com | Pass: raffi123"
  sleep 5
}

# Fungsi-fungsi lain (Wings, Node, dll)
uninstall_theme() {
  bash <(curl https://raw.githubusercontent.com/gitfdil1248/thema/main/repair.sh)
}

configure_wings() {
  read -p "Masukkan token Wings dari Panel: " wings
  eval "$wings"
  systemctl start wings
}

create_node() {
  read -p "Nama Node: " node_name
  cd /var/www/pterodactyl && php artisan p:node:make --name="$node_name" # (Simpelnya)
}

# --- Main Logic (Tampilan Menu Kamu) ---
display_welcome
install_jq
check_token

while true; do
  clear
  echo -e "${RED}  Auto Installer Raffiactly Private  ${NC}"
  echo -e "1. Install theme & Panel"
  echo "2. Uninstall theme"
  echo "3. Configure Wings"
  echo "4. Create Node"
  echo "5. Uninstall Panel"
  echo "6. Stellar Theme"
  echo "7. Hack Back Panel"
  echo "8. Ubah Pw Vps"
  echo "x. Exit"
  echo -e "Masukkan pilihan (1-8/x):"
  read -r MENU_CHOICE

  case "$MENU_CHOICE" in
    1|6) install_theme ;;
    2) uninstall_theme ;;
    3) configure_wings ;;
    4) create_node ;;
    x) exit 0 ;;
    *) echo "Pilihan tidak valid!" ; sleep 2 ;;
  esac
done
