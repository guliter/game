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
green "所有镜像删除中......"
docker rmi -f $(docker images -q)
echo
clear
redbg "所有镜像已删除"
echo
}

install_4(){
#docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
#stty erase '^H' && read -p "输入要重启的容器" restart
green "所有容器删除中......"
docker stop $(docker ps -q) && docker rm $(docker ps -aq)
echo
clear
redbg "所有容器已删除"
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
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
echo
stty erase '^H' && read -p "输入要查看的容器:" nbip
echo
docker stats $nbip 
echo
}


install_100(){
yellow "	docker inspect -f {{.Config.Hostname}} tomcat001 获取到hostname
	docker inspect -f {{.Config.Env}} tomcat001 获取所有环境变量信息
	docker inspect -f ‘{{index .Config.Env 1}}’ tomcat001 获取1个环境变量信息 
	docker inspect --format '{{.Name}} {{.State.Running}}' nginx1 运行状态
	docker inspect -f {{.NetworkSettings.IPAddress}} tomcat001 获取ip  
	docker top nginx1 查看进程
	docker stats nginx1 内存占用
	docker image prune -a  清理未使用的镜像
	docker image prune 删除构建失败的镜像
	docker image tag image:v1 image 镜像设置标签,也叫镜像设置版本"
green"  推送镜像：
	docker push llxxyy/nginx-io:v1
	docker pull llxxyy/nginx-io:v1
	docker login"
	
	
	}








#开始菜单
start_menu(){
clear
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
    echo
    yellow "Docker版绝对优势：部署多个程序互不干扰，独立运行；部署速度快，维护方便 输入【100】提供更详细内容"
    echo
    green "1.重启指定容器	3.删除所有镜像	5.查看指定容器进程	7.进入指定容器."		
    green "2.删除指定容器	4.删除所有容器	6.查看指定容器信息	8.容器内存占用"		
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
	100)
    install_100
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