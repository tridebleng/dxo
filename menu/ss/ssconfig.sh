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

# // Start
CLIENT_001=$(grep -c -E "^Shadowsocks " "/etc/xray-mini/client.conf" );
echo "    ==================================================";
echo "           LIST SHADOWSOCKS CLIENT ON THIS VPS";
echo "    ==================================================";
grep -e "^Shadowsocks " "/etc/xray-mini/client.conf" | cut -d ' ' -f 2-8 | nl -s ') ';
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
client=$(grep "^Shadowsocks " "/etc/xray-mini/client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p);
expired=$(grep "^Shadowsocks " "/etc/xray-mini/client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p);
clear;
cat /etc/tridebleng/shadowsocks/${client}/config.log;
echo -e " Expired     = ${expired}";
echo -e "===============================";
echo "";
echo -e "${INFO} Successfull Exported [ ${YELLOW}${client}${NC} ] Config";