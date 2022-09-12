#!/bin/bash
# // Export Color & Information
export RED='\033[0;31m';
export GREEN='\033[0;32m';
export YELLOW='\033[0;33m';
export BLUE='\033[0;34m';
export PURPLE='\033[0;35m';
export CYAN='\033[0;36m';
export LIGHT='\033[0;37m';
export NC='\033[0m';

# // Stopping Service if running
systemctl stop xray-mini@tls > /dev/null 2>&1
systemctl stop xray-mini@nontls > /dev/null 2>&1

# // Make Folder For Service
mkdir -p /usr/local/tridebleng/;

# // Downloading XRay Mini Core
wget -q -O /usr/local/tridebleng/xray-mini "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Core/xray-mini";
chmod +x /usr/local/tridebleng/xray-mini;

# // Downloading XRay Mini Service
wget -q -O /etc/systemd/system/xray-mini@.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/xray-mini_service";
chmod +x /etc/systemd/system/xray-mini@.service;

# // Removing Old Folder
rm -rf /etc/xray-mini/;
rm -rf /etc/tridebleng/xray-mini-tls/;
rm -rf /etc/tridebleng/xray-mini-nontls/;
rm -rf /etc/tridebleng/xray-mini-shadowsocks/;
rm -rf /etc/tridebleng/xray-mini-socks/;

# // Make Xray-Mini Folder
mkdir -p /etc/xray-mini/;
mkdir -p /etc/tridebleng/xray-mini-nontls/;
mkdir -p /etc/tridebleng/xray-mini-tls/;
mkdir -p /etc/tridebleng/vmess/;
mkdir -p /etc/tridebleng/vless/;
mkdir -p /etc/tridebleng/trojan/;
mkdir -p /etc/tridebleng/cache/;
mkdir -p /etc/tridebleng/xray-mini-utils/;
mkdir -p /etc/tridebleng/xray-mini-shadowsocks/;
mkdir -p /etc/tridebleng/xray-mini-socks/;
touch /etc/xray-mini/client.conf;

# // Getting Domain Addres
export domain=$( cat /etc/tridebleng/domain.txt );

# // Downloading XRay TLS Config
wget -qO- "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Xray-Mini/1.0.Stable/tls_json" | jq '.inbounds[0].streamSettings.xtlsSettings.certificates += [{"certificateFile": "'/root/.acme.sh/${domain}_ecc/fullchain.cer'","keyFile": "'/root/.acme.sh/${domain}_ecc/${domain}.key'"}]' > /etc/xray-mini/tls.json;
wget -q -O /etc/xray-mini/nontls.json "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Xray-Mini/1.0.Stable/nontls_json";
wget -q -O /etc/xray-mini/shadowsocks.json "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Xray-Mini/1.0.Stable/shadowsocks_json";
wget -q -O /etc/xray-mini/socks.json "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Xray-Mini/1.0.Stable/socks_json";
wget -q -O /etc/xray-mini/http.json "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Xray-Mini/1.0.Stable/http_json";

# // Removing Apache 2 if existed
systemctl stop apache2 > /dev/null 2>&1;
apt remove --purge apache2 -y;
apt autoremove -y;

# // Enable XRay Service
systemctl enable xray-mini@shadowsocks;
systemctl enable xray-mini@tls;
systemctl enable xray-mini@nontls;
systemctl enable xray-mini@socks;
systemctl enable xray-mini@http;
systemctl start xray-mini@shadowsocks;
systemctl start xray-mini@tls;
systemctl start xray-mini@nontls;
systemctl start xray-mini@socks;
systemctl start xray-mini@http;
systemctl restart xray-mini@shadowsocks;
systemctl restart xray-mini@nontls
systemctl restart xray-mini@tls
systemctl restart xray-mini@socks
systemctl restart xray-mini@http

# // Remove not used file
rm -f /root/xray-mini.sh;

# // Successfull
clear;
echo -e "${OKEY} Successfull Installed XRay-Mini 1.5.5";