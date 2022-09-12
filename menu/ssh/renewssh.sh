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

# // Input Username
read -p "Username : " Username;

# // Checking User Avaiable Or No
if [[ $( cat /etc/shadow | cut -d: -f1,8 | sed /:$/d | grep -w $Username ) == "" ]]; then
    clear;
    echo -e "${ERROR} User ( ${YELLOW}$Username${NC} ) Not Exists !";
    exit 1;
else
read -p "Expired  : " Days;

# // String For Date Details
Today=`date +%s`;
Total_Penambahan=$(( $Days * 86400 ));
Expired_Pada=$(($Today + $Total_Penambahan));
Expired_Counted_1=$(date -u --date="1970-01-01 $Expired_Pada sec GMT" +%Y/%m/%d);
Expired=$(date -u --date="1970-01-01 $Expired_Pada sec GMT" '+%Y-%m-%d');

# // Change Expired Date On Server
passwd -u $Username > /dev/null 2>&1;
usermod -e $Expired_Counted_1 $Username > /dev/null 2>&1;
egrep "^$User" /etc/passwd > /dev/null 2>&1;
echo -e "$Pass\n$Pass\n"|passwd $User > /dev/null 2>&1;

# // Clear
clear;

# // Successfull
echo -e "${OKEY} User ( ${YELLOW}${Username}${NC} ) Renewed Then Expired On ( ${YELLOW}$Expired${NC} )";
fi