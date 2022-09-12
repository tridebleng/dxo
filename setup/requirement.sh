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
# // Export OS Information
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );



# // Installing Update
apt update -y;
apt upgrade -y;
apt dist-upgrade -y;
apt remove --purge ufw firewalld exim4 -y;
apt autoremove -y;
apt clean -y;

# // Install Requirement Tools
apt install python -y;
apt install make-guile -y;
apt install make -y;
apt install cmake -y;
apt install coreutils -y;
apt install rsyslog -y;
apt install net-tools -y;
apt install zip -y;
apt install unzip -y;
apt install nano -y;
apt install sed -y;
apt install gnupg -y;
apt install gnupg1 -y;
apt install bc -y;
apt install jq -y;

# // remove cache nd resume installing
apt autoremove -y; 
apt clean -y
apt install apt-transport-https -y;
apt install build-essential -y;
apt install dirmngr -y;
apt install libxml-parser-perl -y;
apt install git -y;
apt install lsof -y;
apt install libsqlite3-dev -y;
apt install libz-dev -y;
apt install gcc -y;
apt install g++ -y;
apt install libreadline-dev -y;
apt install zlib1g-dev -y;
apt install libssl-dev -y;

# // Installing neofetch
wget -q -O /usr/local/sbin/neofetch "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Core/neofetch"; chmod +x /usr/local/sbin/neofetch;

# // Setting Time
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime;

# // Getting Ip Route
export NET=$(ip route show default | awk '{print $5}');
export MYIP2="s/xxxxxxxxx/$IP_NYA/g";

# // Installing Vnstat 2.9
apt install vnstat -y;
/etc/init.d/vnstat stop;
wget -q -O vnstat.zip "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Core/vnstat.zip";
unzip -o vnstat.zip > /dev/null 2>&1;
cd vnstat;
chmod +x configure;
./configure --prefix=/usr --sysconfdir=/etc --disable-dependency-tracking && make && make install;
cd;
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf;
chown vnstat:vnstat /var/lib/vnstat -R;
systemctl disable vnstat;
systemctl enable vnstat;
systemctl restart vnstat;
/etc/init.d/vnstat restart;
rm -r -f vnstat;
rm -f vnstat.zip;

# // Installing UDP Mini
wget -q -O /usr/local/tridebleng/udp-mini "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Core/udp-mini";
chmod +x /usr/local/tridebleng/udp-mini;
wget -q -O /etc/systemd/system/udp-mini-1.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/udp-mini-1.service";
wget -q -O /etc/systemd/system/udp-mini-2.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/udp-mini-2.service";
wget -q -O /etc/systemd/system/udp-mini-3.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/udp-mini-3.service";
systemctl disable udp-mini-1 > /dev/null 2>&1;
systemctl stop udp-mini-1 > /dev/null 2>&1;
systemctl enable udp-mini-1;
systemctl start udp-mini-1;
systemctl disable udp-mini-2 > /dev/null 2>&1;
systemctl stop udp-mini-2 > /dev/null 2>&1;
systemctl enable udp-mini-2;
systemctl start udp-mini-2;
systemctl disable udp-mini-3 > /dev/null 2>&1;
systemctl stop udp-mini-3 > /dev/null 2>&1;
systemctl enable udp-mini-3;
systemctl start udp-mini-3;

# // Block Torrent using iptables
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP;
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP;
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP;
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP;
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP;
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP;
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP;
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP;
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP;
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP;
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save;
netfilter-persistent reload;

# // Installing Squid Proxy
apt install squid -y;
wget -q -O /etc/squid/squid.conf "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/squid_conf";
sed -i $MYIP2 /etc/squid/squid.conf;
mkdir -p /etc/tridebleng/squid;
/etc/init.d/squid restart;

