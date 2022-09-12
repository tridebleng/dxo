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

# // Start Menu
echo " List Of Avaiable ShadowsocksR Protocols";
echo "===============================================";
echo "  1. origin";
echo "  2. auth_sha1";
echo "  3. auth_sha1_v2";
echo "  4. auth_sha1_v4";
echo "===============================================";
read -p "Choose One Protocols You Want Use ( 1-4 ) : " choose_protocols;
case $choose_protocols in
    1) # Origin
        Protocols="origin";
    ;;
    2) # auth_sha1
        Protocols="auth_sha1";
    ;;
    3) # auth_sha1_v2
        Protocols="auth_sha1_v2";
    ;;
    4) # auth_sha1_v4
        Protocols="auth_sha1_v4";
    ;;
    *) # No Choose
        clear;
        echo -e "${ERROR} Please Choose One Protocols !";
        exit 1;
    ;;
esac

# // Clear
clear;

# // Choose Obfs
echo " List Of Avaiable ShadowsocksR Obfs";
echo "===============================================";
echo " 1. plain";
echo " 2. http_simple";
echo " 3. http_post";
echo " 4. tls_simple";
echo " 5. tls1.2_ticket_auth";
echo "===============================================";
read -p "Choose One Obfs You Want Use ( 1-5 ) : " choose_obfs;
case $choose_obfs in
    1) # plain
        obfs="plain";
    ;;
    2) # http_simple
        obfs="http_simple";
    ;;
    3) # http_post
        obfs="http_post";
    ;;
    4) # tls_simple
        obfs="tls_simple";
    ;;
    5) # tls1.2_ticket_auth_compatible
        obfs="tls1.2_ticket_auth_compatible";
    ;;
    *) # No Choose
        clear;
        echo -e "${ERROR} Please Choose One Obfs !";
        exit 1;
    ;;
esac

clear;

read -p "Username   : " Username;
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r')";

touch /etc/tridebleng/ssr-client.conf
if [[ $Username == "$( cat /etc/tridebleng/ssr-client.conf | grep -w $Username | head -n1 | awk '{print $2}' )" ]]; then
clear;
echo -e "${ERROR} Account With ( ${YELLOW}$Username ${NC}) Already Exists !";
exit 1;
fi
Domain=$( cat /etc/tridebleng/domain.txt );

read -p "Max Login  : " max_log;
if [[ $max_log == "" ]]; then
    clear;
    echo -e "${ERROR} Please Input Max Login";
    exit 1;
fi
read -p "Expired    : " Jumlah_Hari;
clear;
echo "===================================================";
echo " Press [ ENTER ] to disable bandwidth limiting";
echo " The bandwidth limit is calculated in Giga Bytes";
echo " Example | Limit 1TB Bandwidth Just Type 1024";
echo "===================================================";
echo "";
read -p "Bandwidth Limit : " bandwidth_allowed;

if [[ $bandwidth_allowed == "" ]]; then
    bandwidth_alloweds="Unlimited";
    bandwidth_allowed="1024000";
else
    bandwidth_alloweds="$bandwidth_allowed GB";
fi

# // Count Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Port Configuration
if [[ $(cat /etc/tridebleng/ssr-server/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 ) == "" ]]; then
Port=1200;
else
Port=$(( $(cat /etc/tridebleng/ssr-server/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 ) + 1 ));
fi

# // Adding User To Configuration
echo -e "SSR $Username $exp $Port" >> /etc/tridebleng/ssr-client.conf;

# // Adding User To ShadowsocksR Server
cd /etc/tridebleng/ssr-server/;
match_add=$(python mujson_mgr.py -a -u "${Username}" -p "${Port}" -k "${Username}" -m "aes-256-cfb" -O "${Protocols}" -G "${max_log}" -o "${obfs}" -s "0" -S "0" -t "${bandwidth_allowed}" -f "bittorrent" | grep -w "add user info");
cd;

# // Make Client Configuration Link
tmp1=$(echo -n "${Username}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g');
SSRobfs=$(echo ${obfs} | sed 's/_compatible//g');
tmp2=$(echo -n "${IP}:${Port}:${Protocols}:aes-256-cfb:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0);
ssr_link="ssr://${tmp2}";

# // Restarting Service
/etc/init.d/ssr-server restart;

# // Make Cache Folder
rm -rf /etc/tridebleng/ssr/${Username};
mkdir -p /etc/tridebleng/ssr/${Username}/

# // Clear
clear;

# // Successfull
echo "Your Premium ShadowsocksR" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo "==============================" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " IP         = "'```'"${IP}"'```'"" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " Domain     = $Domain" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " Username   = $Username" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " Password   = $Username" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " Port       = $Port" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " Protocols  = $Protocols" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " Obfs       = $obfs" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " Max Login  = $max_log Device" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " BW Limit   = $bandwidth_alloweds" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo "==============================" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " ShadowsocksR Config Link" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo ' ```'$ssr_link'```' | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo "==============================" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " Created    = $hariini" | tee -a /etc/tridebleng/ssr/${Username}/config.log;
echo " Expired    = $exp";
echo "==============================";
