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

name=Plik

ip=`curl http://whatismyip.akamai.com`

#yum -y install unzip zip
mkdir -p /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/Plik/plikd.cfg -P /root/data/docker_data/$name
redbg "【Plik】启动中......"
docker run --name pilk -d -p 7546:8080 -v /root/data/docker_data/$name/plikd.cfg:/home/plik/server/plikd.cfg -v /root/data/docker_data/$name/files:/home/plik/server/files rootgg/plik
#wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/docker-compose.yml -P /root/data/docker_data/$name

#chmod 777 /root/data/docker_data/$name
#echo -e "\033[36m cd /root/data/docker_data/lsky-pro \033[0m"
#echo -e "\033[36m docker-compose up -d \033[0m"
#rm $0

#cd /root/data/docker_data/$name
#docker-compose up -d
echo
redbg "【Plik】-默认面板:http://${ip}:7546"
echo

