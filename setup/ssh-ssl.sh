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

# // Replace Pam.d password common
wget -q -O /etc/pam.d/common-password "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/password";
chmod +x /etc/pam.d/common-password;

# // Installing Dropbear
wget -q -O /etc/ssh/sshd_config "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/sshd_config";
/etc/init.d/ssh restart;
apt install dropbear -y;
wget -q -O /etc/default/dropbear "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/dropbear_conf";
chmod +x /etc/default/dropbear;
echo "/bin/false" >> /etc/shells;
echo "/usr/sbin/nologin" >> /etc/shells;
wget -q -O /etc/tridebleng/banner.txt "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/banner.txt";
/etc/init.d/dropbear restart;

# // Installing Stunnel4
apt install stunnel4 -y
wget -q -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/stunnel_conf";
wget -q -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Data/stunnel_cert";
systemctl enable stunnel4;
systemctl start stunnel4;
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart;

# // Installing Ws-ePro
wget -q -O /usr/local/tridebleng/ws-epro "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Core/ws-epro";
chmod +x /usr/local/tridebleng/ws-epro;
wget -q -O /etc/systemd/system/ws-epro.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/ws-epro_service";
chmod +x /etc/systemd/system/ws-epro.service;
wget -q -O /etc/tridebleng/ws-epro.conf "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/ws-epro_conf";
chmod 644 /etc/tridebleng/ws-epro.conf;
systemctl enable ws-epro;
systemctl start ws-epro;
systemctl restart ws-epro;

# // Instaling SSLH
apt install sslh -y;
wget -q -O /lib/systemd/system/sslh.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/sslh_service"
systemctl daemon-reload
systemctl disable sslh > /dev/null 2>&1;
systemctl stop sslh > /dev/null 2>&1;
systemctl enable sslh;
systemctl start sslh;
systemctl restart sslh;

# // Remove not used file
rm -f /root/ssh-ssl.sh;

# // Successfull
clear;
echo -e "${OKEY} Successfull Installed Stunnel & Dropbear";