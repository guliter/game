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

name=tinytinyrss

ip=`curl http://whatismyip.akamai.com`

#yum -y install unzip zip
mkdir -p /root/data/docker_data/$name
wget https://raw.githubusercontent.com/guliter/game/main/Docker/$name/docker-compose.yml -P /root/data/docker_data/$name

#chmod 777 /root/data/docker_data/$name
#echo -e "\033[36m cd /root/data/docker_data/lsky-pro \033[0m"
#echo -e "\033[36m docker-compose up -d \033[0m"
#rm $0
cd /root/data/docker_data/$name


> docker-compose.yml

cat >> /root/docker-compose.yml<<EOF
version: "3"
services:
  service.rss:
    image: wangqiru/ttrss:latest
    container_name: ttrss
    ports:
      - 3894:80 # 按需修改
    environment:
      - SELF_URL_PATH=https://rss.gamestart.ml/ # 按需修改
      - DB_PASS=ipbufQW8F2 # 按需修改。与下面的密码对应
    volumes:
      - ./feed-icons:/var/www/feed-icons/
    networks:
      - public_access
      - service_only
      - database_only
    stdin_open: true
    tty: true
    restart: always
 
  service.mercury:
    image: wangqiru/mercury-parser-api:latest
    container_name: ttrss_mercury
    networks:
      - public_access
      - service_only
    restart: always
 
  service.opencc:
    image: wangqiru/opencc-api-server:latest
    container_name: ttrss_opencc
    environment:
      - NODE_ENV=production
    networks:
      - service_only
    restart: always
 
  database.postgres:
    image: postgres:13-alpine
    container_name: ttrss_postgres
    environment:
      - POSTGRES_PASSWORD=ipbufQW8F2 # 按需修改。与上面的密码对应
    volumes:
      - ./db/:/var/lib/postgresql/data
    networks:
      - database_only
    restart: always
 
networks:
  public_access: 
  service_only: 
    internal: true
  database_only: 
    internal: true
EOF






clear
redbg "【tinytinyrss-订阅服务】启动中......"
chmod -R 777 /root/data/docker_data/$name/feed-icons
docker-compose restart
echo
redbg "【tinytinyrss-订阅服务】-默认面板:解析好的域名"
echo
redbg "一定要解析好域名配置docker-compose.yml才能正常启动 【admin password】"
echo

