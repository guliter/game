#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

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

Install(){
git clone https://github.com/z3apa3a/3proxy
cd 3proxy
ln -s Makefile.Linux Makefile
make
sudo make install
sudo chmod -R 777 /usr/local/3proxy/conf/add3proxyuser.sh
}

add3proxy(){
echo ""
stty erase '^H' && read -p "输入【用户名-密码相同】:" uname
stty erase '^H' && read -p "输入【该用户的流量/MB】:" ll
stty erase '^H' && read -p "输入【该用户的有效期/天】:" td
echo ""
lmb=1048576*${ll}
/usr/local/3proxy/conf/add3proxyuser.sh ${uname} ${uname} ${td} ${lmb}
red "--->3proxy-添加用户：【${uname}】 流量：【${ll}MB】 有效期【${td}天】操作已执行<---"
echo ""
}

dele(){
echo ""
stty erase '^H' && read -p "输入需要删除【用户名】: " deame
sed -i -e '/'${deame}'/d' /usr/local/3proxy/conf/passwd
sed -i -e '/'${deame}'/d' /usr/local/3proxy/conf/bandlimiters
sed -i -e '/'${deame}'/d' /usr/local/3proxy/conf/counters
echo ""
red "--->3proxy-删除用户:【${deame}】操作已执行<---"
echo ""
}

bandlidele(){

echo "输入【指定用户名】: "${llxzz}
echo "输入【指定用户名流量】: "${llxz}


bandlimin 2000000000 1314521
bandlimout 2000000000 1314521
}

outip(){
echo ""
stty erase '^H' && read -p "输入【指定端口】:" pr
stty erase '^H' && read -p "输入【指定IP】:" ips
echo ""
cat >> /usr/local/3proxy/conf/3proxy.cfg<<EOF
socks -p${pr} -e${ips}
EOF
red "--->3proxy-已添加SOCKS5指定出口IP和端口：${ips}:${pr}<---"
echo ""
}



if [[ ! -d "/usr/local/3proxy/conf/add3proxyuser.sh" ]]; then
Install
	fi
	start_menu(){
	echo ""
	red "--->3proxy-socks5服务已经安装！<---"
	echo ""
   	 red "--->1.3proxy-socks5添加用户<---"
   	 blue "--->2.3proxy-socks5删除用户---"
 	 green "--->3.3proxy-socks5限制流量<---"
	 red "--->4.3proxy-socks5启动服务<---"
	 blue "--->5.3proxy-socks5停止服务<---"
	 green "--->6.3proxy-socks5指定端口-IP输出<---"
	 echo ""
	 #red "--->7.3proxy-socks5指定端口-IP输出<---"
	  blue "【如需退出按【0】退出选项】"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    add3proxy
    ;;
    2)
    dele
    ;;
    3)
    bandlidele
    ;;
    4)
    service 3proxy start
    ;;
    5)
    pkill 3proxy
    ;;
    6)
    outip
    ;;
   # 7)
    #unInstall
    #;;	
    0)
    exit 1
    ;;
    *)
    clear
    echo "请输入正确数字"
    sleep 2s
    start_menu
    ;;
    esac
}
start_menu







