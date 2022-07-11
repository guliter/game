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
systemctl enable docker
service docker restart
docker volume create portainer_data
docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /root/data/docker_data/portainer:/data portainer/portainer
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
docker run --name= h5ai -it -d -p 2571:80 -v /root/share:/var/www clue/h5ai
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
redbg "【目录分享】Zdir-默认面板:http://${ip}:2569 【zdir xiaoz.me】"
echo
redbg "【文件管理】KODExplorer-默认面板:http://${ip}:2570"
echo
}


install_5(){
#创建临时容器：
docker run  -itd --name=tmp baiyuetribe/oneindex
#拷贝容器内文件到宿主机目录：
docker cp tmp:/var/www/html /opt/oneindex
docker rm -f tmp
#正式启动服务：
docker run --name= OneDrive -d -p 5147:80 -v /opt/oneindex:/var/www/html --restart=always baiyuetribe/oneindex
clear
echo
redbg "【私人网盘】OneDrive-默认面板:http://${ip}:5147"
echo
}


install_6(){
docker run --name Grav -d -p 9292:80 evns/grav
clear
echo
redbg "【GRAV】博客-默认面板:http://${ip}:9292"
echo
}

install_7(){
docker run --name wordpress-mysql -e MYSQL_ROOT_PASSWORD=baiyue -d mysql:5.5   #安装数据库大小只有66MB
docker run -p 9393:80 --name wordpress --link some-mysql:mysql -d wordpress  #运行wordpress
clear
echo
redbg "【Wordpress】博客-默认面板:http://${ip}:9393"
echo
}


install_8(){
bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/tinytinyrss/install.sh)
echo
}

install_9(){
docker run --name forsaken-mail  -d -p 10087:10087 -p 25:25 -p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock denghongcai/forsaken-mail
clear
echo
redbg "【临时邮箱】-默认面板:http://${ip}:3000"
echo
}

install_10(){
systemctl stop firewalld.service >/dev/null 2>&1
systemctl disable firewalld.service >/dev/null 2>&1
docker pull yuanter/x-ui:latest
#docker run -d --name=x-ui  --log-opt max-size=10m --log-opt max-file=5 --network=host --restart=always yuanter/x-ui:latest
#docker run --restart=always --name x-ui -d -p 5566:54321 -p 8000-8010:8000-8010/tcp -p 8000-8010:8000-8010/udp --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v $PWD/x-ui-data:/etc/x-ui yuanter/x-ui:latest
docker run --restart=always --name x-ui -d  --network=host --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /root/data/docker_data/x-ui:/etc/x-ui yuanter/x-ui:latest
clear
echo
redbg "【X-ui】-默认面板:http://${ip}:54321 【admin admin】"
echo
}


install_11(){
stty erase '^H' && read -p "输入【管理员账户】:" uname
stty erase '^H' && read -p "输入【管理员密码】:" pasw
 sudo docker pull docker.seafile.top/seafileltd/seafile-pro:latest 
 sudo docker  run -d -it --name seafile \
-e SEAFILE_SERVER_HOSTNAME=${ip} \
-e SEAFILE_ADMIN_EMAIL=${uname} \
-e SEAFILE_ADMIN_PASSWORD=${pasw} \
-v /shared:/shared \
-p 5777:80 \
-p 5778:8000 \
-p 8082:8082 \
docker.seafile.top/seafileltd/seafile-pro:latest	
clear
echo
redbg "【Seafile】同步盘-默认面板:http://$ip:5777 【admin admin】"
echo
}

install_12(){
docker run --restart=always --name Jellyfin -d -p 8096:8096 -v /data/docker_data/jellyfin/config:/config -v /data/docker_data/jellyfin/media:/media jellyfin/jellyfin
clear
echo
redbg "【Jellyfin】家庭影院-默认面板:http://$ip:8096 【admin admin】"
echo

}


install_13(){
docker run --restart=always --name lanraragi -d -p 1890:8090 -p 3000:3000 -v /root/data/docker_data/lanraragi/content:/root/lanraragi/content  -v /root/data/docker_data/lanraragi/database:/root/lanraragi/database  dezhao/lanraragi_cn
clear
echo
redbg "【漫画】LANraragi-默认面板:http://$ip:3000"
echo

}

