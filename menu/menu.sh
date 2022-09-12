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

# // Export Align
export BOLD="\e[1m";
export WARNING="${RED}\e[5m";
export UNDERLINE="\e[4m";

# // Export OS Information
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );

# // String For Helping Installation
export VERSION="1.0";
export EDITION="Stable";
export AUTHER="tridebleng";
export ROOT_DIRECTORY="/etc/tridebleng";
export CORE_DIRECTORY="/usr/local/tridebleng";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/tridebleng/dxo/ipuk";
export REPO_URL="https://repository.tridebleng.com";

# // Clear
clear
echo -e "${RED_BG}                 VPS / Sytem Information                  ${NC}";
echo -e "Sever Uptime        = $( uptime -p  | cut -d " " -f 2-10000 ) ";
echo -e "Current Time        = $( date -d "0 days" +"%d-%m-%Y | %X" )";
echo -e "Operating System    = $( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' ) ( $( uname -m) )";
echo -e "Current Domain      = $( cat /etc/tridebleng/domain.txt )";
echo -e "Server IPv4         = ${IP_NYA}";
if [[ $STATUS_IPV6 == "0" ]]; then
IPv6=$( curl -s "https://ipv6.icanhazip.com");
if [[ $IPv6 == "" ]]; then
    IP_V6="Not Supported";
else
    IP_V6="${IPv6}";
fi
echo -e "Server IPv6         = ${IP_V6}";
fi
echo -e "Customer ID         = ${PELANGGAN_KE}";
echo -e "Activation Status   = $(if [[ $STATUS_IP == "active" ]]; then
echo -e "Activated"; else
echo -e "Inactive"; fi
)"
echo -e "License Type        = ${TYPE} Edition";
echo -e "License Issued to   = ${NAME}";
echo -e "License Start       = ${CREATED}";
echo -e "License Limit       = $( if [[ $UNLIMITED == "true" ]]; then
echo -e "Unlimited"; else
echo -e "${COUNT}/${LIMIT} VPS"; fi
)"
echo -e "License Expired     = $( if [[ $LIFETIME == "true" ]]; then
echo -e "Lifetime"; else
echo -e "${EXPIRED} ( $days_left Days Left )"; fi
)"

echo -e "";

echo -e "${RED_BG}                VPN Admin/Account Manager                 ${NC}";
echo -e "${GREEN} 1${YELLOW})${NC}. SSH & OpenVPN Account Manager";
echo -e "${GREEN} 2${YELLOW})${NC}. Vmess Account Manager";
echo -e "${GREEN} 3${YELLOW})${NC}. Vless Account Manager";
echo -e "${GREEN} 4${YELLOW})${NC}. Trojan Account Manager";
echo -e "${GREEN} 5${YELLOW})${NC}. Shadowsocks Account Manager";
echo -e "${GREEN} 6${YELLOW})${NC}. ShadowsocksR Account Manager";
echo -e "${GREEN} 7${YELLOW})${NC}. Wireguard Account Manager";
echo -e "${GREEN} 8${YELLOW})${NC}. Socks 4/5 Account Manager";
echo -e "${GREEN} 9${YELLOW})${NC}. HTTP Proxy Account Manager";
echo -e "";
echo -e "${RED_BG}                     Addons Service                       ${NC}";
echo -e "${GREEN}10${YELLOW})${NC}. Benchmark Speed ( Speedtest By Ookla )";
echo -e "${GREEN}11${YELLOW})${NC}. Checking Ram Usage";
echo -e "${GREEN}12${YELLOW})${NC}. Checking Bandwidth Usage";
echo -e "${GREEN}13${YELLOW})${NC}. Change Timezone";
echo -e "${GREEN}14${YELLOW})${NC}. Change License Key";
echo -e "${GREEN}15${YELLOW})${NC}. Autokill Menu | For Pro Only";
echo -e "${GREEN}16${YELLOW})${NC}. Change Domain / Host";

