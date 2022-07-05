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

> docker-compose.yml
cat >> /root/docker-compose.yml<<EOF
---
version: '3'
services:
  umami:
    image: ghcr.io/mikecao/umami:postgresql-latest
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://umami:umami@db:5432/umami # 这里的数据库和密码要和下方你修改的相同
      DATABASE_TYPE: postgresql
      HASH_SALT: replace-me-with-a-random-string
    depends_on:
      - db
    restart: always
  db:
    image: postgres:12-alpine
    environment:
      POSTGRES_DB: umami
      POSTGRES_USER: umami # 数据库用户
      POSTGRES_PASSWORD: umami  # 数据库密码
    volumes:
      - ./sql/schema.postgresql.sql:/docker-entrypoint-initdb.d/schema.postgresql.sql:ro
      - umami-db-data:/var/lib/postgresql/data
    restart: always
volumes:
  umami-db-data:

EOF
redbg "【Umami网站流量监控】启动中......"
docker-compose up -d
echo
redbg "【Umami网站流量监控】-默认面板:http://${ip}:3000 【admin umami】"
echo
