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

name=zfaka

ip=`curl http://whatismyip.akamai.com`

#yum -y install unzip zip
mkdir -p /root/data/docker_data/$name

wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/docker-compose.yml -P /root/data/docker_data/$name

yum -y install unzip zip
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/$name.zip -P /root/data/docker_data/$name
unzip /root/data/docker_data/$name/$name.zip -d /root/data/docker_data/$name/$name


> /root/data/docker_data/$name/$name/conf/application.ini
cat >> /root/data/docker_data/$name/$name/conf/application.ini<<EOF
[common]
application.directory = APP_PATH"/application/"
application.dispatcher.catchException = 1
application.cache_config = 1
application.dispatcher.defaultController = "Index"
application.dispatcher.defaultAction = "index"
application.view.ext = "html"
application.modules = "Index,Member,Product,407413685,Crontab,Install"

[product : common]
TYPE = "mysql"
READ_HOST = "${ip}"
READ_PORT = 6878
READ_USER = "root"
READ_PSWD = root
WRITE_HOST = "${ip}"
WRITE_PORT = 6878
WRITE_USER = "root"
WRITE_PSWD = root
Default = "zfaka"
pconnect = 0
EOF

#sed -i '3c $dbconfig=array(' /root/data/docker_data/xyfaka/xyfaka/config.php

#mkdir -p /root/data/docker_data/xyfaka/xyfaka/install/install.lock

chmod -R 777 /root/data/docker_data
#chmod 777 /root/data/docker_data/xyfaka/xyfaka/install
#chmod -R 777 /root/data/docker_data/xyfaka/xyfaka/install
#echo -e "\033[36m cd /root/data/docker_data/lsky-pro \033[0m"
#echo -e "\033[36m docker-compose up -d \033[0m"
#rm $0

cd /root/data/docker_data/$name
redbg "【zfaka】启动中......"
docker-compose up -d
echo
redbg "【zfaka】-默认面板:http://${ip}:5000"
echo
redbg "【数据库面板】-默认面板:http://${ip}:8181 【root root】"
echo
