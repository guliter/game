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


name=Calibre-Web
#curl ip.sb
ip=`curl http://whatismyip.akamai.com`
mkdir -p /root/data/docker_data/$name

install(){
#配置文件的下载
#wget https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/000-default.conf -P /root/data/docker_data/$name
##wget https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/apache2.conf -P /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/docker-compose.yml -P /root/data/docker_data/$name

#压缩文件的处理
#yum -y install unzip zip
#wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/$name.zip -P /root/data/docker_data/$name
#unzip /root/data/docker_data/$name/$name.zip -d /root/data/docker_data/$name/$name

#配置文件的写入
#> /root/data/docker_data/$name/$name/conf/application.ini
#cat >> /root/data/docker_data/$name/$name/conf/application.ini<<EOF
#[common]
#这里填写内容
#EOF





#最后文件处理
#sed -i '3c $dbconfig=array(' /root/data/docker_data/xyfaka/xyfaka/config.php
#mkdir -p /root/data/docker_data/xyfaka/xyfaka/install/install.lock
#sed -i '12c DocumentRoot /var/www/html/public' /root/data/docker_data/zfaka/000-default.conf



#删除多余文件！
#cd /root/data/docker_data/$name
#rm -rf name.zip

#配置权限
chmod -R 777 /root/data/docker_data
chown -R www /root/data/docker_data
}

mysql(){
clear
red "第一次创建请创建数据库并导入数据库！"
green "
容器数据库创建:
docker exec -it calibre-web sh #进入容器内部
cd /app/calibre/bin #进入bin文件夹
calibredb restore_database --really-do-it --with-library /books #创建一个数据库
chmod a+w /books/metadata.db #添加写的权限
exit  # 退出容器
web数据库路径填写/books即可正常操作！"
echo
}


if [ ! -f "/root/data/docker_data/$name/docker-compose.yml" ];then

install
mysql

else
clear
redbg "已经安装过了！将以现有配置启动！若有必要请删除对应项目进行重置"
echo
fi

cd /root/data/docker_data/$name
redbg "【Calibre-Web】启动中......"
docker-compose up -d
echo
redbg "【Calibre-Web】-默认面板:http://${ip}:8093 admin admin123 web数据库路径填写/books即可正常操作！"
echo
