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

# // Remove User
read -p "Input Username : " Pengguna;

if [[ $Pengguna == "root" ]]; then
    echo -e "${ERROR} Sorry Root User Cannot Be Removed !";
    exit 1;
fi
if [[ $Pengguna == "" ]]; 
    clear;
    echo -e "${ERROR} Please Input a username to remove";
    exit 1;
fi
if getent passwd $Pengguna > /dev/null 2>&1; then
        userdel -f $Pengguna;
        rm -rf /etc/tridebleng/ssh/${Pengguna};
        echo -e "${OKEY} User ( ${YELLOW}$Pengguna${NC} ) Has Been Removed !";
else
        clear;
        echo -e "${ERROR} User ( ${YELLOW}$Pengguna${NC} ) Not Exists !";
        exit 1;
fi