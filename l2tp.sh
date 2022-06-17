#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

export PATH

export LANG=zh_CN.UTF-8

#############################################################



#检测是否是root用户

if [[ $(id -u) != "0" ]]; then

    printf "\e[42m\e[31mError: You must be root to run this install script.\e[0m\n"

    exit 1

fi



#检测是否是CentOS 7或者RHEL 7

if [[ $(grep "release 7." /etc/redhat-release 2>/dev/null | wc -l) -eq 0 ]]; then

    printf "\e[42m\e[31mError: Your OS is NOT CentOS 7 or RHEL 7.\e[0m\n"

    printf "\e[42m\e[31mThis install script is ONLY for CentOS 7 and RHEL 7.\e[0m\n"

    exit 1

fi

clear







#获取服务器IP

serverip=$(ifconfig -a |grep -w "inet"| grep -v "127.0.0.1" |awk '{print $2;}')

printf "\e[33m$serverip\e[0m is the server IP?"

printf "If \e[33m$serverip\e[0m is \e[33mcorrect\e[0m, press enter directly."

printf "If \e[33m$serverip\e[0m is \e[33mincorrect\e[0m, please input your server IP."

printf "(Default server IP: \e[33m$serverip\e[0m):"

read serveriptmp

if [[ -n "$serveriptmp" ]]; then

    serverip=$serveriptmp

fi



#获取网卡接口名称

ethlist=$(ifconfig | grep ": flags" | cut -d ":" -f1)

eth=$(printf "$ethlist\n" | head -n 1)

if [[ $(printf "$ethlist\n" | wc -l) -gt 2 ]]; then

    echo ======================================

    echo "Network Interface list:"

    printf "\e[33m$ethlist\e[0m\n"

    echo ======================================

    echo "Which network interface you want to listen for ocserv?"

    printf "Default network interface is \e[33m$eth\e[0m, let it blank to use default network interface: "

    read ethtmp

    if [ -n "$ethtmp" ]; then

        eth=$ethtmp

    fi

fi



#设置×××拨号后分配的IP段

iprange="10.0.1"

echo "Please input IP-Range:"

printf "(Default IP-Range: \e[33m$iprange\e[0m): "

read iprangetmp

if [[ -n "$iprangetmp" ]]; then

    iprange=$iprangetmp

fi



#设置dns

clientdns="119.29.29.29"

echo "Please input client DNS-server:"

printf "(Default ××× client DNS-server: \e[33m119.29.29.29\e[0m): "

read client

if [[ -n "$client" ]]; then

    clientdns=$client

fi



clientdns02="8.8.8.8"

echo "Please input client DNS-server:"

printf "(Default ××× client DNS-server: \e[33m8.8.8.8\e[0m): "

read client

if [[ -n "$client" ]]; then

    clientdns02=$client

fi



#设置预共享密钥

mypsk="sadoc.cn"

echo "Please input PSK:"

printf "(Default PSK: \e[33msadoc.cn\e[0m): "

read mypsktmp

if [[ -n "$mypsktmp" ]]; then

    mypsk=$mypsktmp

fi



#设置×××用户名

username="sadoc.cn"

echo "Please input ××× username:"

printf "(Default ××× username: \e[33msadoc.cn\e[0m): "

read usernametmp

if [[ -n "$usernametmp" ]]; then

    username=$usernametmp

fi



#随机密码

randstr() {

    index=0

    str=""

    for i in {a..z}; do arr[index]=$i; index=$(expr ${index} + 1); done

    for i in {A..Z}; do arr[index]=$i; index=$(expr ${index} + 1); done

    for i in {0..9}; do arr[index]=$i; index=$(expr ${index} + 1); done

    for i in {1..10}; do str="$str${arr[$RANDOM%$index]}"; done

    echo $str

}



#设置×××用户密码

password=$(randstr)

printf "Please input \e[33m$username\e[0m's password:\n"

printf "Default password is \e[33m$password\e[0m, let it blank to use default password: "

