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
clear;
Username="Trial-$( </dev/urandom tr -dc 0-9A-Z | head -c4 )";
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )";

# // Validate Input
if [[ $Username == "" ]]; then
    clear;
    echo -e "${ERROR} Please Input an Username !";
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
Jumlah_Hari=1
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d";`
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Generate New UUID & Domain
domain=$( cat /etc/tridebleng/domain.txt );

# // Force create folder for fixing account wasted
mkdir -p /etc/tridebleng/cache/;
mkdir -p /etc/xray-mini/;
mkdir -p /etc/tridebleng/xray-mini-http/;

# // Getting Vmess port using grep from config
port=$( cat /etc/xray-mini/http.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );

export CHK=$( cat /etc/xray-mini/http.json );
if [[ $CHK == "" ]]; then
    clear;
    echo -e "${ERROR} Your VPS Crash, Contact admin for fix it";
    exit 1;
fi

# // Input Your Data to server
cp /etc/xray-mini/http.json /etc/tridebleng/xray-mini-utils/http-backup.json;
cat /etc/tridebleng/xray-mini-utils/http-backup.json | jq '.inbounds[0].settings.accounts += [{"user": "'${Username}'","pass": "'${Username}'" }]' > /etc/xray-mini/http.json;
echo -e "Http $Username $exp" >> /etc/xray-mini/client.conf;

# // Restarting XRay Service
systemctl enable xray-mini@http;
systemctl start xray-mini@http;
systemctl restart xray-mini@http;

# // Make Client Folder for save the configuration
mkdir -p /etc/tridebleng/http/;
mkdir -p /etc/tridebleng/http/${Username};
rm -f /etc/tridebleng/http/${Username}/config.log;

# // Success
sleep 1;
clear;
echo -e "Your Trial HTTP Proxy" | tee -a /etc/tridebleng/http/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/http/${Username}/config.log;
echo -e " IP          = ${IP_NYA}" | tee -a /etc/tridebleng/http/${Username}/config.log;
echo -e " Address     = ${domain}" | tee -a /etc/tridebleng/http/${Username}/config.log;
echo -e " Port        = ${port}" | tee -a /etc/tridebleng/http/${Username}/config.log;
echo -e " User        = ${Username}" | tee -a /etc/tridebleng/http/${Username}/config.log;
echo -e " Password    = ${Username}" | tee -a /etc/tridebleng/http/${Username}/config.log;
echo -e "===============================" | tee -a /etc/tridebleng/http/${Username}/config.log;
echo -e " Created     = ${hariini}" | tee -a /etc/tridebleng/http/${Username}/config.log;
echo -e " Expired     = ${exp}";
echo -e "===============================";