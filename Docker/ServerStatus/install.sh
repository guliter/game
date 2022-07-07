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

name=ServerStatus


ip=`curl http://whatismyip.akamai.com`

#yum -y install unzip zip
mkdir -p /root/data/docker_data/$name
mkdir -p /root/data/docker_data/$name/json
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/docker-compose.yml -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/Dockerfile -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/_sss.py -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/bot.py -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/config.json -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/sss.sh -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/json/stats.json -P /root/data/docker_data/$name/json

#chmod 777 /root/data/docker_data/$name
#echo -e "\033[36m cd /root/data/docker_data/lsky-pro \033[0m"
#echo -e "\033[36m docker-compose up -d \033[0m"
#rm $0

cd /root/data/docker_data/$name
bash sss.sh YOUR_TG_CHAT_ID YOUR_TG_BOT_TOKEN
