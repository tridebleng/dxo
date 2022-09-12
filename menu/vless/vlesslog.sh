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
CLIENT_001=$(grep -c -E "^Vless " "/etc/xray-mini/client.conf" );
echo "    ==================================================";
echo "              LIST VLESS CLIENT ON THIS VPS";
echo "    ==================================================";
grep -e "^Vless " "/etc/xray-mini/client.conf" | cut -d ' ' -f 2-8 | nl -s ') '
	until [[ ${CLIENT_002} -ge 1 && ${CLIENT_002} -le ${CLIENT_001} ]]; do
		if [[ ${CLIENT_002} == '1' ]]; then
                echo "    ==================================================";
			read -rp "    Please Input an Client Number (1-${CLIENT_001}) : " CLIENT_002;
		else
                echo "    ==================================================";
			read -rp "    Please Input an Client Number (1-${CLIENT_001}) : " CLIENT_002;
		fi
	done

# // String For Username && Expired Date
client=$(grep "^Vless " "/etc/xray-mini/client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p);
expired=$(grep "^Vless " "/etc/xray-mini/client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p);

# // Cat Log By User Auto
clear;
echo -e "${INFO} Logs Output has been successfull exported";
hariini=`date -d "0 days" +"%Y/%m/%d"`;
waktu=`date -d "0 days" +"%H"`;
waktunya=`date -d "0 days" +"%Y/%m/%d %H:%M"`;
cat /etc/tridebleng/xray-mini-nontls/access.log | grep -w $hariini | grep -w $waktu | tail -n500 | grep -w 'accepted' | grep -w $client;
cat /etc/tridebleng/xray-mini-tls/access.log | grep -w $hariini | grep -w $waktu | tail -n500 | grep -w 'accepted' | grep -w $client;
echo -e "${INFO} The Logs is captured at [ ${GREEN}${waktunya}${NC} ]";