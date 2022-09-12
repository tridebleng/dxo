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

# // Inputing Max Login				
source /etc/tridebleng/autokill.conf;
if [[ $ENABLED == "0" ]]; then
    clear;
    echo -e "$(date) Autokill is disabled";
    exit 1;
elif [[ $ENABLED == "1" ]]; then
    ENABLECOY=true;
else
    clear;
    echo -e "$(date) Configuration not found";
    exit 1;
fi

if [[ $VLESS == "" ]]; then
        echo -e "$(date) Vless Autokill No Setuped.";
fi

# // Start
echo "$(date) Autokill Vless MultiLogin for tridebleng Script V1.0 Stable";
echo "$(date) Coded by tridebleng ( Version 1.0 Beta )";
echo "$(date) Starting Vless Autokill Service.";

while true; do
sleep 30
# // Start
grep -c -E "^Vless " "/etc/xray-mini/client.conf" > /etc/tridebleng/jumlah-akun-vless.db;
grep "^Vless " "/etc/xray-mini/client.conf" | awk '{print $2}'  > /etc/tridebleng/akun-vless.db;
totalaccounts=`cat /etc/tridebleng/akun-vless.db | wc -l`;
echo "Total Akun = $totalaccounts" > /etc/tridebleng/total-akun-vless.db;
for((i=1; i<=$totalaccounts; i++ ));
do
    # // Username Interval Counting
    username=$( head -n $i /etc/tridebleng/akun-vless.db | tail -n 1 );
    expired=$( grep "^Vless " "/etc/xray-mini/client.conf" | grep -w $username | head -n1 | awk '{print $3}' );

    # // Creating Cache for access.log
    cat /etc/tridebleng/xray-mini-nontls/access.log | tail -n30000 > /etc/tridebleng/xray-mini-nontls/cache.log

    # // Configuration user logs
    hariini=`date -d "0 days" +"%Y/%m/%d"`;
    waktu=`date -d "0 days" +"%H:%M"`;
    waktunya=`date -d "0 days" +"%Y/%m/%d %H:%M"`;
    jumlah_baris_log=$( cat /etc/tridebleng/xray-mini-nontls/cache.log | grep -w $hariini | grep -w $waktu | grep -w 'accepted' | grep -w $username | wc -l );

    if [[ $jumlah_baris_log -gt $VLESS ]]; then
        cp /etc/xray-mini/tls.json /etc/tridebleng/xray-mini-utils/tls-backup.json;
        cat /etc/tridebleng/xray-mini-utils/tls-backup.json | jq 'del(.inbounds[3].settings.clients[] | select(.email == "'${username}'"))' > /etc/tridebleng/xray-mini-cache.json;
        cat /etc/tridebleng/xray-mini-cache.json | jq 'del(.inbounds[6].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/tls.json;
        cp /etc/xray-mini/nontls.json /etc/tridebleng/xray-mini-utils/nontls-backup.json;
        cat /etc/tridebleng/xray-mini-utils/nontls-backup.json | jq 'del(.inbounds[1].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/nontls.json;
        rm -rf /etc/tridebleng/vless/${username};
        sed -i "/\b$username\b/d" /etc/xray-mini/client.conf;
        systemctl restart xray-mini@tls;
        systemctl restart xray-mini@nontls;
        date=`date +"%X"`;
        echo "$(date) ${username} - Multi Login Detected - Killed at ${date}"
        echo "VLESS - $(date) - ${username} - Multi Login Detected - Killed at ${date}" >> /etc/tridebleng/autokill.log;
    fi

    # // Creating Cache for access.log
    cat /etc/tridebleng/xray-mini-tls/access.log | tail -n30000 > /etc/tridebleng/xray-mini-tls/cache.log

    # // Configuration user logs
    hariini=`date -d "0 days" +"%Y/%m/%d"`;
    waktu=`date -d "0 days" +"%H:%M"`;
    waktunya=`date -d "0 days" +"%Y/%m/%d %H:%M"`;
    jumlah_baris_log=$( cat /etc/tridebleng/xray-mini-tls/cache.log | grep -w $hariini | grep -w $waktu | grep -w 'accepted' | grep -w $username | wc -l );

    if [[ $jumlah_baris_log -gt $VLESS ]]; then
        cp /etc/xray-mini/tls.json /etc/tridebleng/xray-mini-utils/tls-backup.json;
        cat /etc/tridebleng/xray-mini-utils/tls-backup.json | jq 'del(.inbounds[3].settings.clients[] | select(.email == "'${username}'"))' > /etc/tridebleng/xray-mini-cache.json;
        cat /etc/tridebleng/xray-mini-cache.json | jq 'del(.inbounds[6].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/tls.json;
        cp /etc/xray-mini/nontls.json /etc/tridebleng/xray-mini-utils/nontls-backup.json;
        cat /etc/tridebleng/xray-mini-utils/nontls-backup.json | jq 'del(.inbounds[1].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/nontls.json;
        rm -rf /etc/tridebleng/vless/${username};
        sed -i "/\b$username\b/d" /etc/xray-mini/client.conf;
        systemctl restart xray-mini@tls;
        systemctl restart xray-mini@nontls;
        date=`date +"%X"`;
        echo "$(date) ${username} - Multi Login Detected - Killed at ${date}"
        echo "VLESS - $(date) - ${username} - Multi Login Detected - Killed at ${date}" >> /etc/tridebleng/autokill.log;
    fi
# // End Function
done
done