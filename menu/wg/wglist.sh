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
CLIENT_001=$( grep -c -E "^#DEPAN " "/etc/wireguard/wg0.conf" );
echo "    ==================================================";
echo "            LIST WIREGUARD CLIENT ON THIS VPS";
echo "    ==================================================";
grep -e "^#DEPAN " "/etc/wireguard/wg0.conf" | cut -d ' ' -f 2-8 | nl -s ') ';
echo "    ==================================================";
echo "";