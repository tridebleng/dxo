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
CLIENT_001=$(grep -c -E "^Vless " "/etc/xray-mini/client.conf" )
echo "    ==================================================";
echo "              LIST VLESS CLIENT ON THIS VPS";
echo "    ==================================================";
grep -e "^Vless " "/etc/xray-mini/client.conf" | cut -d ' ' -f 2-8 | nl -s ') ';
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

# // Extending Days
clear;
read -p "Expired  : " Jumlah_Hari;
if [[ $Jumlah_Hari == "" ]]; then
    clear;
    echo -e "${ERROR} Input How Many Days you wanna to extend";
    exit 1;
fi

# // Date Configuration
now=$(date +%Y-%m-%d);
d1=$(date -d "$expired" +%s);
d2=$(date -d "$now" +%s);
exp2=$(( (d1 - d2) / 86400 ));
exp3=$(($exp2 + $Jumlah_Hari));
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`;

# // Input To System Configuration
sed -i "/\b$client\b/d" /etc/xray-mini/client.conf;
echo -e "Vless $client $exp4" >> /etc/xray-mini/client.conf;

# // Clear
clear;

# // Successfull
echo -e "${OKEY} User ( ${YELLOW}${client}${NC} ) Renewed Then Expired On ( ${YELLOW}$exp4${NC} )";