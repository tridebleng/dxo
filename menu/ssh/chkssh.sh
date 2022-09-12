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

# // String For File Path
if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
elif [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi

echo " ";
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
echo "  =========== DropBear Login ===========";
echo "   ID  |    Username    |   IP Address";
echo "  ======================================";
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $10}' | sed "s/'//g"`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $12}'`;
        if [ $NUM -eq 1 ]; then
                echo "   $PID - $USER - $IP";
        fi
done
echo " ";
echo "  =========== Open-SSH Login ===========";
echo "   ID  |    Username    |   IP Address";
echo "  ======================================";
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt;
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $9}'`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "   $PID - $USER - $IP";
        fi
done

echo " "
echo "  =========== Open-VPN Login ===========";
echo "    Username     |    IP Address";
echo "  ======================================";

line=$( cat /etc/openvpn/login.log | wc -l );
a=$((3+((line-8)/2)));
b=$(((line-8)/2));
user=$( cat /etc/openvpn/login.log | head -n $a | tail -n $b | cut -d "," -f 1  );
for jumlah in $user; do
    line=$( cat /etc/openvpn/login.log | wc -l);
    a=$((3+((line-8)/2)));
    b=$(((line-8)/2));
    user=$( cat /etc/openvpn/login.log | grep -w $jumlah | head -n $a | tail -n $b | cut -d "," -f 1 | head -n1 );
    address=$( cat /etc/openvpn/login.log | grep -w $jumlah | head -n $a | tail -n $b | cut -d "," -f 2  | head -n1 );
    echo "    ${user} - ${address}";
done

echo "  ======================================";
echo "";