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

# // Start
grep -c -E "^Shadowsocks " "/etc/xray-mini/client.conf" > /etc/tridebleng/jumlah-akun-shadowsocks.db;
grep "^Shadowsocks " "/etc/xray-mini/client.conf" | awk '{print $2}'  > /etc/tridebleng/akun-shadowsocks.db;
totalaccounts=`cat /etc/tridebleng/akun-shadowsocks.db | wc -l`;
echo "Total Akun = $totalaccounts" > /etc/tridebleng/total-akun-shadowsocks.db;
for((i=1; i<=$totalaccounts; i++ ));
do
    # // Username Interval Counting
    username=$( head -n $i /etc/tridebleng/akun-shadowsocks.db | tail -n 1 );
    expired=$( grep "^Shadowsocks " "/etc/xray-mini/client.conf" | grep -w $username | head -n1 | awk '{print $3}' );

    # // Counting On Simple Algoritmatika
    now=`date -d "0 days" +"%Y-%m-%d"`;
    d1=$(date -d "$expired" +%s);
    d2=$(date -d "$now" +%s);
    sisa_hari=$(( (d1 - d2) / 86400 ));

# // Validate Use If Syntax
if [[ $sisa_hari -lt 1 ]]; then
    # // Removing Data From Server Configuration
    cp /etc/xray-mini/shadowsocks.json /etc/tridebleng/xray-mini-utils/shadowsocks-backup.json;
    cat /etc/tridebleng/xray-mini-utils/shadowsocks-backup.json | jq 'del(.inbounds[0].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/shadowsocks.json;
    rm -rf /etc/tridebleng/shadowsocks/${username};
    sed -i "/\b$username\b/d" /etc/xray-mini/client.conf;
    systemctl restart xray-mini@shadowsocks;

    # // Successfull Deleted Expired Client
    echo "Username : $username | Expired : $expired | Deleted $now" >> /etc/tridebleng/shadowsocks-expired-deleted.db;
    echo "Username : $username | Expired : $expired | Deleted $now";

else
    Skip="true";
fi

# // End Function
done