install_14(){
docker run --name="ccaa" -d -p 6080:6080 -p 6081:6081 -p 6800:6800 -p 51413:51413 \
    -v /data/ccaaDown:/data/ccaaDown \
    -e PASS="xiaoz.me" \
    helloz/ccaa \
    sh -c "dccaa pass && dccaa start"
clear
echo
redbg "【Aria2离线下载-在线播放】-默认面板:http://$ip:6080 【#文件管理默认用户名为ccaa，密码为admin，登录后可在后台修改 PASS="xiaoz.me"】"
echo

}


install_15(){
bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/Plik/install.sh)
echo

}

install_16(){
docker run -d --restart=always -v /root/data/docker_data/alist:/opt/alist/data -p 5244:5244 --name="alist" xhofe/alist:latest  #可以自己保存下来，比如创建一个config.txt的文件，把这条代码复制进去保存，下次换服务器搬家之类的就很容易。
clear
docker logs alist
echo
redbg "【AList 网盘】-默认面板:http://$ip:5244"
echo

}


install_17(){
docker run -d \
   --restart always \
   --name jirafeau \
   -p 2180:80 \
   -v /root/data/docker_data/jirafeau/data:/data \
   -v /root/data/docker_data/jirafeau/cfg:/cfg \
   jgeusebroek/jirafeau
clear
echo
redbg "【Jirafeau】临时加密盘-默认面板:http://$ip:2180"
echo

}

install_20(){
docker run -it -d --name halo -p 8244:8090 -v /root/data/docker_data/halo:/root/.halo --restart=unless-stopped halohub/halo:1.5.2
clear
echo
redbg "【Halo】博客-默认面板:http://$ip:8244"
echo

}


install_28(){
docker run -d --name Bitwarden -v /root/data/docker-data/bitwarden/bw-data/:/data/ -p 8000:80 bitwardenrs/server:latest
clear
echo
redbg "【Bitwarden】-默认面板:http://$ip:8000"
echo
}

install_31(){
docker run -d \
--name=v2board \
--privileged=true \
--restart always \
-v /usr/local/v2board:/usr/local/src \
-p 8045:80 \
gz1903/v2board:1.6.0
clear
echo
redbg "【V2Board】-默认面板:http://$ip:8045"
echo
}

install_32(){
#bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/zfaka/install.sh)
mkdir -p /opt/zfaka && cd /opt/zfaka        #创建本地源码存储路径
wget https://raw.githubusercontent.com/Baiyuetribe/zfaka/epay-payjs/docker-compose.yml
docker-compose up -d
clear
echo
redbg "【zfaka】-默认面板:http://$ip:3002"
echo
}

install_34(){
docker run -d --name qiandao -p 12345:80 -v /root/data/docker_data/qiandao:/usr/src/app/config   asdaragon/qiandao
docker-compose up -d
clear
echo
redbg "【签到服务】-默认面板:http://$ip:12345"
echo
}

install_35(){
docker run -d --name qiandao -p 12345:80 -v /root/data/docker_data/qiandao:/usr/src/app/config   asdaragon/qiandao
docker-compose up -d
clear
echo
redbg "【签到服务】-默认面板:http://$ip:12345"
echo
}

install_36(){
docker run -d --name qiandao -p 12345:80 -v /root/data/docker_data/qiandao:/usr/src/app/config   asdaragon/qiandao
docker-compose up -d
clear
echo
redbg "【签到服务】-默认面板:http://$ip:12345"
echo
}

install_37(){
docker run -d --name qiandao -p 12345:80 -v /root/data/docker_data/qiandao:/usr/src/app/config   asdaragon/qiandao
docker-compose up -d
clear
echo
redbg "【签到服务】-默认面板:http://$ip:12345"
echo
}

