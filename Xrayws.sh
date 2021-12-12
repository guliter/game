


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


xrayVersionManageMenu() {
	echoContent skyBlue "\n进度  $1/${totalProgress} : Xray版本管理"
	if [[ ! -d "/etc/v2ray-agent/xray/" ]]; then
		echoContent red " ---> 没有检测到安装目录，请执行脚本安装内容"
		menu
		exit 0
	fi
	echoContent red "\n=============================================================="
	echoContent yellow "1.升级"
	echoContent yellow "2.回退"
	echoContent yellow "3.关闭Xray-core"
	echoContent yellow "4.打开Xray-core"
	echoContent yellow "5.重启Xray-core"
	echoContent red "=============================================================="
	read -r -p "请选择:" selectXrayType
	if [[ "${selectXrayType}" == "1" ]]; then
		updateXray
	elif [[ "${selectXrayType}" == "2" ]]; then
		echoContent yellow "\n1.由于Xray-core频繁更新，只可以回退最近的两个版本"
		echoContent yellow "2.不保证回退后一定可以正常使用"
		echoContent yellow "3.如果回退的版本不支持当前的config，则会无法连接，谨慎操作"
		echoContent skyBlue "------------------------Version-------------------------------"
		curl -s https://api.github.com/repos/XTLS/Xray-core/releases | jq -r .[].tag_name | head -2 | awk '{print ""NR""":"$0}'
		echoContent skyBlue "--------------------------------------------------------------"
		read -r -p "请输入要回退的版本：" selectXrayVersionType
		version=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | jq -r .[].tag_name | head -2 | awk '{print ""NR""":"$0}' | grep "${selectXrayVersionType}:" | awk -F "[:]" '{print $2}')
		if [[ -n "${version}" ]]; then
			updateXray "${version}"
		else
			echoContent red "\n ---> 输入有误，请重新输入"
			xrayVersionManageMenu 1
		fi
	elif [[ "${selectXrayType}" == "3" ]]; then
		handleXray stop
	elif [[ "${selectXrayType}" == "4" ]]; then
		handleXray start
	elif [[ "${selectXrayType}" == "5" ]]; then
		reloadCore
	fi

}


Vmess(){
    #check root
   bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Xray.sh)

}


Vmess_start(){
    #check root
    systemctl stop xray
}

Vmess_stop(){
    #check root
   systemctl start xray
}


Vmess_status(){
    #check root
    systemctl status xray

}

Vmess_restart(){
    #check root
    systemctl restart xray
}

Vmess_pager(){
    #check root
    journalctl -xe --no-pager -u xray
}




#开始菜单
start_menu(){
    clear
    echo
    white "—————————————Vmess---WebSocket---多IP——————————————"
    red "1.Socks5---【多IP进出口 Vmess】"
    blue "2.Socks5---【服务重启 Vmess】"
    green "3.Socks5---【服务停止 Vmess】"
    yellow "4.Socks5---【查看状态 Vmess】"
    blue "5.Socks5---【查看日志 Vmess】"
    green "6.Socks5---【启动服务 Vmess】"
    yellow "7.xray版本管理"
    red "—————————————【如需退出按【0】退出选项】——————————————"
    
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    Vmess
    ;;
    2)
    Vmess_restart
    ;;
    3)
    Vmess_stop
    ;;
    4)
    Vmess_status
    ;;
    5)
    Vmess_pager
    ;;
    6)
    Vmess_start
    ;;
    7)
    xrayVersionManageMenu
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    echo "请输入正确数字"
    sleep 3s
    start_menu
    ;;
    esac
}

start_menu
Vmess_status
