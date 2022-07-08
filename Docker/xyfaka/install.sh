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

name=xyfaka

ip=`curl http://whatismyip.akamai.com`

#yum -y install unzip zip
mkdir -p /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/000-default.conf -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/apache2.conf -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/docker-compose.yml -P /root/data/docker_data/$name



yum -y install unzip zip
wget https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/xyfaka.zip -P /root/data/docker_data/$name
unzip /root/data/docker_data/xyfaka/xyfaka.zip -d /root/data/docker_data/xyfaka


chmod -R 777 /root/data/docker_data/$name
#chmod 777 /root/data/docker_data/xyfaka/xyfaka/install
#chmod -R 777 /root/data/docker_data/xyfaka/xyfaka/install
#echo -e "\033[36m cd /root/data/docker_data/lsky-pro \033[0m"
#echo -e "\033[36m docker-compose up -d \033[0m"
#rm $0

cd /root/data/docker_data/$name
redbg "【xyfaka】启动中......"
docker-compose up -d
echo
redbg "【xyfaka】-默认面板:http://${ip}:5000"
echo

