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
echo -e "${RED_BG}                    Shadowsocks Over UDP                  ${NC}";
echo -e "${GREEN} 1${YELLOW})${NC}. Create Shadowsocks Account";
echo -e "${GREEN} 2${YELLOW})${NC}. Delete Shadowsocks Account";
echo -e "${GREEN} 3${YELLOW})${NC}. Renew Shadowsocks Account";
echo -e "${GREEN} 4${YELLOW})${NC}. List Config of Shadowsocks Account";
echo -e "${GREEN} 5${YELLOW})${NC}. Generate Shadowsocks trial Account";
echo -e "${GREEN} 6${YELLOW})${NC}. Remove All Expired Account";
echo -e "${GREEN} 7${YELLOW})${NC}. Check Shadowsocks User Login Session";
echo -e "${GREEN} 8${YELLOW})${NC}. Check Shadowsocks User Login Log";
echo -e "${GREEN} 9${YELLOW})${NC}. All Shadowsocks Account List";
echo "";
read -p "Please Choose one : " selection_mu;

node_name=ss;

case $selection_mu in
    1)
        add${node_name};
    ;;
    2)
        del${node_name};
    ;;
    3)
        renew${node_name};
    ;;
    4)
        ${node_name}config;
    ;;
    5)
        trial${node_name};
    ;;
    6)
        ${node_name}exp;
    ;;
    7)
        chk${node_name};
    ;;
    8)
        ${node_name}log;
    ;;
    9)
        ${node_name}list;
    ;;
    *)
        echo -e "${ERROR} Your Input is Wrong";
        sleep 1;
        ${node_name}-menu;
    ;;
esac