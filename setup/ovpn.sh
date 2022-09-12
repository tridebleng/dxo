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

# // Installing Update
apt update -y;
apt upgrade -y;
apt dist-upgrade -y;
apt autoremove -y;
apt clean -y;

# // Installing Requirement Tools
apt install openvpn unzip -y;
apt install openssl iptables iptables-persistent -y;

# // Remove OpenVPN Directory & Recreate
rm -r -f /etc/openvpn;
mkdir -p /etc/openvpn;

# // Enter To OpenVPN Main Folder
cd /etc/openvpn/;
wget -q -O cert.zip "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Data/ovpn_cert.zip";
unzip -o cert.zip;
rm -f cert.zip;
mkdir -p config;
rm -r -f server;
rm -r -f client;

# // Chwon Root Directory Data
chown -R root:root /etc/openvpn/;

# // Copying OpenVPN Plugin Auth To /usr/lib/openvpn
mkdir -p /usr/lib/openvpn/;
cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so /usr/lib/openvpn/openvpn-plugin-auth-pam.so;

# // Enable AUTOSTART For OpenVPN
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn;

# // Downloading OpenVPN Server Config
wget -q -O /etc/openvpn/tcp.conf "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/OpenVPN/tcp_conf";
wget -q -O /etc/openvpn/udp.conf "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/OpenVPN/udp_conf";

# // Remove The OpenVPN Service & Replace New OpenVPN Service
rm -f /lib/systemd/system/openvpn-server@.service;
wget -q -O /etc/systemd/system/openvpn@.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/openvpn_service";

# Enable OpenVPN & Start OpenVPN
systemctl daemon-reload;
systemctl stop openvpn@tcp;
systemctl stop openvpn@udp;
systemctl disable openvpn@tcp;
systemctl disable openvpn@udp;
systemctl enable openvpn@tcp;
systemctl enable openvpn@udp;
systemctl start openvpn@tcp;
systemctl start openvpn@udp;

# // Checking OpenVPN TCP Statuss
echo -e "${YELLOW}==============================${NC}";
if [[ $( systemctl status openvpn@tcp | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' ) == "running" ]]; then
echo -e "${OKEY} OpenVPN TCP Running !";
else
echo -e "${EROR} OpenVPN TCP Has Been Stopped !";
fi

# // Checking OpenVPN UDP Statuss
if [[ $( systemctl status openvpn@udp | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' ) == "running" ]]; then
echo -e "${OKEY} OpenVPN UDP Running !";
else
echo -e "${EROR} OpenVPN UDP Has Been Stopped !";
fi
echo -e "${YELLOW}==============================${NC}"
echo -e "${INFO} Enabling OpenVPN Daemon Service.";
echo "Starting Daemon Service For OpenVPN.";
echo "Successfull Started Daemon Service For OpenVPN.";

# // Generating TCP To Cache Directory
wget -q -O /etc/openvpn/config/tcp.ovpn "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/OpenVPN/tcp_client";
wget -q -O /etc/openvpn/config/udp.ovpn "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/OpenVPN/udp_client";
wget -q -O /etc/openvpn/config/ssl.ovpn "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/OpenVPN/ssl_client";

# // Adding IP Address To OpenVPN Client Configuration
sed -i $MYIP2 /etc/openvpn/config/tcp.ovpn;
sed -i $MYIP2 /etc/openvpn/config/udp.ovpn;
sed -i $MYIP2 /etc/openvpn/config/ssl.ovpn;

# // Input Certificate to TCP Client Config
echo '<ca>' >> /etc/openvpn/config/tcp.ovpn;
cat /etc/openvpn/ca.crt >> /etc/openvpn/config/tcp.ovpn;
echo '</ca>' >> /etc/openvpn/config/tcp.ovpn;

# // Input Certificate to UDP Client Config
echo '<ca>' >> /etc/openvpn/config/udp.ovpn;
cat /etc/openvpn/ca.crt >> /etc/openvpn/config/udp.ovpn;
echo '</ca>' >> /etc/openvpn/config/udp.ovpn;

# // Input Certificate to SSL-TCP Client Config
echo '<ca>' >> /etc/openvpn/config/ssl.ovpn;
cat /etc/openvpn/ca.crt >> /etc/openvpn/config/ssl.ovpn;
echo '</ca>' >> /etc/openvpn/config/ssl.ovpn;

# // Make ZIP For OpenVPN
cd /etc/openvpn/config;
zip all.zip tcp.ovpn udp.ovpn ssl.ovpn;
cp all.zip /etc/tridebleng/webserver/;
cp tcp.ovpn /etc/tridebleng/webserver/;
cp udp.ovpn /etc/tridebleng/webserver/;
cp ssl.ovpn /etc/tridebleng/webserver/;
cd /root/;

# // Setting IP Tables to MASQUERADE
iptables -t nat -I POSTROUTING -s 10.10.11.0/24 -o $NET -j MASQUERADE;
iptables -t nat -I POSTROUTING -s 10.10.12.0/24 -o $NET -j MASQUERADE;
iptables-save > /etc/iptables.up.rules;
chmod +x /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save > /dev/null 2>&1;
netfilter-persistent reload > /dev/null 2>&1;

# // Adding Port To IPTables ( OpenVPN 1194 / TCP )
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1194 -j ACCEPT;
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1194 -j ACCEPT;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save > /dev/null 2>&1;
netfilter-persistent reload > /dev/null 2>&1;

# // Adding Port To IPTables ( OpenVPN 1195 / UDP )
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1195 -j ACCEPT;
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1195 -j ACCEPT;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save > /dev/null 2>&1;
netfilter-persistent reload > /dev/null 2>&1;

# // Adding Port To IPTables ( OpenVPN 1196 / TCP SSL )
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1196 -j ACCEPT;
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1196 -j ACCEPT;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save > /dev/null 2>&1;
netfilter-persistent reload > /dev/null 2>&1;

# // Remove Not Used Files
rm -f /root/ovpn.sh;

# // Successfull
clear;
echo -e "${OKEY} Successfull Installed OpenVPN";