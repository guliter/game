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
mkdir -p /root/data/docker_data/lsky-pro
wget https://raw.githubusercontent.com/guliter/game/main/Docker/lsky-pro/docker-compose.yml -P /root/data/docker_data/lsky-pro

#chmod 777 /root/data/docker_data/lsky-pro
#echo -e "\033[36m cd /root/data/docker_data/lsky-pro \033[0m"
#echo -e "\033[36m docker-compose up -d \033[0m"
#rm $0

cd /root/data/docker_data/lsky-pro
redbg "【Lsky Pro-图床】启动中......"
docker-compose up -d
echo
redbg "【Lsky Pro-图床】-默认面板:http://${ip}:7791 数据库位置：lsky-pro-db"
echo

