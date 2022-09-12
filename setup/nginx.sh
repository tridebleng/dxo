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

# // Installing Nginx For Handle GRPC
cd /root/;
apt install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev -y;
wget -q -O /root/nginx.tar.gz http://nginx.org/download/nginx-1.19.9.tar.gz;
tar -zxvf nginx.tar.gz; cd nginx-1.19.9/;
./configure --prefix=/etc/tridebleng/webserver/ \
            --sbin-path=/usr/sbin/nginx \
            --conf-path=/etc/nginx/nginx.conf \
            --http-log-path=/var/log/nginx/access.log \
            --error-log-path=/var/log/nginx/error.log \
            --with-pcre  --lock-path=/var/lock/nginx.lock \
            --pid-path=/var/run/nginx.pid \
            --with-http_ssl_module \
            --with-http_image_filter_module=dynamic \
            --modules-path=/etc/nginx/modules \
            --with-http_v2_module \
            --with-stream=dynamic \
            --with-http_addition_module \
            --with-http_mp4_module \
            --with-http_realip_module;
make && make install;
cd && rm -rf /root/nginx-1.19.9 && rm -f /root/nginx.tar.gz;
wget -q -O /lib/systemd/system/nginx.service "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Service/nginx_service";
systemctl stop nginx;
rm -rf /etc/nginx/sites-*;
mkdir -p /etc/nginx/conf.d/;
wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/nginx_conf";
wget -q -O /etc/nginx/conf.d/tridebleng.conf "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/tridebleng_conf";
mkdir -p /etc/tridebleng/webserver/;
wget -q -O /etc/tridebleng/webserver/index.html "https://raw.githubusercontent.com/tridebleng/dxo/ipuk/Resource/Config/index.file";
sudo chown -R www-data:www-data /etc/tridebleng/webserver/;
sudo chmod 755 /etc/tridebleng/webserver/;
systemctl enable nginx;
systemctl start nginx;

# // Remove not used file
rm -f /root/nginx.sh;

# // Successfull
clear;
echo -e "${OKEY} Successfull Installed Nginx";
