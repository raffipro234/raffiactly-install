#!/bin/bash

# Color
BLUE='\033[0;34m'       
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Display welcome message
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${WHITE}[+]                AUTO INSTALLER THEMA             [+]${NC}"
  echo -e "${WHITE}[+]                  © RAFFIACTLY                   [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "script ini di buat untuk mempermudah penginstalasian thema pterodactyle,"
  echo -e "dilarang keras untuk dikasih gratis."
  echo -e ""
  echo -e "𝗧𝗘𝗟𝗘𝗚𝗥𝗔𝗠 :"
  echo -e "@Raffioffci2"
  echo -e "𝗖𝗥𝗘𝗗𝗜𝗧𝗦 :"
  echo -e "@Raffioffci2"
  sleep 4
  clear
}

#Update and install jq
install_jq() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]             UPDATE & INSTALL JQ                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sudo apt update && sudo apt install -y jq
  if [ $? -eq 0 ]; then
    echo -e "                                                       "
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+]              INSTALL JQ BERHASIL                [+]${NC}"
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
  else
    echo -e "                                                       "
    echo -e "${RED}[+] =============================================== [+]${NC}"
    echo -e "${RED}[+]              INSTALL JQ GAGAL                   [+]${NC}"
    echo -e "${RED}[+] =============================================== [+]${NC}"
    exit 1
  fi
  echo -e "                                                       "
  sleep 1
  clear
}

#Check user token
check_token() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               LICENSY RAFFIACTLY               [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  echo -e "${YELLOW}MASUKAN AKSES TOKEN :${NC}"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "raffi" ]; then
    echo -e "${GREEN}AKSES BERHASIL${NC}}"
  else
    echo -e "${RED}Token Salah! Hubungi @Raffioffci2${NC}"
    exit 1
  fi
  clear
}

# Install theme
install_theme() {
  while true; do
    echo -e "                                                       "
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "${WHITE}[+]                   SELECT THEME                  [+]${NC}"
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "                                                       "
    echo -e "PILIH THEME YANG INGIN DI INSTALL"
    echo "1. Raffiactly Stellar"
    echo "2. Raffiactly Billing"
    echo "3. Raffiactly Enigma"
    echo "x. kembali"
    echo -e "masukan pilihan (1/2/3/x) :"
    read -r SELECT_THEME
    case "$SELECT_THEME" in
      1)
        THEME_URL="https://github.com/gitfdil1248/thema/raw/main/C2.zip"
        break
        ;;
      2)
        THEME_URL="https://github.com/gitfdil1248/thema/raw/main/C1.zip"
        break
        ;;
      3)
        THEME_URL="https://github.com/gitfdil1248/thema/raw/main/C3.zip"
        break
        ;; 
      x)
        return
        ;;
      *)
        echo -e "${RED}Pilihan tidak valid, silahkan coba lagi.${NC}"
        ;;
    esac
  done
  
  if [ -e /root/pterodactyl ]; then
    sudo rm -rf /root/pterodactyl
  fi
  wget -q "$THEME_URL"
  sudo unzip -o "$(basename "$THEME_URL")"
  
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                  INSTALLASI THEMA               [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                                   "
  
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm i -g yarn
  cd /var/www/pterodactyl
  yarn add react-feather
  php artisan migrate --force
  yarn build:production
  php artisan view:clear
  sudo chown -R www-data:www-data /var/www/pterodactyl/*
  
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                   INSTALL SUCCESS               [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 2
  clear
}

# Install Wings
install_wings() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    INSTALL WINGS                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
  echo -e "${GREEN}WINGS BERHASIL DI INSTALL${NC}"
  sleep 2
  clear
}

# Create Node
create_node() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    CREATE NODE                     [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  
  read -p "Masukkan nama lokasi: " location_name
  read -p "Masukkan deskripsi lokasi: " location_description
  read -p "Masukkan domain/IP: " domain
  read -p "Masukkan nama node: " node_name
  read -p "Masukkan RAM (MB): " ram
  read -p "Masukkan Disk (MB): " disk_space

  cd /var/www/pterodactyl || exit

  php artisan p:location:make <<EOF
$location_name
$location_description
EOF

  php artisan p:node:make <<EOF
$node_name
$location_description
1
https
$domain
yes
no
no
$ram
$ram
$disk_space
$disk_space
100
8080
2022
/var/lib/pterodactyl/volumes
EOF

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]        CREATE NODE & LOCATION SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  sleep 2
  clear
}

# Main script loop
display_welcome
install_jq
check_token

while true; do
  clear
  echo -e "                                                                     "
  echo -e "${CYAN}                RAFFIACTLY AUTO INSTALLER             ${NC}"
  echo -e "${BLUE}          ----------------------------------------    ${NC}"
  echo -e "          • Telegram : @Raffioffci2                   "
  echo -e "          • Credits  : Raffi                          "
  echo -e "                                                                     "
  echo -e "BERIKUT LIST INSTALL :"
  echo "1. Install theme"
  echo "2. Install Wings"
  echo "3. Create Node"
  echo "4. Uninstall theme"
  echo "x. Exit"
  echo -e "Masukkan pilihan 1/2/3/4/x:"
  read -r MENU_CHOICE
  clear

  case "$MENU_CHOICE" in
    1) install_theme ;;
    2) install_wings ;;
    3) create_node ;;
    4) bash <(curl -s https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/master/repair.sh) ;;
    x) exit 0 ;;
    *) echo "Pilihan tidak valid."; sleep 1 ;;
  esac
done
