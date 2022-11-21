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


install_ps(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
echo
read -p "输入要重启的容器:" restart
echo
green "$restart重启中......"
docker restart $restart
echo
clear
redbg "$restart-容器已重启"
echo
}

install_2(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
echo
stty erase '^H' && read -p "输入要删除的容器:" rm
echo
green "$rm-容器删除中......"
docker stop $rm && docker rm $rm
clear
redbg "$rm-容器已删除"
echo
}

install_3(){
green "未使用镜像删除中......"
#docker stop $(docker ps -q) & docker rm $(docker ps -aq)
docker image prune -a -f
echo
clear
redbg "执行完成！"
echo
}

install_4(){
#docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
#stty erase '^H' && read -p "输入要重启的容器" restart
green "未使用网络删除中......"
#docker stop $(docker ps -q) && docker rm $(docker ps -aq)
docker network prune -f
echo
clear
redbg "执行完成"
echo
}

install_5(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
echo
stty erase '^H' && read -p "输入要查看的容器:" top
echo
docker top $top
echo
}

install_6(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
echo
stty erase '^H' && read -p "输入要查看的容器:" inspect
echo
docker inspect $inspect
echo
}

install_7(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
echo
stty erase '^H' && read -p "输入要进入的容器:" dd
echo
docker exec -it $dd /bin/bash
}

install_8(){
docker stats --no-stream
echo
}

install_9(){
echo
docker ps --format '{{.Image}}'
echo
stty erase '^H' && read -p "输入要制作标签镜像:" image
echo
stty erase '^H' && read -p "输入自己镜像的标签:" tga
echo
docker tag $image yan33158164/foundations:$tga
echo
start_menu
}

install_10(){
docker images

echo
stty erase '^H' && read -p "输入推送镜像的标签:" tgas
echo
 docker push yan33158164/foundations:$tgas
echo
}

install_11(){
echo
stty erase '^H' && read -p "Mysql-密码:" ps
echo
stty erase '^H' && read -p "创建的数据库:" sqlname
echo
yellow "复制下边参数：
	docker exec -it mysql /bin/bash 
	mysql -uroot -p$ps 
	create database $sqlname character set utf8mb4; 
	exit
	exit"

	
	
}

install_100(){
yellow "	docker inspect -f {{.Config.Hostname}} tomcat001 获取到hostname
	docker inspect -f {{.Config.Env}} tomcat001 获取所有环境变量信息
	docker inspect -f ‘{{index .Config.Env 1}}’ tomcat001 获取1个环境变量信息 
	docker inspect --format '{{.Name}} {{.State.Running}}' nginx1 运行状态
	docker inspect -f {{.NetworkSettings.IPAddress}} tomcat001 获取ip  
	docker image prune -a  清理未使用的镜像
	docker image tag image:v1 image 镜像设置标签,也叫镜像设置版本
	docker ps -a --format 'table {{.Names}}\t{{.Ports}}' | sed 's/0.0.0.0://' | sed 's/ ::://' |awk -F"/tcp," '{print $1}' 显示镜像与端口
	docker tag 镜像id 你的账户名/镜像仓库名:tag名
	systemctl enable docker #设置docker开机自动启动
 	systemctl status docker #查看docker状态
	
	 "
	
green " 推送镜像：
	docker images 显示全部镜像
	docker ps --format '{{.Image}}' 显示运行中的镜像
	ocker login 登录
	docker tag 镜像id 你的账户名/镜像仓库名:tag名 制作镜像
	yan33158164/foundations:Debian-apache2-php7.1 推送镜像到仓库
	"
green "	docker network create web-network 创建网络
	docker run --name redis -d -p 6379:6379 --network web-network redis:6.2.7 创建web-network	网络环境下
	docker run -d --name phpmyadminn --link NPM_mysql  -p 8282:80 -e PMA_PORT:3306 --network root_default phpmyadmin 同一网络环境数据库链接
	--link mysql	链接数据库
	================================================================================================
	创建数据库:
	docker exec -it mysql /bin/bash 
	mysql -uroot -proot 
	create database s222s character set utf8mb4; 
	exit
	exit"	
	
	}









#开始菜单
start_menu(){
clear
green "已经运行的容器:"
echo
docker ps -a --format "table {{.Names}}\t{{.Ports}}" | sed 's/0.0.0.0://' | sed 's/ ::://' |awk -F"/tcp," '{print $1}' | grep -v  "mysql" | grep -v "NAMES" | grep -v -n "NAMES"
	

    echo
    yellow "Docker版绝对优势：部署多个程序互不干扰，独立运行；部署速度快，维护方便 输入【11】创建数据库【99】输出容器端口【100】提供更详细内容"
    echo
    green "推荐教程：https://www.bilibili.com/video/BV1og4y1q7M4/?spm_id_from=autoNext"
    echo
    green "1.重启指定容器	3.删除未使用镜像	5.查看指定容器进程	7.进入指定容器	9.制作镜像标签"			
    green "2.删除指定容器	4.删除未使用网络	6.查看指定容器信息	8.容器内存占用	10.推送镜像到仓库"
    echo
    yellow "mysql-端口:6878| phpmyadmin-端口:8181 | Kodexplorer-端口:5878 | Nginx Proxy Manager-端口:8686 | Portainer-端口:9000 进入数据：mysql -uroot -proot"
    echo
    read -p "请输入数字:" num
    case "$num" in
        1)
    install_ps
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
	11)
    install_11
        ;;
	100)
    install_100
        ;;
	99)
	echo
green "mysql 端口：6878"
	echo
docker ps -a --format "table {{.Names}}\t{{.Ports}}" | sed 's/0.0.0.0://' | sed 's/ ::://' |awk -F"/tcp," '{print $1}' | grep -v  "mysql" | grep -v "NAMES" | grep -v -n "NAMES"
    	echo
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
