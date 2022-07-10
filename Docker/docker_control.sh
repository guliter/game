install_ps(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
stty erase '^H' && read -p "输入要重启的容器" restart
clear
echo
redbg "$restart-容器重启完毕"
echo
}

install_2(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
stty erase '^H' && read -p "输入要重启的容器" restart
clear
echo
redbg "$restart-容器重启完毕"
echo
}

install_3(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
stty erase '^H' && read -p "输入要重启的容器" restart
clear
echo
redbg "$restart-容器重启完毕"
echo
}

install_4(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
stty erase '^H' && read -p "输入要重启的容器" restart
clear
echo
redbg "$restart-容器重启完毕"
echo
}

install_5(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
stty erase '^H' && read -p "输入要重启的容器" restart
clear
echo
redbg "$restart-容器重启完毕"
echo
}

install_6(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
stty erase '^H' && read -p "输入要重启的容器" restart
clear
echo
redbg "$restart-容器重启完毕"
echo
}

install_7(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
stty erase '^H' && read -p "输入要重启的容器" restart
clear
echo
redbg "$restart-容器重启完毕"
echo
}

install_8(){
docker ps -a --format "table {{.Names}}" | grep -v  "portainer" | grep -v -n "NAMES"
stty erase '^H' && read -p "输入要重启的容器" restart
clear
echo
redbg "$restart-容器重启完毕"
echo
}






#开始菜单
start_menu(){
    echo
    yellow "Docker版绝对优势：部署多个程序互不干扰，独立运行；部署速度快，维护方便"
    echo
    green "———————————————————————————————————---->>基础功能<<----—————————————————————————————————"
    green "1.重启指定容器	3.重启所有容器		5.查看指定容器日志      7.进入指定容器."		
    green "2.删除指定容器	4.删除所有容器		6.查看指定容器信息      8.停止指定容器"		
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