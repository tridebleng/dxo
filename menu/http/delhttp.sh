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

# // Clear Data
clear;

# // Start
CLIENT_001=$(grep -c -E "^Http " "/etc/xray-mini/client.conf" );
echo "    ==================================================";
echo "           LIST HTTP PROXY CLIENT ON THIS VPS";
echo "    ==================================================";
grep -e "^Http " "/etc/xray-mini/client.conf" | cut -d ' ' -f 2-8 | nl -s ') ';
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
client=$(grep "^Http " "/etc/xray-mini/client.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_002}"p);
expired=$(grep "^Http " "/etc/xray-mini/client.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_002}"p);
cp /etc/xray-mini/http.json /etc/tridebleng/xray-mini-utils/http-backup.json;
cat /etc/tridebleng/xray-mini-utils/http-backup.json | jq 'del(.inbounds[0].settings.accounts[] | select(.user == "'${client}'"))' > /etc/xray-mini/http.json;
rm -rf /etc/tridebleng/http/${client};
sed -i "/\b$client\b/d" /etc/xray-mini/client.conf;
systemctl restart xray-mini@http;
clear;
echo -e "${OKEY} Username ( ${YELLOW}$client${NC} ) Has Been Removed !";