echo -e "${GREEN}17${YELLOW})${NC}. Renew SSL Certificate";
echo -e "${GREEN}18${YELLOW})${NC}. Add Email For Backup";
echo -e "${GREEN}19${YELLOW})${NC}. Backup VPN Client";
echo -e "${GREEN}20${YELLOW})${NC}. Restore VPN Client";
echo -e "${GREEN}21${YELLOW})${NC}. Auto Backup VPN Client";
echo -e "${GREEN}22${YELLOW})${NC}. DNS Changer";
echo -e "${GREEN}23${YELLOW})${NC}. Change Port For SSH & XRay";
echo -e "${GREEN}24${YELLOW})${NC}. System & Service Information";
echo -e "${GREEN}25${YELLOW})${NC}. Check Script Version";
echo -e "${GREEN}26${YELLOW})${NC}. Reboot Your Server";
echo -e "${GREEN}27${YELLOW})${NC}. Restarting All Service";
echo -e "${GREEN}28${YELLOW})${NC}. Update Your Script Version";
echo -e "${GREEN}29${YELLOW})${NC}. SpeedUP Your VPS";
echo -e "${GREEN}30${YELLOW})${NC}. Enable IPv6 Support";
echo -e "${GREEN}31${YELLOW})${NC}. Disable IPv6 Support";
echo -e "";

read -p "Input Your Choose ( 1-31 ) : " choosemu

