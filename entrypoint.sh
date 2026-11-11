#!/bin/sh
set -eu
PORT="${PORT:-8080}"
UUID="${UUID:-9d4e7a1c-2f68-4b93-a7e5-3c8d1f6a9b42}"
WS_PATH="${WS_PATH:-/xray-vless}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [{"port": $PORT, "listen": "0.0.0.0", "protocol": "vless", "settings": {"clients": [{"id": "$UUID"}], "decryption": "none"}, "streamSettings": {"network": "ws", "wsSettings": {"path": "$WS_PATH"}}}],
  "outbounds": [{"protocol": "freedom"}, {"protocol": "blackhole", "tag": "blocked"}]
}
EOF
echo "Starting xray on port $PORT path $WS_PATH"
exec xray -config /etc/xray/config.json