read passwordtmp

if [[ -n "$passwordtmp" ]]; then

    password=$passwordtmp

fi



clear



#打印配置参数

clear

echo "Server IP:"

echo "$serverip"

echo

echo "Server Local IP:"

echo "$iprange.1"

echo

echo "Client Remote IP Range:"

echo "$iprange.10-$iprange.254"

echo

echo "PSK:"

echo "$mypsk"

echo "ms-dns:  ${clientdns} "

echo "ms-dns:  ${clientdns02} "

echo

echo "Press any key to start..."



get_char() {

    SAVEDSTTY=`stty -g`

    stty -echo

    stty cbreak

    dd if=/dev/tty bs=1 count=1 2> /dev/null

    stty -raw

    stty echo

    stty $SAVEDSTTY

}

char=$(get_char)

clear

mknod /dev/random c 1 9



#更新组件

yum update -y



#安装epel源

yum install epel-release -y



#安装依赖的组件

yum install -y openswan ppp pptpd xl2tpd wget



#创建ipsec.conf配置文件

\cp /etc/ipsec.conf  /etc/ipsec.conf.bak

cat >/etc/ipsec.d/l2tp.conf<<EOF

conn L2TP-PSK-NAT

    rightsubnet=vhost:%priv

    also=L2TP-PSK-noNAT



conn L2TP-PSK-noNAT

    authby=secret

    pfs=no

    auto=add

    keyingtries=3

    rekey=no

    ikelifetime=8h

    keylife=1h

    type=transport

    left=$serverip

    leftid=$serverip

    leftprotoport=17/1701

    right=%any

    rightprotoport=17/%any

    dpddelay=40

    dpdtimeout=130

    dpdaction=clear

    leftnexthop=%defaultroute

    rightnexthop=%defaultroute

    ike=3des-sha1,aes-sha1,aes256-sha1,aes256-sha2_256 

    phase2alg=3des-sha1,aes-sha1,aes256-sha1,aes256-sha2_256

    sha2-truncbug=yes

EOF



#设置预共享密钥配置文件

\cp /etc/ipsec.secrets /etc/ipsec.secrets.bak

cat >/etc/ipsec.d/l2tp.secrets<<EOF

#include /etc/ipsec.d/*.secrets

$serverip %any: PSK "$mypsk"

EOF



#创建pptpd.conf配置文件

\cp /etc/pptpd.conf /etc/pptpd.conf.bak

cat >/etc/pptpd.conf<<EOF

#ppp /usr/sbin/pppd

option /etc/ppp/options.pptpd

#debug

# stimeout 10

#noipparam

logwtmp

#vrf test

#bcrelay eth1

#delegate

#connections 100

localip $iprange.2

remoteip $iprange.200-254

EOF



#创建xl2tpd.conf配置文件

\cp /etc/xl2tpd/xl2tpd.conf  /etc/xl2tpd/xl2tpd.conf.bak

[ -d /etc/xl2tpd ] || mkdir -p /etc/xl2tpd

cat >/etc/xl2tpd/xl2tpd.conf<<EOF

[global]

listen-addr = $serverip

auth file = /etc/ppp/chap-secrets

port = 1701

[lns default]

ip range = $iprange.10-$iprange.199

local ip = $iprange.1

refuse chap = yes

refuse pap = yes

require authentication = yes

name = L2TP×××

ppp debug = yes

pppoptfile = /etc/ppp/options.xl2tpd

length bit = yes

EOF



#创建options.pptpd配置文件

[ -d  /etc/ppp ] || mkdir -p /etc/ppp

\cp /etc/ppp/options.pptpd /etc/ppp/options.pptpd.bak

cat >/etc/ppp/options.pptpd<<EOF

name pptpd



refuse-pap

refuse-chap

refuse-mschap



require-mschap-v2



require-mppe-128



ms-dns ${clientdns}

ms-dns ${clientdns02}



proxyarp



lock

