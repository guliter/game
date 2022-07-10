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

name=Malio

ip=`curl http://whatismyip.akamai.com`

#yum -y install unzip zip
mkdir -p /root/data/docker_data/$name

wget https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/000-default.conf -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/apache2.conf -P /root/data/docker_data/$name
#wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/docker-compose.yml -P /root/data/docker_data/$name

yum -y install unzip zip
wget https://github.com/guliter/game/releases/download/Malio/Malio.zip -P /root/data/docker_data/$name/$name
chmod -R 777 /root/data/docker_data
unzip /root/data/docker_data/$name/$name/$name.zip -d /root/data/docker_data/$name/$name


#> /root/data/docker_data/$name/$name/config/.config.php
#cat >> /root/data/docker_data/$name/$name/config/.config.php<<EOF

#EOF

#rm -f /root/data/docker_data/$name/$name/config/.config.php
#wget https://raw.githubusercontent.com/guliter/game/main/Docker/Malio/config.php -P /root/data/docker_data/$name/$name/config


chmod -R 777 /root/data/docker_data
#sed -i '3c $dbconfig=array(' /root/data/docker_data/xyfaka/xyfaka/config.php
#mkdir -p /root/data/docker_data/xyfaka/xyfaka/install/install.lock
sed -i '12c DocumentRoot /var/www/html/public' /root/data/docker_data/$name/000-default.conf


#chmod 777 /root/data/docker_data/xyfaka/xyfaka/install
#chmod -R 777 /root/data/docker_data/xyfaka/xyfaka/install
#echo -e "\033[36m cd /root/data/docker_data/lsky-pro \033[0m"
#echo -e "\033[36m docker-compose up -d \033[0m"
#rm $0

cd /root/data/docker_data/$name
echo
redbg "【Malio】启动中......"
echo
docker run -d \
  --restart always \
  --name $name \
  --link mysql \
  -p 6060:80 \
  -v /root/data/docker_data/$name/$name:/var/www/html \
  -v /root/data/docker_data/$name/000-default.conf:/etc/apache2/sites-enabled/000-default.conf \
  -v /root/data/docker_data/$name/apache2.conf:/etc/apache2/apache2.conf \
  ddsderek/foundations:Debian-apache2-php7.3
echo
redbg "【Malio】-默认面板:http://${ip}:6060"
echo
redbg "【数据库面板】-默认面板:http://${ip}:8181 【root root】"
echo
