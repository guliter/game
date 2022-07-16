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



ip=`curl http://whatismyip.akamai.com`



docker run -itd \
  --restart always \
  --name mysql \
  -p 6878:3306 \
  -v /root/data/docker_data/db:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e HYSQL_DATABASE=ture \
  mysql:5.7

bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Nginx_Proxy_Manager.sh)

docker run -d --restart=always --name Bitwarden -v /root/data/docker-data/bitwarden/bw-data/:/data/ -p 8485:80 bitwardenrs/server:latest

bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/duplicati/install.sh)

bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/heimdall/install.sh)

bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/tinytinyrss/install.sh)

docker run --restart=always --name x-ui -d --network=host --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /root/data/docker_data/x-ui:/etc/x-ui yuanter/x-ui:latest

bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/Docker/xyfaka/install.sh)


docker run -d --name freenom --restart always -v /root/data/docker_data/freenom:/conf -v /root/data/docker_data/freenom/logs:/app/logs yan33158164/foundations:freenom

yellow "基础安装：mysql x-ui freenom xyfaka rss heimadll dunlicati Bitwarden NPM"
