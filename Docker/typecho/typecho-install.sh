#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


# 设置字体颜色函数
function blue(){
    echo -e "\033[34m\033[01m $1 \033[0m"
}
function green(){
    echo -e "\033[32m\033[01m $1 \033[0m"
}
function greenbg(){
    echo -e "\033[43;42m\033[01m $1 \033[0m"
}
function red(){
    echo -e "\033[31m\033[01m $1 \033[0m"
}
function redbg(){
    echo -e "\033[37;41m\033[01m $1 \033[0m"
}
function yellow(){
    echo -e "\033[33m\033[01m $1 \033[0m"
}
function white(){
    echo -e "\033[37m\033[01m $1 \033[0m"
}

ip=`curl http://whatismyip.akamai.com`


yum -y install unzip zip
mkdir -p /root/data/docker_data/typecho
wget https://raw.githubusercontent.com/DDSRem/typecho-install/main/mysql.env -P /root/data/docker_data/typecho
mkdir -p /root/data/docker_data/typecho/php
wget https://raw.githubusercontent.com/DDSRem/typecho-install/main/Dockerfile -P /root/data/docker_data/typecho/php
mkdir -p /root/data/docker_data/typecho/nginx
wget https://raw.githubusercontent.com/DDSRem/typecho-install/main/default.conf -P /root/data/docker_data/typecho/nginx
mkdir -p /root/data/docker_data/typecho/typecho
wget https://github.com/typecho/typecho/releases/download/v1.2.0/typecho.zip -P /root/data/docker_data/typecho/typecho
unzip /root/data/docker_data/typecho/typecho/typecho.zip -d /root/data/docker_data/typecho/typecho
#rm -rf /root/data/docker_data/typecho/typecho/typecho.zip
wget https://raw.githubusercontent.com/DDSRem/typecho-install/main/docker-compose.yml -P /root/data/docker_data/typecho
chmod 777 /root/data/docker_data/typecho/typecho/usr/uploads
echo -e "\033[36m cd /root/data/docker_data/typecho \033[0m"
echo -e "\033[36m docker-compose up -d \033[0m"
echo -e "\033[36m docker-compose up -d \033[0m"
echo
redbg "【typecho-博客】-默认面板:http://${ip}:8223"
echo
rm $0
