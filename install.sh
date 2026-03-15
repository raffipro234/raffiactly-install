#!/bin/bash

# Color
BLUE='\033[0;34m'        
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Display welcome message
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${WHITE}[+]             RAFFIACTLY AUTO INSTALLER           [+]${NC}"
  echo -e "${WHITE}[+]                © @Raffioffci2                   [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "Script ini dibuat khusus untuk mempermudah instalasi Panel Raffiactly."
  echo -e "Dilarang keras untuk diperjualbelikan tanpa izin."
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
  
  # Bypass agar bot bisa langsung jalan
  read -t 5 -r USER_TOKEN
  USER_TOKEN=${USER_TOKEN:-"raffi"}

  if [ "$USER_TOKEN" = "raffi" ]; then
    echo -e "${GREEN}AKSES BERHASIL${NC}"
  else
    echo -e "${RED}TOKEN SALAH! Hubungi @Raffioffci2${NC}"
    exit 1
  fi
  sleep 1
  clear
}

# 1. Install Theme & Panel
install_theme() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]           INSTALL PANEL & BRANDING              [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  
  # Install Pterodactyl Auto
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

  # Branding Raffiactly
  cd /var/www/pterodactyl || exit
  wget -q -O theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
  unzip -o theme.zip
  cp -rfT /root/pterodactyl /var/www/pterodactyl
  
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +

  # Fix Login & Permissions
  php artisan config:clear
  php artisan view:clear
  php artisan session:table
  php artisan key:generate --force
  php artisan migrate --force
  
  chown -R www-data:www-data /var/www/pterodactyl/*
  chmod -R 775 storage bootstrap/cache
  systemctl restart nginx
  
  echo -e "${GREEN}[✔] INSTALL SUCCESS! Login: admin@raffi.com | Pass: raffi123${NC}"
  sleep 3
}

# 2. Uninstall Theme (Repair)
uninstall_theme() {
  bash <(curl https://raw.githubusercontent.com/gitfdil1248/thema/main/repair.sh)
  echo -e "${GREEN}[✔] THEME DELETED / REPAIRED${NC}"
  sleep 2
}

# 3. Configure Wings
configure_wings() {
  echo -e "${YELLOW}Masukkan token Configure dari Panel: ${NC}"
  read -r wings_command
  eval "$wings_command"
  systemctl enable --now wings
  systemctl start wings
  echo -e "${GREEN}[✔] WINGS STARTED${NC}"
  sleep 2
}

# 4. Create Node
create_node() {
  read -p "Masukkan nama node: " node_name
  read -p "Masukkan RAM (MB): " ram
  read -p "Masukkan Disk (MB): " disk
  
  cd /var/www/pterodactyl || exit
  php artisan p:location:make <<EOF
Indonesia
Raffi-Location
EOF

  php artisan p:node:make <<EOF
$node_name
Auto-Node
1
https
$(curl -s ifconfig.me)
yes
no
no
$ram
$ram
$disk
$disk
100
8080
2022
/var/lib/pterodactyl/volumes
EOF
  echo -e "${GREEN}[✔] NODE CREATED${NC}"
  sleep 2
}

# 5. Uninstall Panel
uninstall_panel() {
  bash <(curl -s https://pterodactyl-installer.se) <<EOF
y
y
y
y
EOF
  echo -e "${GREEN}[✔] PANEL UNINSTALLED${NC}"
  sleep 2
}

# 7. Hack Back Panel (Add Admin)
hackback_panel() {
  read -p "Username Baru: " hb_user
  read -p "Password Baru: " hb_pass
  cd /var/www/pterodactyl || exit
  php artisan p:user:make <<EOF
yes
hb@raffi.com
$hb_user
Raffi
Admin
$hb_pass
EOF
  echo -e "${GREEN}[✔] AKUN ADMIN BERHASIL DITAMBAHKAN${NC}"
  sleep 2
}

# 8. Ubah Pw VPS
ubahpw_vps() {
  read -p "Masukkan Password VPS Baru: " new_pw
  echo -e "$new_pw\n$new_pw" | passwd root
  echo -e "${GREEN}[✔] PASSWORD VPS BERHASIL DIUBAH${NC}"
  sleep 2
}

# --- Main Logic ---
display_welcome
install_jq
check_token

while true; do
  clear
  echo -e "${PURPLE}      RAFFIACTLY PRIVATE AUTO INSTALLER${NC}"
  echo -e "${BLUE}-----------------------------------------------${NC}"
  echo -e "1. Install Theme & Panel"
  echo -e "2. Uninstall Theme"
  echo -e "3. Configure Wings"
  echo -e "4. Create Node"
  echo -e "5. Uninstall Panel"
  echo -e "6. Install Stellar Theme"
  echo -e "7. Hack Back Panel"
  echo -e "8. Ubah Pw Vps"
  echo -e "x. Exit"
  echo -e "${BLUE}-----------------------------------------------${NC}"
  read -p "Pilih menu: " MENU_CHOICE

  case "$MENU_CHOICE" in
    1|6) install_theme ;;
    2) uninstall_theme ;;
    3) configure_wings ;;
    4) create_node ;;
    5) uninstall_panel ;;
    7) hackback_panel ;;
    8) ubahpw_vps ;;
    x) exit 0 ;;
    *) echo "Pilihan tidak valid!" ; sleep 1 ;;
  esac
done
