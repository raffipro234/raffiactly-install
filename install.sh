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
  echo -e "${CYAN}[+]           RAFFIACTLY ULTIMATE PROJECT           [+]${NC}"
  echo -e "${CYAN}[+]         Full Branding & Login Fix 2026          [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "Credits: @Raffioffci2"
  sleep 2
}

check_token() {
  echo -e "${YELLOW}MASUKKAN AKSES TOKEN :${NC}"
  read -r USER_TOKEN
  if [ "$USER_TOKEN" != "raffi" ]; then
    echo -e "${RED}[X] TOKEN SALAH ATAU KOSONG!${NC}"
    exit 1
  fi
  echo -e "${GREEN}[✔] AKSES BERHASIL${NC}"
  sleep 1
}

# --- 1. INSTALL PANEL & FORCE BRANDING ---
install_panel() {
  echo -e "${BLUE}[+] Memulai Instalasi Panel & Branding...${NC}"
  
  # Auto-install Pterodactyl (Base Engine)
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

  # FORCE BRANDING (Ubah Pterodactyl -> Raffiactly sampai ke akar)
  cd /var/www/pterodactyl || exit
  sed -i "s/APP_NAME=.*/APP_NAME=Raffiactly/g" .env
  sed -i "s/'name' => env('APP_NAME', 'Pterodactyl')/'name' => 'Raffiactly'/g" config/app.php
  
  # Ubah tampilan visual (Blade files)
  find resources/views -type f -exec sed -i 's/Pterodactyl/Raffiactly/g' {} +
  
  # Suntik Tema dari GitHub kamu
  wget -q -O theme.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip
  unzip -o theme.zip
  cp -rfT /root/pterodactyl /var/www/pterodactyl

  # Fix Database & Login (Jamu Anti-Refused)
  php artisan config:clear
  php artisan view:clear
  php artisan cache:clear
  php artisan migrate --force
  
  chown -R www-data:www-data /var/www/pterodactyl/*
  systemctl restart nginx
  
  echo -e "${GREEN}[✔] PANEL RAFFIACTLY SIAP DIGUNAKAN!${NC}"
  echo -e "Login: admin@raffi.com | Pass: raffi123"
}

# --- 2. INSTALL WINGS (BYPASS DNS CHECK) ---
install_wings() {
  echo -e "${BLUE}[+] Memulai Instalasi Wings (Bypass DNS)...${NC}"
  
  # Menggunakan IP VPS langsung agar tidak error "DNS record does not match"
  # Seperti yang ada di log kamu tadi
  IP_VPS=$(curl -s ifconfig.me)
  
  bash <(curl -sL https://get.pterodactyl.io) <<EOF
y
y
y
y
$IP_VPS
EOF

  systemctl enable --now wings
  echo -e "${GREEN}[✔] WINGS BERHASIL TERPASANG PADA IP: $IP_VPS${NC}"
}

# --- 3. CREATE NODE & LOCATION ---
create_node() {
  echo -e "${BLUE}[+] Membuat Lokasi (Indonesia) & Node...${NC}"
  cd /var/www/pterodactyl || exit
  
  # Buat Lokasi
  php artisan p:location:make <<EOF
ID
Indonesia
EOF

  # Buat Node Otomatis
  php artisan p:node:make <<EOF
Node-Raffi
Auto-Node
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
  echo -e "${GREEN}[✔] NODE & LOCATION BERHASIL DIBUAT!${NC}"
}

# --- MAIN MENU ---
display_welcome
check_token

while true; do
  echo -e "\n${CYAN}--- RAFFIACTLY PRIVATE MENU ---${NC}"
  echo "1. Install Full Panel & Theme"
  echo "2. Install Wings (Fix DNS Error)"
  echo "3. Create Node & Location"
  echo "4. Uninstall Panel"
  echo "x. Exit"
  read -p "Pilih menu (1/2/3/4/x): " PILIH
  
  case "$PILIH" in
    1) install_panel ;;
    2) install_wings ;;
    3) create_node ;;
    4) bash <(curl -s https://pterodactyl-installer.se) <<EOF
y
y
y
y
EOF
    ;;
    x) exit 0 ;;
    *) echo "Pilihan salah!" ;;
  esac
done