install_38(){
docker run -d --name qiandao -p 12345:80 -v /root/data/docker_data/qiandao:/usr/src/app/config   asdaragon/qiandao
docker-compose up -d
clear
echo
redbg "【签到服务】-默认面板:http://$ip:12345"
echo
}
install_100(){
clear
echo
redbg "Portainer-默认面板:http://${ip}:9000"
echo
redbg "【目录分享】h5ai-默认面板:http://${ip}:2571"
echo
redbg "【目录分享】Zdir-默认面板:http://${ip}:2569 【zdir xiaoz.me】"
echo
redbg "【文件管理】KODExplorer-默认面板:http://${ip}:2570"
echo
redbg "【私人网盘】OneDrive-默认面板:http://${ip}:5147"
echo
redbg "【GRAV】博客-默认面板:http://${ip}:9292"
echo
redbg "【Wordpress】博客-默认面板:http://${ip}:9393"
echo
redbg "【Onlyoffice】-默认面板:http://${ip}:5422"
echo
redbg "【临时邮箱】-默认面板:http://${ip}:3000"
echo
redbg "【X-ui】-默认面板:http://${ip}:54321 【admin admin】"
echo
redbg "【临时邮箱】-默认面板:http://${ip}:54321 【admin admin】"
echo
echo
redbg "【Seafile】同步盘-默认面板:http://$ip:5777 【admin admin】"
echo
}




#开始菜单
start_menu(){
echo
yellow "Docker版绝对优势：部署多个程序互不干扰，独立运行；部署速度快，维护方便"
echo
green "———————————————————————————————————---->>基础功能<<----—————————————————————————————————"
redbg "   1.【Portainer】		13.【漫画】LANraragi	28.【Bitwarden】密码管理"		
green "   2.【NPM反代】		14.【Aria2下载-在线播放】	30.【ServerStatus】		
    ———————————————————————————————————---->>云盘目录类<<----————————————————————————————————
    3.【分享盘】h5ai		15.【分享盘】Plik	26.【云网盘】FileRun 	
    4.【分享盘】Zdir		16.【云网盘】AList	34.【签到服务】
    5.【分享盘】OneDrive	17.【分享盘】Jirafeau	
    11.【同步盘】Seafile	24.【同步盘】syncthing	25.【Duplicati】备份神器			
    ———————————————————————————————————---->>博客类程序<<----—————————————————————————————————
    33.【heimdall】导航		6.【GRAV】博客		18.【Wiki】随身笔记		
    7.【Wordpress】博客		19.【Typecho】博客	21.【Matomo 专业统计】
    8.【RSS订阅器】		20.【Halo】 博客	22.【Umami 轻量统计】			
    ———————————————————————————————————---->>发卡&&博客<<----——————————————————————————————————
    39.Kodexplorer	38.Malio	36.【z发卡】	35.【祥云发卡】	32.【zfaka】
    10.【X-ui】		31.【V2Board】	37.骗子查询
     ———————————————————————————————————---->>其他类型<<----——————————————————————————————————
    12.【Jellyfin】家庭影院	23.【YOURLS 短连接】	9.【临时邮箱】
    27.图床 【lsky-pro】	29.图床【easyimage】	41.【青龙面板】	40.【Fiora 聊天室】	
     ———————————————————————————————————---->>其他类型<<----——————————————————————————————————
    0.【输出0退出菜单】		100.【输出1-12配置】"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    install_1
	;;
    2)
    bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Nginx_Proxy_Manager.sh)
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
    11)
    install_11
	;;
	10)
    install_10
	;;   
	12)
    install_12
    	;;   
	13)
    install_13
    	;;   
	14)
    install_14
    	;;   
	15)
    install_15
    	;;   
	16)
   install_16
    	;;   
	17)
   	 install_17
    	;;   
	18)
   	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Wiki.sh)
        ;;   
	19)
	bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/typecho/typecho-install.sh)
        ;;   
	20)
	install_20
	;;   
	21)
 	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Matomo.sh)
	;;
	22)
  	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/umami.sh)
	;; 
	23)
	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/yourls/install.sh)
	;; 
	24)
 	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/syncthing/install.sh)
	 ;; 
	25)
 	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/duplicati/install.sh)
	 ;; 
	26)
 	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/FileRun/install.sh)
	 ;; 
	 27)
 	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/lsky-pro/lsky-pro-install.sh)
	;; 
	28)
 	 install_28
	 ;; 
	29)
 	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/easyimage/install.sh)
	 ;; 
	30)
 	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/ServerStatus/install.sh)
#bash sss.sh YOUR_TG_CHAT_ID YOUR_TG_BOT_TOKEN
	 ;; 
	31)
 	 install_31
	 ;; 
	32)
 	 install_32
	 ;; 
	33)
 	 bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/heimdall/install.sh)
	 ;; 
	34)
 	 install_34
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
