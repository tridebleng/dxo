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
clear;
echo -n > /tmp/other.txt;
echo -n > /etc/tridebleng/cache/vmess_temp.txt;
echo -n > /etc/tridebleng/cache/vmess_temp2.txt;
data=(`cat /etc/xray-mini/client.conf | grep '^Vmess' | cut -d " " -f 2`);
echo "=============================================";
echo "             WebSocket TLS Login";
echo "=============================================";
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada";
fi
echo -n > /etc/tridebleng/cache/vmess_temp.txt;
data2=( `netstat -anp | grep ESTABLISHED | grep 'tcp6\|udp6' | grep xray-mini | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /etc/tridebleng/xray-mini-tls/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq);
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /etc/tridebleng/cache/vmess_temp.txt;
else
echo "$ip" >> /etc/tridebleng/cache/vmess_temp2.txt;
fi
jum2=$(cat /etc/tridebleng/cache/vmess_temp.txt);
sed -i "/$jum2/d" /etc/tridebleng/cache/vmess_temp2.txt > /dev/null 2>&1;
done
jum=$(cat /etc/tridebleng/cache/vmess_temp.txt);
if [[ -z "$jum" ]]; then
echo > /dev/null;
else
jum2=$(cat /etc/tridebleng/cache/vmess_temp.txt | nl);
hariini=`date -d "0 days" +"%Y-%m-%d"`;
echo "Username : $akun";
echo "$jum2";
echo "";
fi
done
echo "=============================================";
echo "           WebSocket NonTLS Login";
echo "=============================================";
echo -n > /etc/tridebleng/cache/vmess_temp3.txt;
data=(`cat /etc/xray-mini/client.conf | grep '^Vmess' | cut -d " " -f 2`);
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada";
fi
ip=$( cat /etc/tridebleng/xray-mini-nontls/access.log | grep "$(date -d "0 days" +"%H:%M" )" | grep -w $akun | tail -n100 | awk '{print $3}' | cut -d: -f1 | sort | uniq );
if [[ -z "$ip" ]]; then
echo > /dev/null
else
jum5=$(echo $ip | nl);
hariini=`date -d "0 days" +"%Y-%m-%d"`;
echo "Username : $akun";
echo "$jum5";
echo "";
fi
done
echo "=============================================";
echo "            GRPC IP Login List";
echo "=============================================";
oth=$(cat /etc/tridebleng/cache/vmess_temp2.txt | sort | uniq | nl )
echo "GRPC IP : All User IP";
echo "$oth";
echo "=============================================";
echo "";
rm -rf /etc/tridebleng/cache/vmess_temp2.txt;
rm -rf /etc/tridebleng/cache/vmess_temp.txt;
rm -rf /etc/tridebleng/cache/vmess_temp3.txt;