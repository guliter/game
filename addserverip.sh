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

if [[ ! -f "/root/ip.txt" ]]; then
echo
clear
redbg "请将ip.txt文件保存至/root/目录下！"
echo
else
serverip=$(cat /root/ip.txt)

ips=(
$serverip
)

for ((i = 0; i < ${#ips[@]}; i++)); do
ifconfig eth0:$((i+1)) ${ips[i]}
done
echo
red "总共创建${#ips[@]}个网卡配置"
echo
echo
redbg "若重启小鸡请再次运行脚本！"
echo
fi