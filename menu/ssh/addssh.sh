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

# // Export Banner Status Information
export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";
export RED_BG='\e[41m';

# // Clear Data
clear;

# // Input Data
read -p "Username : " Username;
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )";

# // Validate Input
if [[ $Username == "" ]]; then
    clear;
    echo -e "${ERROR} Please Input an Username !";
    exit 1;
fi

# // Validate User Exists
if [[ $( cat /etc/shadow | cut -d: -f1,8 | sed /:$/d | grep -w $Username ) == "" ]]; then
    Skip="true";
else
    clear;
    echo -e "${ERROR} User ( ${YELLOW}$Username${NC} ) Already Exists !";
    exit 1;
fi

read -p "Password : " Password;
read -p "Expired  : " Jumlah_Hari;

# // String For IP & Port
domain=$( cat /etc/tridebleng/domain.txt );
openssh=$( cat /etc/ssh/sshd_config | grep -E Port | head -n1 | awk '{print $2}' );
dropbear1=$( cat /etc/default/dropbear | grep -E DROPBEAR_PORT | sed 's/DROPBEAR_PORT//g' | sed 's/=//g' | sed 's/"//g' |  tr -d '\r' );
dropbear2=$( cat /etc/default/dropbear | grep -E DROPBEAR_EXTRA_ARGS | sed 's/DROPBEAR_EXTRA_ARGS//g' | sed 's/=//g' | sed 's/"//g' | awk '{print $2}' |  tr -d '\r' );
ovpn_tcp="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)";
ovpn_udp="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)";
if [[ $ovpn_tcp == "" ]]; then
    ovpn_tcp="Eror";
fi
if [[ $ovpn_udp == "" ]]; then
    ovpn_udp="Eror";
fi
stunnel_dropbear=$( cat /etc/stunnel5/stunnel5.conf | grep -i accept | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $2}' | tr -d '\r' );
stunnel_ovpn_tcp=$( cat /etc/stunnel5/stunnel5.conf | grep -i accept | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $3}' | tr -d '\r' );
ssh_ssl2=$( cat /lib/systemd/system/sslh.service | grep -w ExecStart | head -n1 | awk '{print $6}' | sed 's/0.0.0.0//g' | sed 's/://g' | tr '\n' ' ' | tr -d '\r' | sed 's/ //g' );
ssh_nontls=$( cat /etc/tridebleng/ws-epro.conf | grep -i listen_port |  head -n 4 | cut -d= -f2 | sed 's/ //g' | sed 's/listen_port//g' | sed 's/://g' | tr '\n' ' ' | awk '{print $1}' | tr -d '\r' );
ssh_ssl=$( cat /etc/tridebleng/ws-epro.conf | grep -i listen_port |  head -n 4 | cut -d= -f2 | sed 's/ //g' | sed 's/listen_port//g' | sed 's/://g' | tr '\n' ' ' | awk '{print $2}' | tr -d '\r' );
squid1=$( cat /etc/squid/squid.conf | grep http_port | head -n 3 | cut -d= -f2 | awk '{print $2}' | sed 's/ //g' | tr '\n' ' ' | awk '{print $1}' );
squid2=$( cat /etc/squid/squid.conf | grep http_port | head -n 3 | cut -d= -f2 | awk '{print $2}' | sed 's/ //g' | tr '\n' ' ' | awk '{print $2}' );
ohp_1="$( cat /etc/systemd/system/ohp-mini-1.service | grep -i Port | awk '{print $3}' | head -n1)";
ohp_2="$( cat /etc/systemd/system/ohp-mini-2.service | grep -i Port | awk '{print $3}' | head -n1)";
ohp_3="$( cat /etc/systemd/system/ohp-mini-3.service | grep -i Port | awk '{print $3}' | head -n1)";
ohp_4="$( cat /etc/systemd/system/ohp-mini-4.service | grep -i Port | awk '{print $3}' | head -n1)";
udp_1=$( cat /etc/systemd/system/udp-mini-1.service | grep -i listen-addr | awk '{print $3}' | head -n1 | sed 's/127.0.0.1//g' | sed 's/://g' | tr -d '\r' );
udp_2=$( cat /etc/systemd/system/udp-mini-2.service | grep -i listen-addr | awk '{print $3}' | head -n1 | sed 's/127.0.0.1//g' | sed 's/://g' | tr -d '\r' );
udp_3=$( cat /etc/systemd/system/udp-mini-3.service | grep -i listen-addr | awk '{print $3}' | head -n1 | sed 's/127.0.0.1//g' | sed 's/://g' | tr -d '\r' );
today=`date -d "0 days" +"%Y-%m-%d"`;

# // Adding User To Server
useradd -e `date -d "$Jumlah_Hari days" +"%Y-%m-%d"` -s /bin/false -M $Username;
echo -e "$Password\n$Password\n"|passwd $Username &> /dev/null;
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;

# // Make Config Folder
mkdir -p /etc/tridebleng/ssh/;
mkdir -p /etc/tridebleng/ssh/${Username}/;

# // Success
clear;
echo -e "Your Premium VPN Details" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " IP Address       = "'```'"${IP_NYA}"'```'"" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Hostname         = "'```'"${domain}"'```'"" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Username         = "'```'"${Username}"'```'"" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Password         = "'```'"${Password}"'```'"" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " OpenSSH          = ${openssh}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Dropbear         = ${dropbear1},${dropbear2}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Stunnel          = ${ssh_ssl2},${stunnel_dropbear}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " SSH WS CDN       = ${ssh_ssl2}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " SSH WS NTLS      = ${ssh_nontls}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " SSH WS TLS       = ${ssh_ssl}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " OVPN TCP         = ${ovpn_tcp}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " OVPN UDP         = ${ovpn_udp}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " OVPN SSL         = ${stunnel_ovpn_tcp}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Squid Proxy 1    = ${squid1}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Squid Proxy 2    = ${squid2}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " OHP OpenSSH      = ${ohp_1}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " OHP Dropbear     = ${ohp_2}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " OHP OpenVPN      = ${ohp_3}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " OHP Universal    = ${ohp_4}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " BadVPN UDP 1     = ${udp_1}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " BadVPN UDP 2     = ${udp_2}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " BadVPN UDP 3     = ${udp_3}" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Payload WebSocket NonTLS" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " "' ```'"GET / HTTP/1.1[crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]"'```'"" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Payload WebSocket TLS" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " "' ```'"GET wss://example.com [protocol][crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]"'```'"" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Link OVPN TCP    = http://${IP}:85/tcp.ovpn" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Link OVPN UDP    = http://${IP}:85/udp.ovpn" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Link SSL TCP     = http://${IP}:85/ssl-tcp.ovpn" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Link OVPN CONFIG = http://${IP}:85/all.zip" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Created = $today" | tee -a /etc/tridebleng/ssh/${Username}/config.log;
echo -e " Expired = $exp";
echo -e "===============================";