nobsdcomp 

novj

novjccomp

nologfd

EOF



#创建options.xl2tpd配置文件

\cp /etc/ppp/options.xl2tpd /etc/ppp/options.xl2tpd.bak

cat >/etc/ppp/options.xl2tpd<<EOF

ipcp-accept-local

ipcp-accept-remote

require-mschap-v2

ms-dns ${clientdns}

ms-dns ${clientdns02}

asyncmap 0

auth

#crtscts

#lock

hide-password

#modem

debug

name l2tpd

proxyarp

lcp-echo-interval 30

lcp-echo-failure 4

mtu 1400

noccp

connect-delay 5000

EOF



#创建chap-secrets配置文件，即用户列表及密码

\cp /etc/ppp/chap-secrets  /etc/ppp/chap-secrets.bak

cat >/etc/ppp/chap-secrets<<EOF

# Secrets for authentication using CHAP

# client     server     secret               IP addresses

#$username          pptpd     $password               *

$username          l2tpd     $password               *

EOF



#修改系统配置，允许IP转发

sysctl -w net.ipv4.ip_forward=1

sysctl -w net.ipv4.conf.all.rp_filter=0

sysctl -w net.ipv4.conf.default.rp_filter=0

sysctl -w net.ipv4.conf.$eth.rp_filter=0

sysctl -w net.ipv4.conf.all.send_redirects=0

sysctl -w net.ipv4.conf.default.send_redirects=0

sysctl -w net.ipv4.conf.all.accept_redirects=0

sysctl -w net.ipv4.conf.default.accept_redirects=0



cat >>/etc/sysctl.conf<<EOF



net.ipv4.ip_forward = 1

net.ipv4.conf.all.rp_filter = 0

net.ipv4.conf.default.rp_filter = 0

net.ipv4.conf.$eth.rp_filter = 0

net.ipv4.conf.all.send_redirects = 0

net.ipv4.conf.default.send_redirects = 0

net.ipv4.conf.all.accept_redirects = 0

net.ipv4.conf.default.accept_redirects = 0

EOF



#允许防火墙端口

cat >>/usr/lib/firewalld/services/pptpd.xml<<EOF

<?xml version="1.0" encoding="utf-8"?>

<service>

  <short>pptpd</short>

  <description>PPTP and Fuck the GFW</description>

  <port protocol="tcp" port="1723"/>

</service>

EOF



cat >>/usr/lib/firewalld/services/l2tpd.xml<<EOF

<?xml version="1.0" encoding="utf-8"?>

<service>

  <short>l2tpd</short>

  <description>L2TP IPSec</description>

  <port protocol="udp" port="500"/>

  <port protocol="udp" port="4500"/>

  <port protocol="udp" port="1701"/>

</service>

EOF



firewall-cmd --reload

firewall-cmd --permanent --add-service=pptpd

firewall-cmd --permanent --add-service=l2tpd

firewall-cmd --permanent --add-service=ipsec

firewall-cmd --permanent --add-masquerade

firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -p tcp -i ppp+ -j TCPMSS --syn --set-mss 1356

firewall-cmd --reload

#iptables --table nat --append POSTROUTING --jump MASQUERADE

#iptables -t nat -A POSTROUTING -s $iprange.0/24 -o $eth -j MASQUERADE

#iptables -t nat -A POSTROUTING -s $iprange.0/24 -j SNAT --to-source $serverip

#iptables -I FORWARD -p tcp –syn -i ppp+ -j TCPMSS –set-mss 1356

#service iptables save



#允许开机启动

systemctl enable pptpd ipsec xl2tpd

systemctl restart pptpd ipsec xl2tpd

clear



#测试ipsec

ipsec verify



printf "

#############################################################

如果测试出现[FAILED],请再次ipsec verify测试

若是测试成功,请用以下账号密码连接

若是连接出错,请查看message日志.



ServerIP: $serverip

username: $username

password: $password

PSK: $mypsk

"
