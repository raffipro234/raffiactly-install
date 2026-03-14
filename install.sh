#!/bin/bash

# --- Variabel Warna (Nebula Space Theme) ---
BLUE='\033[0;34m'       
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# --- 1. Tampilan Welcome (Branding Raffiactly) ---
display_welcome() {
  clear
  echo -e "${PURPLE}[+] =============================================== [+]${NC}"
  echo -e "${PURPLE}[+]                                                 [+]${NC}"
  echo -e "${CYAN}[+]                AUTO INSTALLER THEME             [+]${NC}"
  echo -e "${CYAN}[+]                © RAFFIACTLY PROJECT             [+]${NC}"
  echo -e "${PURPLE}[+]                                                 [+]${NC}"
  echo -e "${PURPLE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "${WHITE}Script ini dibuat untuk mempermudah instalasi tema Pterodactyl.${NC}"
  echo -e "${RED}DILARANG KERAS MEMPERJUALBELIKAN TANPA IZIN OWNER!${NC}"
  echo -e ""
  echo -e "${CYAN}𝗧𝗘𝗟𝗘𝗚𝗥𝗔𝗠 :${NC} @Raffioffci2"
  echo -e "${CYAN}𝗖𝗥𝗘𝗗𝗜𝗧𝗦  :${NC} @Raffioffci2"
  sleep 4
}

# --- 2. Install Dependensi ---
install_jq() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]             UPDATE & INSTALL DEPENDENCY         [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  sudo apt update && sudo apt install -y jq unzip wget curl
  clear
}

# --- 3. Cek Token Akses ---
check_token() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               LICENSE RAFFIACTLY               [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "${YELLOW}MASUKKAN AKSES TOKEN :${NC}"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "raffi" ]; then
    echo -e "${GREEN}[✔] AKSES BERHASIL! Selamat Datang Raffi.${NC}"
    sleep 2
  else
    echo -e "${RED}[✘] TOKEN SALAH! Hubungi @Raffioffci2 untuk membeli akses.${NC}"
    echo -e "${YELLOW}Harga Token : 10K (Free Update)${NC}"
    exit 1
  fi
  clear
}

# --- 4. Fungsi Install Tema ---
install_theme() {
  while true; do
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "${WHITE}[+]               SELECT RAFFIACTLY THEME           [+]${NC}"
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "PILIH TEMA YANG INGIN DI INSTALL:"
    echo "1. Raffiactly Stellar (Stellar Based)"
    echo "2. Raffiactly Enigma (Enigma Based)"
    echo "x. Kembali"
    echo -ne "Masukkan pilihan (1/2/x): "
    read -r SELECT_THEME
    
    case "$SELECT_THEME" in
      1)
        THEME_URL="https://github.com/gitfdil1248/thema/raw/main/C2.zip"
        break
        ;;
      2)
        THEME_URL="https://github.com/gitfdil1248/thema/raw/main/C3.zip"
        break
        ;;
      x) return ;;
      *) echo -e "${RED}Pilihan tidak valid!${NC}" ;;
    esac
  done

  # Proses Inti
  cd /var/www/pterodactyl || { echo -e "${RED}Pterodactyl tidak ditemukan!${NC}"; exit 1; }
  
  # Hapus folder lama jika ada
  sudo rm -rf /root/pterodactyl
  
  echo -e "${CYAN}[+] Mendownload Tema...${NC}"
  wget -q -O /root/theme_raffi.zip "$THEME_URL"
  unzip -o /root/theme_raffi.zip -d /root/
  
  echo -e "${CYAN}[+] Menyalin File Tema...${NC}"
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  
  echo -e "${YELLOW}[+] Memulai Build Panel (Mohon Tunggu)...${NC}"
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm i -g yarn
  
  yarn install
  yarn add react-feather
  php artisan migrate
  yarn build:production
  php artisan view:clear
  
  # Cleanup
  sudo rm /root/theme_raffi.zip
  sudo rm -rf /root/pterodactyl
  
  echo -e "${GREEN}[✔] INSTALL RAFFIACTLY SUCCESS!${NC}"
  sleep 3
}

# --- 5. Fungsi Create Node ---
create_node() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                CREATE NODE & LOC                [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  
  read -p "Masukkan nama lokasi: " loc_name
  read -p "Masukkan deskripsi: " loc_desc
  read -p "Masukkan domain/IP: " domain
  read -p "Masukkan nama node: " node_name
  read -p "Masukkan RAM (MB): " ram
  read -p "Masukkan Disk (MB): " disk

  cd /var/www/pterodactyl || exit
  php artisan p:location:make <<EOF
$loc_name
$loc_desc
EOF

  php artisan p:node:make <<EOF
$node_name
$loc_desc
1
https
$domain
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
  echo -e "${GREEN}[✔] Berhasil membuat Node & Lokasi!${NC}"
  sleep 2
}

# --- 6. Fungsi Hackback ---
hackback_panel() {
  echo -e "${RED}[!] HACK BACK PANEL ADMIN [!]${NC}"
  read -p "Username Baru: " user
  read -p "Email Baru: " mail
  read -p "Password: " pss
  
  cd /var/www/pterodactyl || exit
  php artisan p:user:make <<EOF
yes
$mail
$user
$user
$user
$pss
EOF
  echo -e "${GREEN}[✔] Akun Admin $user Berhasil Ditambahkan!${NC}"
  sleep 2
}

# --- 7. Main Menu Loop ---
display_welcome
install_jq
check_token

while true; do
  clear
  echo -e "                                                                     "
  echo -e "${CYAN}         RAFFIACTLY AUTO INSTALLER PRIVATE      ${NC}"
  echo -e "${PURPLE}    --------------------------------------------  ${NC}"
  echo -e "    1. Install Raffiactly Theme"
  echo -e "    2. Uninstall Theme (Repair)"
  echo -e "    3. Create Node & Location"
  echo -e "    4. Hack Back Admin Panel"
  echo -e "    5. Ubah Password VPS"
  echo -e "    x. Exit"
  echo -e "${PURPLE}    --------------------------------------------  ${NC}"
  echo -e "    WhatsApp : 62858xxxx (Update di script)"
  echo -e "    Telegram : @Raffioffci2"
  echo -ne "    Pilih Menu [1-5/x]: "
  read -r MENU_CHOICE

  case "$MENU_CHOICE" in
    1) install_theme ;;
    2) bash <(curl -s https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/master/repair.sh) ;;
    3) create_node ;;
    4) hackback_panel ;;
    5) 
      read -p "Masukkan PW Baru: " pwvps
      echo "root:$pwvps" | chpasswd
      echo -e "${GREEN}PW VPS Berhasil Diubah!${NC}"
      sleep 2
      ;;
    x) exit 0 ;;
    *) echo -e "${RED}Pilihan tidak valid!${NC}"; sleep 1 ;;
  esac
done
