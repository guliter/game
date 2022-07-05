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




mkdir -p /root/data/docker_data/matomo
cd /root/data/docker_data/matomo
touch db.env
> db.env
cat >> /root/data/docker_data/matomo/db.env<<EOF
MYSQL_PASSWORD=Pas3W0rd
MYSQL_DATABASE=matomo
MYSQL_USER=matomo
MATOMO_DATABASE_ADAPTER=mysql
MATOMO_DATABASE_TABLES_PREFIX=matomo_
MATOMO_DATABASE_USERNAME=matomo
MATOMO_DATABASE_PASSWORD=Pas3W0rd
MATOMO_DATABASE_DBNAME=matomo
EOF

cd /root/data/docker_data/matomo
> docker-compose.yml
cat >> /root/data/docker_data/matomo/docker-compose.yml<<EOF
version: "3"

services:
  db:
    image: mariadb
    command: --max-allowed-packet=64MB
    restart: always
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=Pas3W0rd
    env_file:
      - ./db.env

  app:
    image: matomo
    restart: always
    volumes:
#     - ./config:/var/www/html/config
#     - ./logs:/var/www/html/logs
      - /root/data/docker_data/matomo/matomo/html:/var/www/html
    environment:
      - MATOMO_DATABASE_HOST=db
    env_file:
      - ./db.env
    ports:
      - 6548:80  # 8080可以更改为别的未使用的端口  lsof -i:8080 可以查看8080端口是否被使用
      - 8443:443 # 8443可以更改为别的未使用的端口  这边后续填到NPM的“Custom location”里
volumes:
  db:
  matomo:


EOF
redbg "【Matomo 网站统计】启动中......"
docker-compose up -d
echo
redbg "【Matomo 网站统计】-默认面板:http://${ip}:6548"
echo
