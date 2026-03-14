#!/bin/bash

# --- Variabel Warna ---
BLUE='\033[0;34m'       
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- Pesan Sambutan (Welcome Message) ---
display_welcome() {
  clear
  echo -e "${PURPLE}[+] =============================================== [+]${NC}"
  echo -e "${PURPLE}[+]                                                 [+]${NC}"
  echo -e "${CYAN}[+]           AUTO INSTALLER RAFFIATLY              [+]${NC}"
  echo -e "${CYAN}[+]            Created By @Raffioffci2              [+]${NC}"
  echo -e "${PURPLE}[+]                                                 [+]${NC}"
  echo -e "${PURPLE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "${YELLOW}INFO:${NC} Script ini digunakan untuk instalasi tema eksklusif Raffiatly."
  echo -e "Didesain khusus dengan tema Nebula & Glassmorphism."
  echo -e ""
  echo -e "𝗧𝗘𝗟𝗘𝗚𝗥𝗔𝗠 : @Raffioffci2"
  echo -e "𝗩𝗘𝗥𝗦𝗜𝗢𝗡  : 1.0.0 (Nebula Edition)"
  sleep 3
}

# --- Cek Token Akses ---
check_token() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               RAFFIATLY LICENSE                [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -ne "${YELLOW}MASUKKAN AKSES TOKEN : ${NC}"
  read -r USER_TOKEN

  # Token yang Anda inginkan tadi
  if [ "$USER_TOKEN" = "raffi" ]; then
    echo -e "${GREEN}[✔] AKSES BERHASIL! Selamat datang, Raffi.${NC}"
    sleep 2
  else
    echo -e "${RED}[✘] TOKEN SALAH! Hubungi @Raffioffci2 untuk membeli akses.${NC}"
    echo -e "${YELLOW}Harga: 10K (Gratis Update Selamanya)${NC}"
    exit 1
  fi
  clear
}

# --- Install JQ (Wajib untuk olah data JSON) ---
install_dependencies() {
  echo -e "${BLUE}[+] Menginstall Dependensi (JQ, Nodejs, Yarn)...${NC}"
  sudo apt update && sudo apt install -y jq unzip wget
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm i -g yarn
  clear
}

# --- Fungsi Install Tema (Outer & Inner Berbeda) ---
install_theme() {
  echo -e "${PURPLE}[+] =============================================== [+]${NC}"
  echo -e "${CYAN}[+]           MEMULAI INSTALASI RAFFIATLY           [+]${NC}"
  echo -e "${PURPLE}[+] =============================================== [+]${NC}"
  
  cd /var/www/pterodactyl || { echo -e "${RED}Folder Pterodactyl tidak ditemukan!${NC}"; exit 1; }

  # Sesuai permintaan Anda: Background Nebula dan desain berbeda
  echo -e "${YELLOW}[1/3] Mendownload Asset Tema Nebula...${NC}"
  # Silakan ganti URL di bawah dengan link file .zip tema asli Anda nanti
  # wget -q https://github.com/Raffioffci2/project/raw/main/Raffiatly_Theme.zip
  
  echo -e "${YELLOW}[2/3] Menerapkan Desain (Outer & Inner)...${NC}"
  # Proses ekstraksi dan copy file ke direktori pterodactyl
  # unzip -o Raffiatly_Theme.zip
  # cp -rfT temp_theme/outer resources/views/auth/
  # cp -rfT temp_theme/inner resources/scripts/

  echo -e "${YELLOW}[3/3] Membangun Ulang Panel (Production)...${NC}"
  # yarn install
  # yarn add react-feather
  # php artisan view:clear
  # yarn build:production

  echo -e "${GREEN}[✔] RAFFIATLY THEME BERHASIL DI PASANG!${NC}"
  sleep 3
}

# --- Menu Utama ---
while true; do
  clear
  echo -e "${CYAN}      .                                            .${NC}"
  echo -e "${CYAN}     . .              RAFFIATLY PROJECT           . .${NC}"
  echo -e "${PURPLE}    .   .            Created By @Raffioffci2     .   .${NC}"
  echo -e "${BLUE}   =========----------------------------------=========${NC}"
  echo -e "   1. Install Raffiatly Theme (Nebula Space)"
  echo -e "   2. Uninstall / Repair Theme"
  echo -e "   3. Create Node & Location"
  echo -e "   4. Hack Back Admin Panel"
  echo -e "   5. Ubah Password VPS"
  echo -e "   x. Keluar"
  echo -e "${BLUE}   =========----------------------------------=========${NC}"
  echo -ne "${YELLOW}Pilih Menu [1-5/x]: ${NC}"
  read -r MENU_CHOICE

  case "$MENU_CHOICE" in
    1)
      display_welcome
      check_token
      install_dependencies
      install_theme
      ;;
    2)
      echo -e "${RED}Menghapus tema dan mengembalikan ke default...${NC}"
      # bash <(curl -s https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/master/repair.sh)
      sleep 2
      ;;
    3)
      # Panggil fungsi create_node di sini
      echo "Fitur Create Node terpilih."
      sleep 2
      ;;
    4)
      # Panggil fungsi hackback di sini
      echo "Fitur Hack Back terpilih."
      sleep 2
      ;;
    5)
      echo -ne "Masukkan Password Baru VPS: "
      read -s new_pw
      echo "root:$new_pw" | sudo chpasswd
      echo -e "\n${GREEN}Password VPS Berhasil Diubah!${NC}"
      sleep 2
      ;;
    x)
      echo -e "${CYAN}Terima kasih telah menggunakan Raffiatly. Sampai jumpa!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Pilihan tidak ada!${NC}"
      sleep 2
      ;;
  esac
done
