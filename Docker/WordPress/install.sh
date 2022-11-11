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

name=WordPress

ip=`curl http://whatismyip.akamai.com`





#stty erase '^H' && read -p "网站名称:" name
#stty erase '^H' && read -p "网站端口:" port     
mkdir -p /root/data/docker_data/$name
#wget https://raw.githubusercontent.com/guliter/game/main/Docker/Ubuntu20.04-nginx1.16.1-php7.4.20/nginx.conf -P /root/data/docker_data/$name
#wget https://raw.githubusercontent.com/guliter/game/main/Docker/Ubuntu20.04-nginx1.16.1-php7.4.20/nginx.conf.default -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/default_server.conf -P /root/data/docker_data/$name


yum -y install unzip zip
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/$name.zip -P /root/data/docker_data/$name
unzip /root/data/docker_data/$name/$name.zip -d /root/data/docker_data/$name/$name



chmod -R 777 /root/data/docker_data
#sed -i '12c DocumentRoot /var/www/html/public' /root/data/docker_data/$name/000-default.conf
cd /root/data/docker_data/$name
echo
redbg "【$name】启动中......"
echo
docker run -d \
  --restart always \
  --name $name \
  --link mysql \
  -p 7263:80 \
  -v /root/data/docker_data/$name/$name:/app/web \
  -v /root/data/docker_data/$name/default_server.conf:/etc/nginx/conf.d/default_server.conf \
  yan33158164/foundations:Ubuntu20.04-nginx1.16.1-php7.4.20
echo
redbg "【$name-nginx1.16-php7.4环境】-WordPress-6.1默认面板:http://${ip}:7263"
echo
green "
创建数据库【mysql】:
docker exec -it mysql /bin/bash 
mysql -uroot -proot 
create database WordPress character set utf8mb4; 
exit
exit"
echo
echo
redbg "【数据库面板】-默认面板:http://${ip}:8181"
echo
