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
read -p "Input Username : " Pengguna;

if [[ $Pengguna == "root" ]]; then
    echo -e "${ERROR} Sorry Root User Cannot Be Removed !";
    exit 1;
fi
if getent passwd $Pengguna > /dev/null 2>&1; then
user=$(cat /etc/shadow | cut -d: -f1,8 | sed /:$/d | grep -w $Pengguna | cut -f1 -d:);
exp=$(cat /etc/shadow | cut -d: -f1,8 | sed /:$/d | grep -w $Pengguna | cut -f2 -d:);
userexpireinseconds=$(( $exp * 86400 ));
tglexp=`date -d @$userexpireinseconds +"%Y-%m-%d"`;  
clear;
cat /etc/tridebleng/ssh/${Pengguna}/config.log;
echo -e " Expired = $tglexp";
echo -e "===============================";
echo "";
echo -e "${INFO} Successfull Exported [ ${YELLOW}${Pengguna}${NC} ] Config";
else
        clear;
        echo -e "${ERROR} User ( ${YELLOW}$Pengguna${NC} ) Not Exists !";
        exit 1
fi