# setup_aegs.sh (versi baru)
echo "📦 Mengunduh binary AEGS Miner untuk ARM64..."
curl -L -o cpuminer-aegs-arm64.tar.gz https://github.com/nheoshikuyanhemo/Aegisum/releases/download/aegs-miner-arm64/cpuminer-aegs-arm64.tar.gz

echo "📦 Mengekstrak binary..."
tar -xzf cpuminer-aegs-arm64.tar.gz
chmod +x minerd

echo "✅ Selesai. Untuk mulai menambang jalankan:"
echo "./minerd --help"
