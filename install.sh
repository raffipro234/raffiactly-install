#!/bin/bash

# --- Variabel Warna ---
BLUE='\033[0;34m'       
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# --- 1. Tampilan Welcome ---
display_welcome() {
  clear
  echo -e "${PURPLE}[+] =============================================== [+]${NC}"
  echo -e "${PURPLE}[+]                                                 [+]${NC}"
  echo -e "${CYAN}[+]                AUTO INSTALLER THEMA             [+]${NC}"
  echo -e "${CYAN}[+]                © RAFFIACTLY PROJECT             [+]${NC}"
  echo -e "${PURPLE}[+]                                                 [+]${NC}"
  echo -e "${PURPLE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "${WHITE}Script Khusus Private Bot - Created By Raffi${NC}"
  echo -e "𝗧𝗘𝗟𝗘𝗚𝗥𝗔𝗠 : @Raffioffci2"
  echo -e "𝗖𝗥𝗘𝗗𝗜𝗧𝗦  : @Raffioffci2"
  sleep 3
}

# --- 2. Install JQ & Dependency ---
install_jq() {
  echo -e "${BLUE}[+] Menyiapkan System Dependency...${NC}"
  sudo apt update && sudo apt install -y jq unzip wget curl
  clear
}

# --- 3. Cek Akses Token ---
check_token() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               LICENSE RAFFIACTLY               [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -ne "${YELLOW}MASUKKAN AKSES TOKEN : ${NC}"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "raffi" ]; then
    echo -e "${GREEN}AKSES BERHASIL!${NC}"
    sleep 1
  else
    echo -e "${RED}TOKEN SALAH! Hubungi @Raffioffci2${NC}"
    exit 1
  fi
  clear
}

# --- 4. Fungsi Install Theme & Auto Branding (Biar Beda!) ---
install_theme() {
  echo -e "${BLUE}[+] Mendownload Assets Raffiactly Nebula...${NC}"
  cd /var/www/pterodactyl || { echo -e "${RED}Panel belum terinstall!${NC}"; return; }

  # Menggunakan Base Theme Stellar (Terbaik untuk dimodifikasi)
  THEME_URL="https://github.com/gitfdil1248/thema/raw/main/C2.zip"
  wget -q -O raffiactly.zip "$THEME_URL"
  unzip -o raffiactly.zip
  cp -rfT /root/pterodactyl /var/www/pterodactyl

  # --- PROSES BRANDING (MENGUBAH IDENTITAS) ---
  echo -e "${CYAN}[+] Mengubah Identitas Menjadi RAFFIACTLY...${NC}"
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +
  
  # Build Production
  npm i -g yarn
  yarn install
  yarn build:production
  
  # Fix Permission & Clear Cache (Mencegah Error 500)
  php artisan view:clear
  php artisan config:clear
  sudo chown -R www-data:www-data /var/www/pterodactyl/*
  
  rm raffiactly.zip
  echo -e "${GREEN}[✔] TEMA RAFFIACTLY BERHASIL TERPASANG!${NC}"
  sleep 2
}

# --- 5. Fungsi Auto Create Admin (Biar Bisa Langsung Login) ---
create_admin() {
  echo -e "${BLUE}[+] Membuat Akun Admin Otomatis...${NC}"
  cd /var/www/pterodactyl || exit
  php artisan p:user:make <<EOF
yes
admin@raffi.com
raffiadmin
Raffi
Admin
raffi123
EOF
  echo -e "${GREEN}[✔] Akun Admin Dibuat: admin@raffi.com | Pass: raffi123${NC}"
  sleep 2
}

# --- 6. Fungsi Auto Create Node & Location (Kirim Data VPS) ---
create_node() {
  echo -e "${BLUE}[+] Menghubungkan VPS ke Panel...${NC}"
  IP_VPS=$(curl -s ifconfig.me)
  
  cd /var/www/pterodactyl || exit
  
  # Buat Lokasi
  php artisan p:location:make <<EOF
Indonesia
Raffiactly Private Node
EOF

  # Buat Node
  php artisan p:node:make <<EOF
Node-Raffiactly
Node Created By Bot
1
https
$IP_VPS
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
  echo -e "${GREEN}[✔] Node & Lokasi Berhasil Dibuat!${NC}"
  sleep 2
}

# --- 7. Fungsi Install Wings ---
install_wings() {
  echo -e "${BLUE}[+] Menginstall Wings (Daemon)...${NC}"
  curl -sSL https://get.pterodactyl.io | bash -s -- --install-wings
  systemctl enable --now wings
  echo -e "${GREEN}[✔] Wings Berhasil Terpasang!${NC}"
  sleep 2
}

# --- ALUR EKSEKUSI OTOMATIS (Sangat Cocok Untuk Bot) ---
display_welcome
install_jq
check_token

while true; do
  clear
  echo -e "${CYAN}          RAFFIACTLY ULTIMATE INSTALLER          ${NC}"
  echo -e "${PURPLE}    --------------------------------------------  ${NC}"
  echo -e "    1. Install Raffiactly Theme (Full Branding)"
  echo -e "    2. Create Akun Admin (Auto Login)"
  echo -e "    3. Create Node & Location (Kirim Data VPS)"
  echo -e "    4. Install Wings"
  echo -e "    5. Repair Panel (Fix Error 500)"
  echo -e "    x. Exit"
  echo -e "${PURPLE}    --------------------------------------------  ${NC}"
  echo -ne "    Pilih Menu: "
  read -r MENU_CHOICE

  case "$MENU_CHOICE" in
    1) install_theme ;;
    2) create_admin ;;
    3) create_node ;;
    4) install_wings ;;
    5) 
       cd /var/www/pterodactyl && php artisan view:clear && sudo chown -R www-data:www-data *
       echo -e "${GREEN}Repair Selesai!${NC}"
       sleep 2
       ;;
    x) exit 0 ;;
    *) echo -e "${RED}Pilihan tidak ada!${NC}"; sleep 1 ;;
  esac
done
