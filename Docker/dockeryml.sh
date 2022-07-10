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


install_mysql(){
docker run -itd \
  --restart always \
  --name mysql \
  -p 6878:3306 \
  -v /root/data/docker_data/db:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e HYSQL_DATABASE=ture \
  mysql:5.7
clear
echo
redbg "mysql-默认面板:http://${ip}:6878"
echo
}

install_phpmyadmin(){
docker run -d \
  --restart always \
  --name phpmyadmin \
  --link mysql \
  -e PMA_HOST="mysql" \
  -p 8181:80 \
  phpmyadmin/phpmyadmin
clear
echo
redbg "phpmyadmin-默认面板:http://${ip}:8181"
echo
}

install_apache2_php73(){   
stty erase '^H' && read -p "网站名称" name
stty erase '^H' && read -p "网站端口" port     
mkdir -p /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/000-default.conf -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/apache2.conf -P /root/data/docker_data/$name
chmod -R 777 /root/data/docker_data
sed -i '12c DocumentRoot /var/www/html/public' /root/data/docker_data/$name/000-default.conf
cd /root/data/docker_data/$name
echo
redbg "【$name】启动中......"
echo
docker run -d \
  --restart always \
  --name $name \
  --link mysql \
  -p $port:80 \
  -v /root/data/docker_data/$name/$name:/var/www/html \
  -v /root/data/docker_data/$name/000-default.conf:/etc/apache2/sites-enabled/000-default.conf \
  -v /root/data/docker_data/$name/apache2.conf:/etc/apache2/apache2.conf \
  ddsderek/foundations:Debian-apache2-php7.3
echo
redbg "【$name-apache2-php73环境】-默认面板:http://${ip}:$port"
echo
redbg "上传网站至: /root/data/docker_data/$name/$name"
echo
redbg "【数据库面板】-默认面板:http://${ip}:8181"
echo
}

install_apache2_php71(){   
stty erase '^H' && read -p "网站名称" name
stty erase '^H' && read -p "网站端口" port     
mkdir -p /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/000-default.conf -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/apache2.conf -P /root/data/docker_data/$name
chmod -R 777 /root/data/docker_data
sed -i '12c DocumentRoot /var/www/html/public' /root/data/docker_data/$name/000-default.conf
cd /root/data/docker_data/$name
echo
redbg "【$name】启动中......"
echo
docker run -d \
  --restart always \
  --name $name \
  --link mysql \
  -p $port:80 \
  -v /root/data/docker_data/$name/$name:/var/www/html \
  -v /root/data/docker_data/$name/000-default.conf:/etc/apache2/sites-enabled/000-default.conf \
  -v /root/data/docker_data/$name/apache2.conf:/etc/apache2/apache2.conf \
  ddsderek/foundations:Debian-apache2-php7.1
echo
redbg "【$name-apache2-php71环境】-默认面板:http://${ip}:$port"
echo
redbg "上传网站至: /root/data/docker_data/$name/$name"
echo
redbg "【数据库面板】-默认面板:http://${ip}:8181"
echo
}


#开始菜单
start_menu(){
    echo
    yellow "Docker版绝对优势：部署多个程序互不干扰，独立运行；部署速度快，维护方便"
    echo
    green "———————————————————————————————————---->>基础功能<<----—————————————————————————————————"
    green "1.【mysql】		3.Debian-apache2-php7.3		5.Ubuntu20.04-nginx1.16.1-php7.4.20"		
    green "2.【phpmyadmin】	4.Debian-apache2-php7.1		6.Ubuntu20.04-nginx1.20.2-php8.0.13"		
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    install_mysql
	;; 
	2)
    install_phpmyadmin
        ;; 
	3)
    install_apache2_php73
	;;
	4)
    install_apache2_php71
	;; 
	0)
	exit 1
	;;
	*)
	clear
	echo "请输入正确数字"
	echo
	sleep 3s
	start_menu
	;;
    esac
}

start_menu
