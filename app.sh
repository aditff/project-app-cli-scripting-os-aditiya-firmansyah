#!/bin/bash

# Warna output
RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' CYAN='\033[0;36m' NC='\033[0m'

history=()  # Array riwayat perhitungan

# Tampilkan menu utama
show_menu() {
  echo -e "${CYAN}===== KALKULATOR SEDERHANA =====${NC}"
  echo "1. Penjumlahan (+)"
  echo "2. Pengurangan (-)"
  echo "3. Perkalian (*)"
  echo "4. Pembagian (/)"
  echo "5. Tampilkan riwayat"
  echo "6. Hapus riwayat per nomor"
  echo "7. Hapus semua riwayat"
  echo "8. Keluar"
  echo -n "Pilih menu (1-8): "
}

# Validasi input angka (integer/desimal)
is_number() { [[ $1 =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; }

# Hitung operasi aritmatika dengan pengecekan pembagian nol
calculate() {
  if [[ $3 == "/" && $(echo "$2 == 0" | bc) -eq 1 ]]; then
    echo -e "${RED}Error: Pembagian dengan nol tidak diperbolehkan!${NC}"
    return 1
  fi
  echo "$(echo "scale=4; $1 $3 $2" | bc)"
}

# Tampilkan riwayat perhitungan
show_history() {
  if [ ${#history[@]} -eq 0 ]; then
    echo -e "${YELLOW}Riwayat kosong.${NC}"
    return 1
  fi
  echo -e "${CYAN}Riwayat Perhitungan:${NC}"
  for i in "${!history[@]}"; do echo "$((i+1)). ${history[i]}"; done
}

# Hapus riwayat per nomor
delete_history_item() {
  show_history || return
  echo -n "Nomor riwayat yang dihapus: "
  read num
  if ! [[ $num =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#history[@]} )); then
    echo -e "${RED}Nomor tidak valid!${NC}"
    return
  fi
  unset 'history[num-1]'
  history=("${history[@]}")  # Reindex array
  echo -e "${GREEN}Riwayat nomor $num dihapus.${NC}"
}

# Hapus semua riwayat
clear_history() {
  history=()
  echo -e "${GREEN}Semua riwayat dihapus.${NC}"
}

# Loop utama program
while true; do
  show_menu
  read choice
  case $choice in
    [1-4])
      echo -n "Masukkan angka pertama: "; read n1
      if ! is_number "$n1"; then echo -e "${RED}Input tidak valid!${NC}"; continue; fi
      echo -n "Masukkan angka kedua: "; read n2
      if ! is_number "$n2"; then echo -e "${RED}Input tidak valid!${NC}"; continue; fi
      case $choice in
        1) op="+" ;;
        2) op="-" ;;
        3) op="*" ;;
        4) op="/" ;;
      esac
      res=$(calculate "$n1" "$n2" "$op") || continue
      echo -e "${GREEN}Hasil: $n1 $op $n2 = $res${NC}"
      history+=("$n1 $op $n2 = $res")
      ;;
    5) show_history ;;
    6) delete_history_item ;;
    7) clear_history ;;
    8) echo -e "${CYAN}Terima kasih!${NC}"; exit 0 ;;
    *) echo -e "${RED}Pilihan tidak valid.${NC}" ;;
  esac
  echo
done
