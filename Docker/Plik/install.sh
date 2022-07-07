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

mkdir -p /root/data/docker_data/$name

wget https://raw.githubusercontent.com/guliter/game/main/Docker/Plik/plikd.cfg -P /root/data/docker_data/$name
redbg "【Plik】启动中......"
echo
docker run --name pilk -d -p 7546:8080 -v /root/data/docker_data/$name/plikd.cfg:/home/plik/server/plikd.cfg -v /root/data/docker_data/$name/files:/home/plik/server/files rootgg/plik
echo
redbg "【Plik】-默认面板:http://${ip}:7546"
echo

