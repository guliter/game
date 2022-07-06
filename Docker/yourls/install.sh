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

#yum -y install unzip zip
rm -f /root/data/docker_data/yourls/docker-compose.yml
mkdir -p /root/data/docker_data/yourls
wget https://raw.githubusercontent.com/guliter/game/main/Docker/yourls/docker-compose.yml -P /root/data/docker_data/yourls

chmod 777 /root/data/docker_data/yourls/docker-compose.yml
redbg "注意docker-compose.yml域名的配置！"
echo -e "\033[36m cd /root/data/docker_data/yourls \033[0m"
echo -e "\033[36m docker-compose up -d \033[0m"
rm $0