case $choosemu in
    # // VPN Menu
    1) ssh-menu ;;
    2) vmess-menu ;;
    3) vless-menu ;;
    4) trojan-menu ;;
    5) ss-menu ;;
    6) ssr-menu ;;
    7) wg-menu ;;
    8) socks-menu ;;
    9) http-menu ;;

    # // Other
    10) clear && speedtest ;;
    11) clear && ram-usage ;;
    12) clear && vnstat ;;
    13)
        clear;
        echo -e "${RED_BG}                    Timezone Changer                       ${NC}";
        echo -e "${GREEN}1${YELLOW})${NC}. Asia / Jakarta / Indonesia ( GMT+7 )"
        echo -e "${GREEN}2${YELLOW})${NC}. Asia / Kuala Lumpur / Malaysia ( GMT+8 )"
        echo -e "${GREEN}3${YELLOW})${NC}. America / Chicago / US Central ( GMT-6 )"

        read -p "Choose one : " soefiewjfwefw
        if [[ $soefiewjfwefw == "1" ]]; then
                ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime;
                clear;
                echo -e "${OKEY} Successfull Set time to Jakarta ( GMT +7 )";
                exit 1;
        elif [[ $soefiewjfwefw == "2" ]]; then
                ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
                clear;
                echo -e "${OKEY} Successfull Set time to Malaysia ( GMT +8 )";
                exit 1;
        elif [[ $soefiewjfwefw == "2" ]]; then
                ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime;
                clear;
                echo -e "${OKEY} Successfull Set time to Malaysia ( GMT +8 )";
                exit 1;
        else
                clear;
                sleep 2;
                echo -e "${ERROR} Please Choose One option"
                menu;
        fi
    ;;
    14) lcn-change ;;
    15) autokill-menu ;;
    16) 
        clear;
        read -p "Input Your New Domain : " new_domains
        if [[ $new_domains == "" ]]; then
            clear;
            sleep 2;
            echo -e "${ERROR} Please Input New Domain for contitune";
            menu;
        fi

        # // Stopping Xray nontls
        systemctl stop xray-mini@nontls > /dev/null 2&>1

        # // Input Domain To VPS
        echo "$new_domains" > /etc/tridebleng/domain.txt;
        domain=$( cat /etc/tridebleng/domain.txt );

        # // Making Certificate
        clear;
        echo -e "${OKEY} Starting Generating Certificate";
        rm -rf /root/.acme.sh;
        mkdir -p /root/.acme.sh;
        wget -q -O /root/.acme.sh/acme.sh "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Core/acme.sh";
        chmod +x /root/.acme.sh/acme.sh;
        sudo /root/.acme.sh/acme.sh --register-account -m vpn-script@tridebleng.com;
        sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 -ak ec-256;

        # // Successfull Change Path to xray
        key_path_default=$( cat /etc/xray-mini/tls.json | jq '.inbounds[0].streamSettings.xtlsSettings.certificates[]' | jq -r '.certificateFile' );
        cp /etc/xray-mini/tls.json /etc/xray-mini/tls.json_temp;
        cat /etc/xray-mini/tls.json_temp | jq 'del(.inbounds[0].streamSettings.xtlsSettings.certificates[] | select(.certificateFile == "'${key_path_default}'"))' > /etc/xray-mini/tls2.json_temp;
        cat /etc/xray-mini/tls2.json_temp | jq '.inbounds[0].streamSettings.xtlsSettings.certificates += [{"certificateFile": "'/root/.acme.sh/${domain}_ecc/fullchain.cer'","keyFile": "'/root/.acme.sh/${domain}_ecc/${domain}.key'"}]' > /etc/xray-mini/tls.json;
        rm -rf /etc/xray-mini/tls2.json_temp;
        rm -rf /etc/xray-mini/tls.json_temp;

        # // Restart
        systemctl restart xray-mini@tls > /dev/null 2>&1
        systemctl restart xray-mini@nontls > /dev/null 2>&1

        # // Success
        echo -e "${OKEY} Your Domain : $domain";
        sleep 2;
        clear;
        echo -e "${OKEY} Successfull Change Domain to $domain";
        exit 1;
    ;;
    17) 
        domain=$(cat /etc/tridebleng/domain.txt);
        if [[ $domain == "" ]]; then
            clear;
            echo -e "${ERROR} VPS Having Something Wrong";
            exit 1
        fi
        echo -e "$OKEY Starting Certificate Renewal";
        sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256;
    ;;
    18)
        clear;
        read -p "Input Your Email : " email_input
        if [[ $email_input == "" ]]; then
            clear;
            echo -e "${ERROR} Please Input Email to contitune";
            exit 1;
        fi
        echo $email_input > /etc/tridebleng/email.txt
        clear;
        echo -e "${OKEY} Successfull Set Email For Backup";
    ;;
    19) backup ;;
    20) restore ;;
    21)
        clear;
        echo -e "${RED_BG}               AutoBackup ( 12:00 & 00:00 )                ${NC}";
        echo -e "${GREEN}1${YELLOW})${NC}. Enable AutoBackup"
        echo -e "${GREEN}2${YELLOW})${NC}. Disable AutoBackup"
        read -p "Choose one " choosenya
        if [[ $choosenya == "1" ]]; then 
            echo "0 */12 * * * root /usr/local/sbin/autobackup" > /etc/cron.d/auto-backup;
            /etc/init.d/cron restart;
            clear;
            echo -e "${OKEY} Successfull Enabled autobackup";
            exit 1;
        elif [[ $choosenya == "2" ]]; then
            rm -rf /etc/cron.d/auto-backup;
            /etc/init.d/cron restart;
            clear;
            echo -e "${OKEY} Successfull Disabled autobackup";
            exit 1;
        else
            clear;
            echo -e "${ERROR} Please Select a valid number"
            sleep 2;
            menu;
        fi
    ;;
    22)
        clear;
        read -p "DNS 1 ( Require )  : " dns1nya
        read -p "DNS 2 ( Optional ) : " dns2nya
        if [[ $dns1nya == "" ]]; then
            clear;
            echo -e "${ERROR} Please Input DNS 1";
            exit 1;
        fi
        if [[ $dns2nya == "" ]]; then
            echo "nameserver $dns1nya" > /etc/resolv.conf
            echo -e "${OKEY} Successful Change DNS To $dns1nya";
            exit 1;
        else
            echo "nameserver $dns1nya" > /etc/resolv.conf
            echo "nameserver $dns2nya" >> /etc/resolv.conf
            echo -e "${OKEY} Successful Change DNS To $dns1nya & $dns2nya";
            exit 1;
        fi
    ;;
    23) change-port ;;
    24) infonya ;;
    25) vpnscript ;;
    26) reboot ;;
    27) systemctl restart xray-mini@tls; systemctl restart xray-mini@nontls; systemctl restart xray-mini@socks; systemctl restart xray-mini@shadowsocks; systemctl restart xray-mini@http;
        systemctl restart nginx; systemctl restart fail2ban; systemctl restart ssr-server; systemctl restart dropbear; systemctl restart ssh; systemctl restart stunnel4; systemctl restart sslh;
        clear; echo -e "${OKEY} Successfull Restarted All Service";
    ;;
    28) cd /root/; wget -q -O /root/update.sh "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/update.sh"; chmod +x /root/update.sh; ./update.sh; rm -f /root/update.sh ;;
    29)
            clear
            # // clearlog
            echo -e "${OKEY} Cleaning Your VPS Cache & Logs";
            clearlog;
            sleep 1;

            # // Restart Network
            echo -e "${OKEY} Restarting Your VPS Network";
            systemctl restart networking > /dev/null 2>&1;

            # // Hapus Logs sys
            rm -f /var/log/syslog*
            echo -e "${OKEY} Cleaning Syslogs";
            sleep 1;

            # // Hapus Logs auth di ssh
            if [ -e "/var/log/auth.log" ]; then
                    LOG="/var/log/auth.log";
            elif [ -e "/var/log/secure" ]; then
                    LOG="/var/log/secure";
            fi
            rm -f ${LOG};
            echo -e "${OKEY} Cleaning Auth logs";

            # // Start BBR
            sysctl -p > /dev/null 2>&1;
            echo -e "${OKEY} Successfull Restarting BBR Service";

            # // Done
            sleep 1;
            clear;
            echo -e "${OKEY} Successfull SpeedUP Your VPS";
    ;;
    30) 
            STATUS_IPV6=$( cat /etc/sysctl.conf | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}' | cut -d " " -f 1 | sed 's/ //g' );
            if [[ $STATUS_IPV6 == "0" ]]; then
                clear;
                echo -e "${ERROR} IPv6 Already Enabled on this Server";
                exit 1;
            fi
            sed -i 's/net.ipv6.conf.all.disable_ipv6 = 1/net.ipv6.conf.all.disable_ipv6 = 0/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.default.disable_ipv6 = 1/net.ipv6.conf.default.disable_ipv6 = 0/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.lo.disable_ipv6 = 1/net.ipv6.conf.lo.disable_ipv6 = 0/g' /etc/sysctl.conf;
            sysctl -p;
            clear;
            echo -e "${OKEY} Successfull Enabled IPv6 Support";
    ;;
    31) 
            STATUS_IPV6=$( cat /etc/sysctl.conf | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}' | cut -d " " -f 1 | sed 's/ //g' );
            if [[ $STATUS_IPV6 == "1" ]]; then
                clear;
                echo -e "${ERROR} IPv6 Already Disabled on this Server";
                exit 1;
            fi
            sed -i 's/net.ipv6.conf.all.disable_ipv6 = 0/net.ipv6.conf.all.disable_ipv6 = 1/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.default.disable_ipv6 = 0/net.ipv6.conf.default.disable_ipv6 = 1/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.lo.disable_ipv6 = 0/net.ipv6.conf.lo.disable_ipv6 = 1/g' /etc/sysctl.conf;
            sysctl -p;
            clear;
            echo -e "${OKEY} Successfull Disabled IPv6 Support";
    ;;
    *)
        clear;
        sleep 2
        echo -e "${ERROR} Please Input an valid number";
        menu;
    ;;
esac        
