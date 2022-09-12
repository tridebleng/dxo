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

# // Input Data
clear;
Username="Trial-$( </dev/urandom tr -dc 0-9A-Z | head -c4 )";
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )"; # > // Filtering If User Type Space

# // Validate Input
if [[ $Username == "" ]]; then
    clear;
    echo -e "${EROR} Please Input an Username !";
    exit 1;
fi

# // Creating User database file
touch /etc/xray-mini/client.conf;

# // Checking User already on vps or no
if [[ "$( cat /etc/xray-mini/client.conf | grep -w ${Username})" == "" ]]; then
    Do=Nothing;
else
    clear;
    echo -e "${ERROR} User ( ${YELLOW}$Username${NC} ) Already Exists !";
    exit 1;
fi

# // Expired Date
Jumlah_Hari=1;
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Generate New UUID & Domain
uuid=$( cat /proc/sys/kernel/random/uuid );
domain=$( cat /etc/tridebleng/domain.txt );

# // Force create folder for fixing account wasted
mkdir -p /etc/tridebleng/cache/;
mkdir -p /etc/xray-mini/;
mkdir -p /etc/tridebleng/xray-mini-tls/;
mkdir -p /etc/tridebleng/xray-mini-nontls/;

# // Getting Vmess port using grep from config
tls_port=$( cat /etc/xray-mini/tls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );
nontls_port=$( cat /etc/xray-mini/nontls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );

export CHK=$( cat /etc/xray-mini/tls.json );
if [[ $CHK == "" ]]; then
    clear;
    echo -e "${ERROR} Your VPS Crash, Contact admin for fix it";
    exit 1;
fi

# // Input Your Data to server
cp /etc/xray-mini/tls.json /etc/tridebleng/xray-mini-utils/tls-backup.json;
cat /etc/tridebleng/xray-mini-utils/tls-backup.json | jq '.inbounds[3].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'"}]' > /etc/tridebleng/xray-mini-cache.json;
cat /etc/tridebleng/xray-mini-cache.json | jq '.inbounds[6].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'"}]' > /etc/xray-mini/tls.json;
cp /etc/xray-mini/nontls.json /etc/tridebleng/xray-mini-utils/nontls-backup.json;
cat /etc/tridebleng/xray-mini-utils/nontls-backup.json | jq '.inbounds[1].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'"}]' > /etc/xray-mini/nontls.json;
echo -e "Vless $Username $exp" >> /etc/xray-mini/client.conf;

# // Make Config Link
vless_nontls="vless://${uuid}@${domain}:${nontls_port}?path=%2Fvless&security=none&encryption=none&type=ws#${Username}";
vless_tls="vless://${uuid}@${domain}:${tls_port}?path=%2Fvless&security=tls&encryption=none&type=ws#${Username}";
vless_grpc="vless://${uuid}@${domain}:${tls_port}?mode=gun&security=tls&encryption=none&type=grpc&serviceName=Vless-GRPC#${Username}";

# // Restarting XRay Service
systemctl enable xray-mini@tls;
systemctl enable xray-mini@nontls;
systemctl start xray-mini@tls;
systemctl start xray-mini@nontls;
systemctl restart xray-mini@tls;
systemctl restart xray-mini@nontls;

# // Make Client Folder for save the configuration
mkdir -p /etc/tridebleng/vless/;
mkdir -p /etc/tridebleng/vless/${Username};
rm -f /etc/tridebleng/vless/${Username}/config.log;

# // Success
sleep 1;
clear;
echo -e "Your Trial Vless Details" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " Remarks     = ${Username}" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " IP          = ${IP_NYA}" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " Address     = ${domain}" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " Port TLS    = ${tls_port}" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " Port NTLS   = ${nontls_port}" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " User ID     = ${uuid}" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " GRPC VLESS CONFIG LINK" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e ' ```'${vless_grpc}'```' | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " WS TLS VLESS CONFIG LINK" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e ' ```'${vless_tls}'```' | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " WS NTLS VLESS CONFIG LINK" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e ' ```'${vless_nontls}'```' | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " Created     = ${hariini}" | tee -a /etc/tridebleng/vless/${Username}/config.log;
echo -e " Expired     = ${exp}";
echo -e "===============================";