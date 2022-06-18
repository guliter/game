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
clear
echo ""
green "---> 已存在以下端口 <---"
echo ""
cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
echo ""
green "---> 已经存在用户 <---"
echo ""
cat /usr/local/3proxy/conf/passwd | sed 's/:.*$//'
echo ""
stty erase '^H' && read -p "输入【用户名-密码相同】:" uname
stty erase '^H' && read -p "输入【该用户的端口】:" dk
stty erase '^H' && read -p "输入【该用户的有效期/天】:" td
echo ""
sed -i -e '/'${uname}'/d' /usr/local/3proxy/conf/bandlimiters
sed -i -e '/'${uname}'/d' /usr/local/3proxy/conf/counters
sed -i -e '/'${uname}'/d' /usr/local/3proxy/conf/passwd
sed -i -e '/'${dk}'/d' /usr/local/3proxy/conf/3proxy.cfg
/usr/local/3proxy/conf/add3proxyuser.sh ${uname} ${uname} ${td} 1048576
cat >> /usr/local/3proxy/conf/bandlimiters<<EOF
bandlimout 1048576 ${uname}
EOF
cat >> /usr/local/3proxy/conf/3proxy.cfg<<EOF
socks -p${dk}
EOF
systemctl stop 3proxy.service
systemctl start 3proxy.service
red "--->3proxy-添加用户:【${uname}】端口:【${dk}】 有效期:【${td}天】操作已执行<---"
echo ""
}

dele(){
clear
echo ""
green "---> 已存在用户 <---"
echo ""
cat /usr/local/3proxy/conf/passwd | sed 's/:.*$//'
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
clear
echo ""
green "---> 已存在用户 <---"
echo ""
cat /usr/local/3proxy/conf/passwd | sed 's/:.*$//'
echo ""
stty erase '^H' && read -p "输入需解除带宽的【用户名】: " users
sed -i -e '/'${users}'/d' /usr/local/3proxy/conf/bandlimiters
echo ""
red "--->正在解除${users}的默认带宽限制<---"
echo ""
green "--->已解除${users}带宽限制<---"
cat >> /usr/local/3proxy/conf/bandlimiters<<EOF
nobandlimin ${users}
nobandlimout ${users}
EOF
echo ""
}

outip(){
clear
echo ""
green "---> 已存在以下端口 <---"
echo ""
cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
echo ""
green "---> 已存在用户 <---"
echo ""
cat /usr/local/3proxy/conf/passwd | sed 's/:.*$//'
echo ""
stty erase '^H' && read -p "输入【出口指定端口】:" pr
stty erase '^H' && read -p "输入【出口指定IP】:" ips
echo ""
sed -i -e '/'${pr}'/d' /usr/local/3proxy/conf/3proxy.cfg
cat >> /usr/local/3proxy/conf/3proxy.cfg<<EOF
socks -p${pr} -e${ips}
EOF
sed -i '23c allow *' /usr/local/3proxy/conf/3proxy.cfg
red "---> 3proxy-已添加SOCKS5指定出口IP和端口：${ips}:${pr} <---"
echo ""
}

adport(){
clear
green "---> 已存在以下端口 <---"
echo ""
cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
echo ""
stty erase '^H' && read -p "输入开放的端口: " add
sed -i -e '/'${add}'/d' /usr/local/3proxy/conf/3proxy.cfg
cat >> /usr/local/3proxy/conf/3proxy.cfg<<EOF
socks -p${add}
EOF
echo ""
systemctl stop 3proxy.service
systemctl start 3proxy.service
}

deport(){
clear
green "---> 已存在以下端口 <---"
echo ""
cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
echo ""
stty erase '^H' && read -p "输入需要删除的端口: " de
sed -i -e '/'-p${de}'/d' /usr/local/3proxy/conf/3proxy.cfg
}


	if [[ ! -d "/usr/local/3proxy/conf/add3proxyuser.sh" ]]; then
	
	Install
	
	fi
	
	clear
	start_menu(){
	echo ""
	red "---> 3proxy-socks5服务已经安装！<---"
	echo ""
   	 red "--->  1.3proxy-socks5添加用户  <---（默认1M带宽）"
   	 blue "--->  2.3proxy-socks5删除用户 <---"
 	 green "--->  3.3proxy-socks5解除默认带宽  <---（解除1M带宽限制）"
	 red "--->  4.3proxy-socks5启动服务  <---"
	 blue "--->  5.3proxy-socks5停止服务  <---"
	 green "--->  6.3proxy-socks5指定端口IP出口  <---（多IP）"
	 red "--->  7.3proxy-socks5添加端口  <---"
	 blue "--->  8.3proxy-socks5删除端口  <---"
	 green "--->  9.服务器状态-IP-端口 <---"
	 echo ""
	  blue "【如需退出按【0】退出选项】"
    echo
    read -p "请输入数字:" num
    echo ""
    case "$num" in
    1) 
    add3proxy
    start_menu
    ;;
    2)
    dele
    clear
    green "---> 删除用户后 <---"
    echo ""
    cat /usr/local/3proxy/conf/passwd | sed 's/:.*$//'
    start_menu
    ;;
    3)
    bandlidele
    start_menu
    ;;
    4)
    systemctl start 3proxy.service
    clear
    green "---> 启动服务后端口 <---"
    echo ""
    cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
    echo ""
    green "---> 启动服务存在用户 <---"
    echo ""
    cat /usr/local/3proxy/conf/passwd | sed 's/:.*$//'
    start_menu
    ;;
    5)
    systemctl stop 3proxy.service
    clear
    green "---> 停止服务后端口 <---"
    echo ""
    cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
    echo ""
    green "---> 停止服务存在用户 <---"
    echo ""
    cat /usr/local/3proxy/conf/passwd | sed 's/:.*$//'
    start_menu
    ;;
    6)
    outip
    clear
    green "---> 指定IP与端口 <---"
    echo ""
    cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
    echo ""
    green "---> 指定ip用户名 <---"
    echo ""
    cat /usr/local/3proxy/conf/passwd | sed 's/:.*$//'
    start_menu
    ;;
    7)
    adport
    clear
    green "---> 添加端口后剩余 <---"
    echo ""
    cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
    start_menu
    ;;	
    8)
    deport
    clear
    green "---> 删除端口后剩余 <---"
    echo ""
    cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
    start_menu
    ;;	
     9)
    clear
    green "---> 已存在端口 <---"
    echo ""
    cat /usr/local/3proxy/conf/3proxy.cfg | sed -n '/socks -p/,/socks -p/p'| sed  -e 's/socks -p//g'
    echo ""
    green "---> 已存在用户 <---"
    echo ""
    cat /usr/local/3proxy/conf/passwd | sed 's/:.*$//'
    echo ""

    ;;	
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
