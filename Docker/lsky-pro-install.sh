yum -y install unzip zip
mkdir -p /root/data/docker_data/lsky-pro
wget https://raw.githubusercontent.com/guliter/game/main/Docker/lsky-pro/docker-compose.yml -P /root/data/docker_data/lsky-pro

#chmod 777 /root/data/docker_data/lsky-pro
echo -e "\033[36m cd /root/data/docker_data/lsky-pro \033[0m"
echo -e "\033[36m docker-compose up -d \033[0m"
rm $0
