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

name=duplicati

ip=`curl http://whatismyip.akamai.com`



if [ ! -f "/root/data/docker_data/$name/docker-compose.yml" ];then

redbg "已经安装过了！"

else
mkdir -p /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/docker-compose.yml -P /root/data/docker_data/$name
fi

#yum -y install unzip zip


#chmod 777 /root/data/docker_data/lsky-pro
#echo -e "\033[36m cd /root/data/docker_data/lsky-pro \033[0m"
#echo -e "\033[36m docker-compose up -d \033[0m"
#rm $0

cd /root/data/docker_data/$name
redbg "【duplicati-数据备份】启动中......"
docker-compose up -d
echo
redbg "【duplicati-数据备份】-默认面板:http://${ip}:7632"
echo

