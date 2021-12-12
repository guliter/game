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





#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ];then
    OS=CentOS
    [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
    [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
    [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ];then
    OS=CentOS
    CentOS_RHEL_version=6
elif [ -n "$(grep bian /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Debian' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Deepin /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Deepin' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Ubuntu /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Ubuntu' -o -n "$(grep 'Linux Mint' /etc/issue)" ];then
    OS=Ubuntu
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Ubuntu_version=$(lsb_release -sr | awk -F. '{print $1}')
    [ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_version=16
else
    echo "Does not support this OS, Please contact the author! "
    kill -9 $$
fi

#Install Basic Tools
if [[ ${OS} == Ubuntu ]];then
	echo ""
	echo "***********************"
	echo "*目前不支持Ubuntu系统！*"
	echo "*请使用CentOS搭建     *"
	echo "**********************"
	exit 0
	apt-get install git unzip wget -y
	
fi
if [[ ${OS} == CentOS ]];then
	
	yum install git unzip wget -y
   
fi
if [[ ${OS} == Debian ]];then
	echo "***********************"
	echo "*目前不支持Debian系统！*"
	echo "*请使用CentOS搭建     *"
	echo "**********************"
	apt-get install git unzip wget -y
    
fi

#1.清理旧环境和配置新环境
Clear(){
unInstall
clear
echo "旧环境清理完毕！"
echo ""
echo "安装Socks5所依赖的组件,请稍等..."
yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel openssl-devel
yum update -y nss curl libcurl 

#配置环境变量
sed -i '$a export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' ~/.bash_profile
source ~/.bash_profile

#关闭防火墙
newVersion=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
if [[ ${newVersion} = "7" ]] ; then
 systemctl stop firewalld
 systemctl disable firewalld
 
 elif [[ ${newVersion} = "6" ]] ;then 
 service iptables stop
 chkconfig iptables off
 else
 echo "Exception version"
fi
}

#2.下载Socks5服务
Download()
{
echo ""
echo "下载Socks5服务中..."
cd  /root
git clone https://github.com/wyx176/Socks5
}


#3.安装Socks5服务程序
InstallSock5()
{
echo ""
echo "解压文件中..."
cd  /root/Socks5
tar zxvf ./ss5-3.8.9-8.tar.gz

echo "安装中..."
cd /root/Socks5/ss5-3.8.9
./configure
make
make install
}

#4.安装控制面板配置参数
InstallPanel()
{
#cd  /root/Socks5
mv /root/Socks5/service.sh /etc/opt/ss5/
mv /root/Socks5/user.sh /etc/opt/ss5/
mv /root/Socks5/version.txt /etc/opt/ss5/
mv /root/Socks5/ss5 /etc/sysconfig/
mv /root/Socks5/s5 /usr/local/bin/
chmod +x /usr/local/bin/s5

#设置默认用户名、默认开启帐号验证
uname="123"
upasswd="123"
port="9257"
confFile=/etc/opt/ss5/ss5.conf
echo -e $uname $upasswd >> /etc/opt/ss5/ss5.passwd
sed -i '87c auth    0.0.0.0/0               -               u' $confFile
sed -i '203c permit u	0.0.0.0/0	-	0.0.0.0/0	-	-	-	-	-' $confFile


#添加开机启动
chmod +x /etc/init.d/ss5
chkconfig --add ss5
chkconfig --level 345 ss5 on
confFile=/etc/rc.d/init.d/ss5
sed -i '/echo -n "Starting ss5... "/a if [ ! -d "/var/run/ss5/" ];then mkdir /var/run/ss5/; fi' $confFile
sed -i '54c rm -rf /var/run/ss5/' $confFile
sed -i '18c [[ ${NETWORKING} = "no" ]] && exit 0' $confFile

#判断ss5文件夹是否存在、
if [ ! -d "/var/run/ss5/" ];then
mkdir /var/run/ss5/
echo "create ss5 success!"
else
echo "/ss5/ is OK!"
fi
}

#5.检测是否安装完整
check(){
cd /root
rm -rf /root/Socks5
rm -rf /root/install.sh
service ss5 start
echo ""
echo "Socks5安装完毕！"
echo ""
red "输入"s5"启动Socks5控制面板"
echo ""
echo "默认用户名: "${uname}
echo "默认密码  : "${upasswd}
echo "默认端口  : "${port}
echo ""
sed -i "2s/5555/$port/" /etc/sysconfig/ss5
service ss5 restart
}
	
#6.卸载
unInstall(){
service ss5 stop
rm -rf /run/ss5
rm -f 	/run/lock/subsys/ss5
rm -rf /etc/opt/ss5
rm -f /usr/local/bin/s5
rm -rf 	/usr/lib/ss5
rm -f /usr/sbin/ss5
rm -rf /usr/share/doc/ss5
rm -rf /root/ss5-3.8.9
rm -f /etc/sysconfig/ss5
rm -f /etc/rc.d/init.d/ss5
rm -f /etc/pam.d/ss5
rm -rf /var/log/ss5
}


userstp()
{
us=sed -i /etc/opt/ss5/ss5.passwd
uuid55=`sed -n '8p' /docker/v2/config.json`
echo "账号密码： $us"

}



	if [[ ! -d "/etc/opt/ss5" ]]; then
Clear
Download
InstallSock5
InstallPanel
check
	fi
	check
	start_menu(){
	red "--->Socks5服务已经安装！<---"
	echo
   	 red "1.Socks5--显示信息"
   	 blue "2.Socks5--控制面板"
 	 green "3.卸载Socks5"
   	 blue "【如需退出按【0】退出选项】"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    userstp
    ;;
    2)
    s5
    ;;
    3)
    unInstall
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





