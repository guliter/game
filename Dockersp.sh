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

#工具安装
install_pack() {
    pack_name="基础工具"
    echo "===> Start to install curl"    
    if [ -x "$(command -v yum)" ]; then
        command -v curl > /dev/null || yum install -y curl
    elif [ -x "$(command -v apt)" ]; then
        command -v curl > /dev/null || apt install -y curl
    else
        echo "Package manager is not support this OS. Only support to use yum/apt."
        exit -1
    fi    
}



ip=`curl http://whatismyip.akamai.com`





clear

install_1(){
docker version > /dev/null || curl -fsSL get.docker.com | bash
docker-compose version > /dev/null ||  yum install docker-compose -y
service docker restart
docker volume create portainer_data
docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
clear
echo
redbg "Portainer-默认面板:http://${ip}:9000"
echo
}

install_2(){
systemctl restart docker
clear
greenbg "Docker【容器重启完毕】"
echo
start_menu
}

install_3(){
mkdir -p /root/share
docker run -it -d -p 2571:80 -v /root/share:/var/www clue/h5ai
clear
echo
redbg "【目录分享】h5ai-默认面板:http://${ip}:2571"
echo
}

install_4(){

docker run --name="zdir"  \
    -d -p 2569:80 --restart=always \
    -v /tmp/zdir:/data/wwwroot/default \
    helloz/zdir
#mkdir -p /var/zdir    
#docker run -d -p 2569:80 -v /var/zdir:/var/www/html/var baiyuetribe/zdir
#可视化文件管理
mkdir -p /tmp/zdir  
docker run -d -p 2570:80 --name kodexplorer -v /tmp/zdir:/code baiyuetribe/kodexplorer
clear
echo
redbg "【目录分享】Zdir-默认面板:http://${ip}:2569 【admin baiyueadmin】"
echo
redbg "【文件管理】KODExplorer-默认面板:http://${ip}:2570"
echo
}


install_5(){
#创建临时容器：
docker run -itd --name=tmp baiyuetribe/oneindex
#拷贝容器内文件到宿主机目录：
docker cp tmp:/var/www/html /opt/oneindex
docker rm -f tmp
#正式启动服务：
docker run -d -p 5147:80 -v /opt/oneindex:/var/www/html --restart=always baiyuetribe/oneindex
clear
echo
redbg "【私人网盘】OneDrive-默认面板:http://${ip}:5147"
echo
}


install_6(){
docker run -d -p 9292:80 evns/grav
clear
echo
redbg "【GRAV】博客-默认面板:http://${ip}:9292"
echo
}

install_7(){
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=baiyue -d mysql:5.5   #安装数据库大小只有66MB
docker run -p 9393:80 --name some-wordpress --link some-mysql:mysql -d wordpress  #运行wordpress
clear
echo
redbg "【Wordpress】博客-默认面板:http://${ip}:9393"
echo
}


install_8(){
docker run -itd -p 5422:80 --restart=always onlyoffice/communityserver
clear
echo
redbg "【Onlyoffice】-默认面板:http://${ip}:5422"
echo
}

install_9(){
docker run -d -p 10087:10087 -p 25:25 -p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock denghongcai/forsaken-mail
clear
echo
redbg "【临时邮箱】-默认面板:http://${ip}:3000"
echo
}

install_10(){
bash <(curl -Ls https://ghproxy.com/https://raw.githubusercontent.com/yuanter/shell/main/docker-x-ui.sh)
clear
echo
redbg "【临时邮箱】-默认面板:http://${ip}:54321 【admin admin】"
echo
}
#开始菜单
start_menu(){
    echo
    yellow "Docker版绝对优势：部署多个程序互不干扰，独立运行；部署速度快，维护方便"
    echo
    green "—————————————基础功能——————————————"
    redbg "1.【Portainer】"
    green "2.【重启容器】"
    green "—————————————云盘目录类——————————————"
    green "3.【目录分享】h5ai"
    green "4.【目录分享】Zdir &&【文件管理】KODExplorer"
    green "5【私人网盘】OneDrive"
    green "—————————————博客类程序——————————————"
    green "6.【GRAV】博客"
    green "7.【Wordpress】博客"
    green "8.【Onlyoffice】"    
    green "—————————————其他类型——————————————"
    green "9.【临时邮箱】"
    green "10.【X-ui】"
    green "0.【输出0退出菜单】"
    echo
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    install_1
	;;
    2)
    install_2
	;;      
    3)
    install_3
	;;  
   4)
    install_4
	;;  
    5)
    install_5
	;;  
    6)
    install_6
	;; 
    7)
    install_7
	;;  
    8)
    install_8
	;;  
    9)
    install_9
	;;
	10)
    install_10
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