# // Installing OHP Proxy
wget -q -O /usr/local/tridebleng/ohp-mini "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Core/ohp-mini";
chmod +x /usr/local/tridebleng/ohp-mini
wget -q -O /etc/systemd/system/ohp-mini-1.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/ohp-mini-1_service"
wget -q -O /etc/systemd/system/ohp-mini-2.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/ohp-mini-2_service"
wget -q -O /etc/systemd/system/ohp-mini-3.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/ohp-mini-3_service"
wget -q -O /etc/systemd/system/ohp-mini-4.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/ohp-mini-4_service"
systemctl disable ohp-mini-1 > /dev/null 2>&1
systemctl stop ohp-mini-1 > /dev/null 2>&1
systemctl enable ohp-mini-1
systemctl start ohp-mini-1
systemctl disable ohp-mini-2 > /dev/null 2>&1
systemctl stop ohp-mini-2 > /dev/null 2>&1
systemctl enable ohp-mini-2
systemctl start ohp-mini-2
systemctl disable ohp-mini-3 > /dev/null 2>&1
systemctl stop ohp-mini-3 > /dev/null 2>&1
systemctl enable ohp-mini-3
systemctl start ohp-mini-3
systemctl disable ohp-mini-4 > /dev/null 2>&1
systemctl stop ohp-mini-4 > /dev/null 2>&1
systemctl enable ohp-mini-4
systemctl start ohp-mini-4

# // Installing Autokill For Vmess Vless Trojan Shadowsocks and ssh
wget -q -O /etc/systemd/system/ssh-kill.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/ssh-kill_service";
wget -q -O /etc/systemd/system/vmess-kill.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/vmess-kill_service";
wget -q -O /etc/systemd/system/vless-kill.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/vless-kill_service";
wget -q -O /etc/systemd/system/trojan-kill.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/trojan-kill_service";
wget -q -O /etc/systemd/system/ss-kill.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/ss-kill_service";
wget -q -O /usr/local/tridebleng/vmess-auto-kill "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Stable/1.0/menu/pro/autokill/vmess-kill.sh"; chmod +x /usr/local/tridebleng/vmess-auto-kill;
wget -q -O /usr/local/tridebleng/ssh-auto-kill "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Stable/1.0/menu/pro/autokill/ssh-kill.sh"; chmod +x /usr/local/tridebleng/ssh-auto-kill;
wget -q -O /usr/local/tridebleng/vless-auto-kill "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Stable/1.0/menu/pro/autokill/vless-kill.sh"; chmod +x /usr/local/tridebleng/vless-auto-kill;
wget -q -O /usr/local/tridebleng/trojan-auto-kill "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Stable/1.0/menu/pro/autokill/trojan-kill.sh"; chmod +x /usr/local/tridebleng/trojan-auto-kill;
wget -q -O /usr/local/tridebleng/ss-auto-kill "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Stable/1.0/menu/pro/autokill/ss-kill.sh"; chmod +x /usr/local/tridebleng/ss-auto-kill;
wget -q -O /etc/tridebleng/autokill.conf "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Stable/1.0/menu/pro/autokill/autokill_conf"; chmod +x /etc/tridebleng/autokill.conf;
systemctl enable vmess-kill;
systemctl enable ssh-kill;
systemctl enable vless-kill;
systemctl enable trojan-kill;
systemctl enable ss-kill;
systemctl start vmess-kill;
systemctl start ssh-kill;
systemctl start vless-kill;
systemctl start trojan-kill;
systemctl start ss-kill;
systemctl restart vmess-kill;
systemctl restart ssh-kill;
systemctl restart vless-kill;
systemctl restart trojan-kill;
systemctl restart ss-kill;

# // Installing Rclone
curl -s https://rclone.org/install.sh | bash > /dev/null 2>&1
printf "q\n" | rclone config > /dev/null 2>&1

# // Input auto expired for all user
echo "0 0 * * * root /usr/local/sbin/autoexp" > /etc/cron.d/autoexp
echo "0 * * * * root /usr/local/sbin/clearlog" > /etc/cron.d/clearlog
systemctl restart cron

# // Installing Fail2ban
apt install fail2ban -y;
/etc/init.d/fail2ban restart;

# // Set to default login
echo "autoexp && clear && infonya" >> /etc/profile

# // Installing RC-Local
wget -q -O /etc/systemd/system/rc-local.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/rc-local_service";
wget -q -O /etc/rc.local "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/rc-local_conf";
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local

# // Remove not used file
rm -f /root/requirement.sh;

# // Successfull
clear;
echo -e "${OKEY} Successfull Installed Requirement Tools";