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




mkdir -p /root/data/docker_data/tyepcho

cd /root/data/docker_data/tyepcho

touch mysql.env
> mysql.env
cat >> /root/data/docker_data/tyepcho/mysql.env<<EOF
MYSQL_ROOT_PASSWORD=root_pass
MYSQL_DATABASE=typecho
MYSQL_USER=username
MYSQL_PASSWORD=password
EOF

cd /root/data/docker_data/tyepcho

mkdir php

cd php

touch Dockerfile

cd /root/data/docker_data/tyepcho/php
> Dockerfile
cat >> /root/data/docker_data/tyepcho/php/Dockerfile<<EOF
FROM php:7.3.29-fpm
RUN apt-get update \
    && docker-php-ext-install pdo_mysql \
    && echo "output_buffering = 4096" > /usr/local/etc/php/conf.d/php.ini \
    && echo "date.timezone = PRC" >> /usr/local/etc/php/conf.d/php.ini
EOF

cd /root/data/docker_data/tyepcho

mkdir nginx

cd nginx

touch default.conf

cd /root/data/docker_data/tyepcho/nginx
> default.conf
cat >> /root/data/docker_data/tyepcho/nginx/default.conf<<EOF
server {
    listen 80 default_server;
    root /var/www/html;
    index index.php;

    access_log /var/log/nginx/typecho_access.log main;
    if (!-e $request_filename) {
        rewrite ^(.*)$ /index.php$1 last;
    }
    location / {
        index index.html index.htm index.php;

        if (!-e $request_filename) {
            rewrite . /index.php last;
        }
    }

    location ~ \.php(.*)$ {
        fastcgi_pass   php:9000;
        fastcgi_index  index.php;
        fastcgi_param  PATH_TRANSLATED $document_root$fastcgi_path_info;
        fastcgi_split_path_info  ^((?U).+\.php)(/?.+)$;
        fastcgi_param  PATH_INFO  $fastcgi_path_info;
        fastcgi_param  SCRIPT_NAME $fastcgi_script_name;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}

EOF

cd /root/data/docker_data/typecho/typecho

wget https://github.com/typecho/typecho/releases/download/v1.2.0/typecho.zip

yum -y install unzip zip

unzip typecho.zip


cd /root/data/docker_data/tyepcho

touch docker-compose.yml

> docker-compose.yml
cat >> /root/data/docker_data/tyepcho/docker-compose.yml<<EOF
version: "3"

services:
  nginx:
    image: nginx
    ports:
      - "8223:80"    # 左边可以改成任意没使用的端口
    restart: always
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./typecho:/var/www/html
      - ./nginx:/etc/nginx/conf.d
      - ./logs:/var/log/nginx
    depends_on:
      - php
    networks:
      - web

  php:
    build: php
    restart: always
    expose:
      - "9000"       # 不暴露公网，故没有写9000:9000
    volumes:
      - ./typecho:/var/www/html
    environment:
      - TZ=Asia/Shanghai
    depends_on:
      - mysql
    networks:
      - web

  mysql:
    image: mysql:5.7
    restart: always
    environment:
      - TZ=Asia/Shanghai
    expose:
      - "3306"  # 不暴露公网，故没有写3306:3306
    volumes:
      - ./mysql/data:/var/lib/mysql
      - ./mysql/logs:/var/log/mysql
      - ./mysql/conf:/etc/mysql/conf.d
    env_file:
      - mysql.env
    networks:
      - web

networks:
  web:
EOF







redbg "【Typecho博客】启动中......"
docker-compose up -d
echo
redbg "【Typecho博客】-默认面板:http://${ip}:8223 【admin umami】"
echo
