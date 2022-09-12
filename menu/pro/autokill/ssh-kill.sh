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

# // Check Your SSH Log User
if [ -e "/var/log/auth.log" ]; then
        OS=1;
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        OS=2;
        LOG="/var/log/secure";
fi

# // Validating SSH Log is in where ( ssh / sshd )
if [ $OS -eq 1 ]; then
    # // Restart SSH
	service ssh restart > /dev/null 2>&1;
fi
if [ $OS -eq 2 ]; then
    # // Restart SSHD
	service sshd restart > /dev/null 2>&1;
fi

# // Restart Dropbear
service dropbear restart > /dev/null 2>&1;

# // Inputing Max Login				
source /etc/tridebleng/autokill.conf;
if [[ $ENABLED == "0" ]]; then
    clear;
    echo -e "$(date) Autokill is disabled";
    exit 1;
elif [[ $ENABLED == "1" ]]; then
    ENABLECOY=true;
else
    clear;
    echo -e "$(date) Configuration not found";
    exit 1;
fi

MAX=$SSH;
if [[ $MAX == "" ]]; then
        echo -e "$(date) SSH Autokill No Setuped.";
fi

# // Start
echo "$(date) Autokill SSH MultiLogin for tridebleng Script V1.0 Stable";
echo "$(date) Coded by tridebleng ( Version 1.0 Beta )";
echo "$(date) Starting Vmess Autokill Service.";

# // Start Daemon
while true; do
sleep 30
cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /etc/tridebleng/ssh-user.db;
username1=( `cat "/etc/tridebleng/ssh-user.db" `);
i="0";
for user in "${username1[@]}"
do
    username[$i]=`echo $user | sed 's/'\''//g'`;
    jumlah[$i]=0;
    i=$i+1;
done
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /etc/tridebleng/ssh-autokill-cache.db;
proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
for PID in "${proc[@]}"
do
cat /etc/tridebleng/ssh-autokill-cache.db | grep "dropbear\[$PID\]" > /etc/tridebleng/autokill-ssh-cache1.db;
NUM=`cat /etc/tridebleng/autokill-ssh-cache1.db | wc -l`;
USER=`cat /etc/tridebleng/autokill-ssh-cache1.db | awk '{print $10}' | sed 's/'\''//g'`;
IP=`cat /etc/tridebleng/autokill-ssh-cache1.db | awk '{print $12}'`;
if [ $NUM -eq 1 ]; then
i=0;
for user1 in "${username[@]}"
do
    if [ "$USER" == "$user1" ]; then
        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
        pid[$i]="${pid[$i]} $PID";
    fi
    i=$i+1;
done
fi
done
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /etc/tridebleng/ssh-autokill-cache.db;
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
for PID in "${data[@]}"
do
cat /etc/tridebleng/ssh-autokill-cache.db | grep "sshd\[$PID\]" > /etc/tridebleng/autokill-ssh-cache1.db;
NUM=`cat /etc/tridebleng/autokill-ssh-cache1.db | wc -l`;
USER=`cat /etc/tridebleng/autokill-ssh-cache1.db | awk '{print $9}'`;
IP=`cat /etc/tridebleng/autokill-ssh-cache1.db | awk '{print $11}'`;
if [ $NUM -eq 1 ]; then
i=0;
for user1 in "${username[@]}"
do
    if [ "$USER" == "$user1" ]; then
        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
        pid[$i]="${pid[$i]} $PID";
    fi
    i=$i+1;
done
fi
done
j="0";
for i in ${!username[*]}
do
    if [ ${jumlah[$i]} -gt $MAX ]; then
        date=`date +"%X"`;
        echo "SSH - $(date) - ${username[$i]} - Multi Login Detected - Killed at ${date}";
        echo "SSH - $(date) - ${username[$i]} - Multi Login Detected - Killed at ${date}" >> /etc/tridebleng/autokill.log;
        kill ${pid[$i]};
        pid[$i]="";
        j=`expr $j + 1`;
    fi
done
if [ $j -gt 0 ]; then
    if [ $OS -eq 1 ]; then
        service ssh restart > /dev/null 2>&1;
    fi
    if [ $OS -eq 2 ]; then
        service sshd restart > /dev/null 2>&1;
    fi
        service dropbear restart > /dev/null 2>&1;
        j=0;
fi
done