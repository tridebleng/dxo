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

# // Check Email
if [[ -f /etc/tridebleng/email.txt ]]; then
    Skip=true;
else 
    clear;
    echo -e "${ERROR} Please set email first for backup";
    exit 1;
fi
email_mu=$( cat /etc/tridebleng/email.txt );

# // Backup your data
rm -rf /root/backup-dir-cache/;
mkdir -p /root/backup-dir-cache/;
cd /root/backup-dir-cache/;
cp -r /etc/xray-mini /root/backup-dir-cache/;
cp -r /etc/tridebleng /root/backup-dir-cache/;
cp /etc/passwd /root/backup-dir-cache/;
cp /etc/group /root/backup-dir-cache/;
cp /etc/gshadow /root/backup-dir-cache/;
cp /etc/shadow /root/backup-dir-cache/;
cp -r /etc/wireguard /root/backup-dir-cache/;
echo "$(date)" > created.date;
echo "(C) Copyright by tridebleng" > Copyright;
echo "1.0" > script-version;
zip -r backup.zip * > /dev/null 2>&1;
cp backup.zip /root/;
cd;
rm -rf /root/backup-dir-cache/;
date=$(date +"%Y-%m-%d-%H-%M");
cd /root/
mv backup.zip $IP_NYA-$date.zip
tanggal=$(date +"%Y-%m-%d %X");

# // Upload to rclone
wget -q -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/rclone_conf";
rclone copy "$IP_NYA-$date.zip" tridebleng:Script-VPN-Backup/
url=$(rclone link "tridebleng:Script-VPN-Backup/$IP_NYA-$date.zip")
F_ID=(`echo $url | grep '^https' | cut -d'=' -f2`)
rm -f /root/.config/rclone/rclone.conf
rm -f $IP_NYA-$date.zip
JAM=$(date +%Z);
JAMNYA=$( echo $JAM | sed 's/+//g' ); 

if [[ $JAMNYA == "08" ]]; then
    JAMNYA="MY";
fi

msgl="===================================<br> VPS Data Backup Information<br>===================================<br>IP : ${IP_NYA}<br>ID Backup : ${F_ID}<br>Date : ${tanggal} ( $JAMNYA )<br>===================================<br>(C) Copyright 2022-2023 By tridebleng"
subject_nya="Informasi Backup | ${IP_NYA}";
email_nya="$email_mu";
html_parse='true';
Result=$( wget -qO- 'https://api.tridebleng.com/email/send_mail.php?security_id=1c576a16-eb7f-46fb-91b6-ce0e2d4a98ee&subject='"$subject_nya"'&email='"$email_nya"'&html='"$html_parse"'&message='"$msgl"'' );

if [[ $( echo $Result | jq -r '.respon_code' ) == "107" ]]; then
    clear;
    echo -e "${OKEY} Backup ID Successfull sent to ${email_nya}";
    exit 1;
else
    clear;
    echo -e "${ERROR} Have Something error";
    exit 1;
fi
