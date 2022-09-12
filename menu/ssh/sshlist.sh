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
echo "==================================";
echo "Username          Expired Date    ";
echo "==================================";
while read expired; do
AKUN="$(echo $expired | cut -d: -f1)";
ID="$(echo $expired | grep -v nobody | cut -d: -f3)";
exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')";
if [[ $ID -ge 1000 ]]; then
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     ";
fi
done < /etc/passwd;
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)";
echo "==================================";
echo "Total Account : $JUMLAH Client";
echo "==================================";
echo "";