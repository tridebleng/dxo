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

# // String
user_tag="$1";
exp_tag="$3";
username="$2";
expired="$4";

if [[ $user_tag == "--user" ]]; then
    SKIP=TRUE;
else
    clear;
    echo -e "${ERROR} Your Command is wrong";
    exit 1;
fi
if [[ $exp_tag == "--exp" ]];  then
    SKIP=TRUE;
else
    clear;
    echo -e "${ERROR} Your Command is wrong";
    exit 1;
fi
if [[ $username == "" ]]; then
    clear;
    echo -e "${ERROR} Your Command is wrong";
    exit 1;
fi
if [[ $expired == "" ]]; then
    clear;
    echo -e "${ERROR} Your Command is wrong";
    exit 1;
fi

# // Input Data
Username=$username;
Jumlah_Hari=$expired;

# // Creating User database file
touch /etc/xray-mini/client.conf;

# // Expired Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Generate New UUID & Domain
domain=$( cat /etc/tridebleng/domain.txt );

# // Force create folder for fixing account wasted
mkdir -p /etc/tridebleng/cache/;
mkdir -p /etc/xray-mini/;
mkdir -p /etc/tridebleng/xray-mini-shadowsocks/;

# // Getting Vmess port using grep from config
port=$( cat /etc/xray-mini/shadowsocks.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );

export CHK=$( cat /etc/xray-mini/shadowsocks.json );
if [[ $CHK == "" ]]; then
    clear;
    echo -e "${ERROR} Your VPS Crash, Contact admin for fix it";
    exit 1;
fi

# // Input Your Data to server
cp /etc/xray-mini/shadowsocks.json /etc/tridebleng/xray-mini-utils/shadowsocks-backup.json;
cat /etc/tridebleng/xray-mini-utils/shadowsocks-backup.json | jq '.inbounds[0].settings.clients += [{"method": "chacha20-ietf-poly1305","password": "'${Username}'","email": "'${Username}'" }]' > /etc/xray-mini/shadowsocks.json;
echo -e "Shadowsocks $Username $exp" >> /etc/xray-mini/client.conf;

# // Make Config Link
basse64_genereate=$(echo -n "chacha20-ietf-poly1305:${Username}" | base64 -w0);
link_config="ss://${basse64_genereate}@${domain}:${port}#${Username}";

# // Restarting XRay Service
systemctl enable xray-mini@shadowsocks;
systemctl start xray-mini@shadowsocks;
systemctl restart xray-mini@shadowsocks;

tmp1=$(echo -n "chacha20-ietf-poly1305:${Username}@${domain}:$port#${Username}" | base64 -w0);

# // Make Client Folder for save the configuration
mkdir -p /etc/tridebleng/shadowsocks/;
mkdir -p /etc/tridebleng/shadowsocks/${Username};
rm -f /etc/tridebleng/shadowsocks/${Username}/config.log;

# // Success
sleep 1;
clear;
echo -e "Create From Panel | Shadowsocks" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e " Remarks     = ${Username}" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e " IP          = ${IP_NYA}" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e " Address     = ${domain}" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e " Port        = ${port}" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e " Password    = ${Username}" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e " SHADOWSOCKS CONFIG LINK" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e ' ```'${link_config}'```' | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e " Created     = ${hariini}" | tee -a /etc/tridebleng/shadowsocks/${Username}/config.log;
echo -e " Expired     = ${exp}";
echo -e "===============================";