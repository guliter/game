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
cd /root
> docker-compose.yml
cat >> /root/docker-compose.yml<<EOF
---
version: "2.1"
services:
  wikijs:
    image: lscr.io/linuxserver/wikijs
    container_name: wikijs
    environment:
      - PUID=1000        # 如何查看当前用户的PUID和PGID，直接命令行输入id就行
      - PGID=1000
      - TZ=Asia/Shanghai
    volumes:
      - /root/data/docker_data/wikijs/config:/config  # 配置文件映射到本地，数据不会因为Docker停止而丢失
      - /root/data/docker_data/wikijs/data:/data  # 数据映射到本地，数据不会因为Docker停止而丢失
    ports:
      - 6547:3000   # 左边的8080可以自己调整端口号，右边的3000不要改
    restart: unless-stopped


EOF
redbg "【Wiki软件】启动中......"
docker-compose up -d
echo
redbg "【Wiki软件】-默认面板:http://${ip}:6547"
echo
