


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




Dante_socks5(){
    #check root
    wget --no-check-certificate https://raw.githubusercontent.com/guliter/danted/dev/install.sh -O install.sh&&bash install.sh  --port="51888" --user="123" --passwd="123"

}

uninstall_socks5(){
    bash install.sh --uninstall
}

socks5_add(){
    /etc/init.d/sockd add 123 123
}



socks5_status(){
    #check root
    /etc/init.d/sockd  status

}

socks5_restart(){
    #check root
    /etc/init.d/sockd  restart

}



#开始菜单
start_menu(){
    clear
    echo
    white "—————————————多IP服务器——————————————"
    red "1.Socks5---【多IP进出口 Dante】"
    blue "2.Socks5---【服务重启 Dante】"
    red "3.Socks5---【查看状态 Dante】"
    white "4.3.Socks5---【添加用户 Dante】"
    red "5.Socks5---【卸载 Dante】"
    echo
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    Dante_socks5
    ;;
    2)
    socks5_restart
    ;;
    3)
    socks5_status
    ;;
    4)
    socks5_add
    ;;
    5)
    uninstall_socks5
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
socks5_status
