#!/data/data/com.termux/files/usr/bin/bash
cd "$(dirname "$0")"

# ✅ Load ENV variabel
source .env

# ✅ Install dependencies jika belum ada
command -v curl >/dev/null 2>&1 || pkg install curl -y
command -v jq >/dev/null 2>&1 || pkg install jq -y

# ✅ Unduh binary minerd jika belum tersedia
if [ ! -f "./minerd" ]; then
  echo "📦 Mengunduh binary minerd (scrypt)..."
  curl -LO https://github.com/eixaid/zorg-tools/raw/main/minerd-aegs-arm64
  mv minerd-aegs-arm64 minerd
  chmod +x minerd
fi

# ✅ Gaya warna
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)
BOLD=$(tput bold)

# ✅ Header
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║         🚀  AEGISUM MINER ENGINE BY 0xEIXA  🚀         ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${RESET}"

# ✅ Tampilkan info sistem
echo -e "${YELLOW}🧠 Info Sistem:${RESET}"
echo "• CPU Cores : $(nproc)"
echo "• Worker    : ${WORKER_NAME}"
echo "• Wallet    : ${WALLET_ADDRESS}"
echo "• Pool URL  : ${POOL_URL}"
echo "• Threads   : ${CPU_THREADS}"
echo "• Algo      : scrypt"
echo "• Timestamp : $(date)"
echo -e "${CYAN}─────────────────────────────────────────────${RESET}"

# ✅ Jalankan miner
echo -e "⛏️  Menambang AEGS... (Ctrl+C untuk keluar)"
./minerd -a scrypt \
  -o "${POOL_URL}" \
  -u "${WALLET_ADDRESS}.${WORKER_NAME}" \
  -p "c=${COIN},mc=${COIN}" \
  -t "${CPU_THREADS}" 2>&1 | tee miner.log &

MINER_PID=$!

# ✅ Loop monitoring balance tiap 10 detik
while true; do
  echo -e "\n📡 [$(date)] Memantau balance..."
  RESPONSE=$(curl -s "https://pool.aegisum.com/api/wallet?address=${WALLET_ADDRESS}")

  if echo "$RESPONSE" | grep -q '"currency"'; then
    CLEANED_JSON=$(echo "$RESPONSE" | sed 's/"unsold": *,/"unsold": 0.0,/')
    
    # Ambil angka
    UNSOLD=$(echo "$CLEANED_JSON" | jq -r '.unsold // 0')
    UNPAID=$(echo "$CLEANED_JSON" | jq -r '.unpaid // 0')
    PAID24H=$(echo "$CLEANED_JSON" | jq -r '.paid24h // 0')
    TOTAL=$(echo "$CLEANED_JSON" | jq -r '.total // 0')

    # Tampilkan dalam box
    echo -e "${CYAN}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════╗"
    printf "║ %-51s ║\n" "💰 WALLET BALANCE"
    echo "╠═══════════════════════════════════════════════════════╣"
    printf "║ • Unsold  : %-39s ║\n" "$UNSOLD"
    printf "║ • Unpaid  : %-39s ║\n" "$UNPAID"
    printf "║ • Paid24h : %-39s ║\n" "$PAID24H"
    printf "║ • Total   : %-39s ║\n" "$TOTAL"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
  else
    echo "⚠️  Gagal parse JSON. Pool mungkin down atau wallet salah."
    echo "🔍 Respons mentah:"
    echo "$RESPONSE"
  fi

  echo "🧠 Miner PID: $MINER_PID"
  echo "🔄 Update dalam 10 detik..."
  sleep 10
done
