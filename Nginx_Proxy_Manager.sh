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

#工具安装
install_pack() {
    pack_name="基础工具"
    echo "===> Start to install curl"    
    if [ -x "$(command -v yum)" ]; then
        command -v curl > /dev/null || yum install -y curl
    elif [ -x "$(command -v apt)" ]; then
        command -v curl > /dev/null || apt install -y curl
    else
        echo "Package manager is not support this OS. Only support to use yum/apt."
        exit -1
    fi    
}



ip=`curl http://whatismyip.akamai.com`

#systemctl restart docker
cd /root


redbg "【Nginx Proxy Manager】启动中......"
docker run -d \
  --restart always \
  --name npm \
  --link mysql \
  -e PMA_HOST="mysql" \
  -e DB_MYSQL_PORT="6867" \
  -e DB_MYSQL_USER="root" \
  -e DB_MYSQL_PASSWORD="root" \
  -e DB_MYSQL_NAME="npm" \
  -p 80:80 \
  -p 443:443 \
  -p 81:81 \
  -v /root/data/docker_data/NPM:/data \
  -v /root/data/docker_data/NPM/letsencrypt:/etc/letsencrypt \
  yan33158164/foundations:nginx-proxy-manager
echo
redbg "【Nginx Proxy Manager】-默认面板:http://${ip}:81 【admin@example.com changeme】"
echo
