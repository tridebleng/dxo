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
read -p "Input Your Backup ID : " Backup_ID
if [[ $Backup_ID == "" ]]; then
    clear;
    echo -e "${ERROR} Please input backup ID";
    exit 1;
fi

# // Restore The Backup
link="https://drive.google.com/u/4/uc?id=${Backup_ID}&export=download";
mkdir -p /root/cache-restore/;
cd /root/cache-restore/;
wget -q -O /root/cache-restore/restore.zip "${link}";
unzip -o /root/cache-restore/restore.zip > /dev/null 2>&1;
rm restore.zip;
if [[ -f /root/cache-restore/passwd ]]; then
    passed=true;
else
    cd /root/;
    rm -rf /root/cache-restore/;
    clear;
    echo -e "${ERROR} Having Error in your backup ID";
    exit 1;
fi

# // Copy the backup to destination
cp /etc/tridebleng/domain.txt /root/cache-restore/domain.txt;
cp -r xray-mini /etc/;
cp -r tridebleng /etc/;
cp passwd /etc/passwd;
cp group /etc/group;
cp shadow /etc/shadow;
cp gshadow /etc/gshadow;
cp -r wireguard /etc/;
mv domain.txt /etc/tridebleng/domain.txt;
cd /root/;
rm -rf /root/cache-restore/;

# // Configuration Domain
domain=$( cat /etc/tridebleng/domain.txt );
if [[ $domain == "" ]]; then
    clear;
    echo -e "${ERROR} Your Domain no detected.";
    exit 1;
fi

# // Change XRay Certificate Path
key_path_default=$( cat /etc/xray-mini/tls.json | jq '.inbounds[0].streamSettings.xtlsSettings.certificates[]' | jq -r '.certificateFile' );
cp /etc/xray-mini/tls.json /etc/xray-mini/tls.json_temp;
cat /etc/xray-mini/tls.json_temp | jq 'del(.inbounds[0].streamSettings.xtlsSettings.certificates[] | select(.certificateFile == "'${key_path_default}'"))' > /etc/xray-mini/tls2.json_temp;
cat /etc/xray-mini/tls2.json_temp | jq '.inbounds[0].streamSettings.xtlsSettings.certificates += [{"certificateFile": "'/root/.acme.sh/${domain}_ecc/fullchain.cer'","keyFile": "'/root/.acme.sh/${domain}_ecc/${domain}.key'"}]' > /etc/xray-mini/tls.json;
rm -rf /etc/xray-mini/tls2.json_temp;
rm -rf /etc/xray-mini/tls.json_temp;

# // Restarting Service
sleep 3;
systemctl restart xray-mini@tls;
systemctl restart xray-mini@socks;
systemctl restart xray-mini@http;
systemctl restart xray-mini@nontls;
systemctl restart wg-quick@wg0;
systemctl restart stunnel5;
systemctl restart vmess-kill;
systemctl restart vless-kill;
systemctl restart trojan-kill;
systemctl restart ss-kill;
systemctl restart ssh-kill;

# // Done
clear;
echo -e "${OKEY} Successfull Restores Backup to your vps";
exit 1;