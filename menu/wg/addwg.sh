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
if [[ $Username == "" ]]; then
    clear;
    echo -e "${ERROR} Please Input Username";
    exit 1;
fi

if [[ $( cat /etc/wireguard/wg0.conf | grep -w $Username ) == "" ]]; then
    Skip=true;
else
    clear;
    echo -e "${ERROR} User ( ${YELLOW}$Username${NC} ) Already Exists !";
    exit 1;
fi

# // Read Expired Date
read -p "Expired  : " Jumlah_Hari;

# // Count Expired Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Load Wiregaurd String
source /etc/wireguard/string-data;

# // Checknig IP Address
LASTIP=$( cat /etc/wireguard/wg0.conf | grep /32 | tail -n1 | awk '{print $3}' | cut -d "/" -f 1 | cut -d "." -f 4 );
if [[ "$LASTIP" = "" ]]; then
	User_IP="10.10.17.2";
else
	User_IP="10.10.17.$((LASTIP+1))";
fi

# // Client DNS
DNS1=8.8.8.8;
DNS2=8.8.4.4;

# // Domain Export
Domain=$( cat /etc/tridebleng/domain.txt );

# // Generate Client Key
User_Priv_Key=$(wg genkey);
User_PUB_Key=$(echo "$User_Priv_Key" | wg pubkey);
User_Preshared_Key=$(wg genpsk);

# // Make Client Config
cat > /etc/tridebleng/wireguard-cache.tmp << END
[Interface]
PrivateKey = ${User_Priv_Key}
Address = ${User_IP}/24
DNS = ${DNS1},${DNS2}

[Peer]
PublicKey = ${PUB}
PresharedKey = ${User_Preshared_Key}
Endpoint = ${Domain}:${PORT}
AllowedIPs = 0.0.0.0/0,::/0
END

# // Input Data User Ke Wireguard Server
cat >> /etc/wireguard/wg0.conf << END
#DEPAN Username : $Username | Expired : $exp
[Peer]
Publickey = ${User_PUB_Key}
PresharedKey = ${User_Preshared_Key}
AllowedIPs = ${User_IP}/32
#BELAKANG Username : $Username | Expired : $exp

END

# // Make Wireguard cache folder
mkdir -p /etc/tridebleng/wireguard/;
rm -rf /etc/tridebleng/wireguard/$Username;
mkdir -p /etc/tridebleng/wireguard/$Username;

# // Restarting Service & Copy Client data to webserver
systemctl restart "wg-quick@wg0";
sysctl -p
cp /etc/tridebleng/wireguard-cache.tmp /etc/tridebleng/webserver/wg-client/${Username}.conf;

# // Clear
clear;

# // Detail
echo -e "Your Premium Wireguard Details" | tee -a /etc/tridebleng/wireguard/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/wireguard/${Username}/config.log;
echo -e " Username    = ${Username}" | tee -a /etc/tridebleng/wireguard/${Username}/config.log;
echo -e " IP          = ${IP}" | tee -a /etc/tridebleng/wireguard/${Username}/config.log;
echo -e " Address     = ${Domain}" | tee -a /etc/tridebleng/wireguard/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/wireguard/${Username}/config.log;
echo -e " Config File = http://${IP}:85/wg-client/${Username}.conf" | tee -a /etc/tridebleng/wireguard/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/wireguard/${Username}/config.log;
echo -e " Created     = ${hariini}" | tee -a /etc/tridebleng/wireguard/${Username}/config.log;
echo -e " Expired     = ${exp}";
echo -e "===============================";
