#!/bin/bash

echo "📦 Mengunduh binary AEGS Miner untuk ARM64..."

mkdir -p ~/termux-miner/aegisum
cd ~/termux-miner/aegisum || exit 1

curl -L -o minerd-aegs-arm64.tar.gz https://github.com/nheoshikuyanhemo/Aegisum/releases/download/aegs-miner-arm64/minerd-aegs-arm64.tar.gz

echo "📦 Mengekstrak binary..."
tar -xzf minerd-aegs-arm64.tar.gz
chmod +x minerd

echo "✅ Selesai. Untuk mulai menambang jalankan:"
echo "./minerd --help"
