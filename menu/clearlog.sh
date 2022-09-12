echo > /etc/tridebleng/xray-mini-nontls/access.log
echo > /etc/tridebleng/xray-mini-nontls/error.log
echo > /etc/tridebleng/xray-mini-tls/access.log
echo > /etc/tridebleng/xray-mini-tls/error.log
echo > /etc/tridebleng/xray-mini-socks/access.log
echo > /etc/tridebleng/xray-mini-socks/error.log
echo > /etc/tridebleng/xray-mini-shadowsocks/access.log
echo > /etc/tridebleng/xray-mini-shadowsocks/error.log
echo > /var/log/syslog
echo "$(date) | Successfull Clear Logs" > /etc/tridebleng/clearlog.log