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
# // Export OS Information
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );


# // Take VPS IP & Network Interface
MYIP2="s/xxxxxxxxx/$IP_NYA/g";
NET=$(ip route show default | awk '{print $5}');

# // Make SSR Server Main Directory
rm -r -f /etc/tridebleng/ssr-server;
mkdir -p /etc/tridebleng/ssr-server;

# // Installing Requirement Package
apt update -y;
apt install unzip -y;
apt install cron -y;
apt install git -y;
apt install net-tools -y;

# // Install Python2
apt install python -y;

# // ShadowsocksR Setup
cd /etc/tridebleng/ssr-server/;
wget -q -O /etc/tridebleng/ssr-server/SSR-Server.zip "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Core/SSR-Server.zip";
unzip -o SSR-Server.zip > /dev/null 2>&1;
chmod +x jq;
rm -f SSR-Server.zip;
cp config.json /etc/tridebleng/ssr-server/user-config.json;
cp mysql.json /etc/tridebleng/ssr-server/usermysql.json;
cp apiconfig.py /etc/tridebleng/ssr-server/userapiconfig.py;
sed -i "s/API_INTERFACE = 'sspanelv2'/API_INTERFACE = 'mudbjson'/" /etc/tridebleng/ssr-server/userapiconfig.py;
sed -i "s/SERVER_PUB_ADDR = '127.0.0.1'/SERVER_PUB_ADDR = '${IP_NYA}'/" /etc/tridebleng/ssr-server/userapiconfig.py;
sed -i 's/ \/\/ only works under multi-user mode//g' /etc/tridebleng/ssr-server/user-config.json;
cd;

# // Enable IPTables
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1200:1300 -j ACCEPT;
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1200:1300 -j ACCEPT;

# // Saving IPTables Configuration
iptables-save > /etc/iptables.up.rules;

# // Downloading SSR Server Init.d
wget -q -O /etc/init.d/ssr-server "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/ssr-server_init";
chmod +x /etc/init.d/ssr-server;
/etc/init.d/ssr-server start;

# // Starting Service
systemctl daemon-reload;
systemctl start ssr-server;

# // Remove Not Used Files
rm -rf /root/ssr.sh;

# // Successfull
clear;
echo -e "${OKEY} Successfull Installed SSR";