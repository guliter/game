#/bin/sh https://github.com/none-blue/xray-amd64/raw/main/xray

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



ws_port="5466"

yellow "请在↓输入端口:" 
printf "(默认端口: \e[33m5466\e[0m):"
echo
read ws_porttmp

if [[ -n "$ws_porttmp" ]]; then

    ws_port=$ws_porttmp

fi

ws_id="e98b29e6-83bb-4128-a439-3d0fcb5738c2"

psd="/proc/sys/kernel/random/uuid"
yellow "推荐使用的UUID：$(cat $psd)"
echo
yellow "请在↓输入UUID:"
printf "(默认UUID: \e[33me98b29e6-83bb-4128-a439-3d0fcb5738c2\e[0m): "
read ws_idtmp

if [[ -n "$ws_idtmp" ]]; then

    ws_id=$ws_idtmp

fi


serverip=$(ifconfig -a |grep -w "inet" |grep -v "255.255.0.0"|grep -v "127.0.0.1"| awk '{print $2;}')

ips=(
$serverip
)

# Xray Installation
wget -O /usr/local/bin/xray https://raw.githubusercontent.com/guliter/game/main/xray
chmod +x /usr/local/bin/xray

cat <<EOF > /etc/systemd/system/xray.service
[Unit]
Description=The Xray Proxy Serve
After=network-online.target

[Service]
ExecStart=/usr/local/bin/xray -c /etc/xray/serve.toml
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
RestartSec=15s

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable xray

# Xray Configuration
mkdir -p /etc/xray
echo -n "" > /etc/xray/serve.toml
for ((i = 0; i < ${#ips[@]}; i++)); do
cat <<EOF >> /etc/xray/serve.toml
[[inbounds]]
listen = "${ips[i]}"
port = $ws_port
protocol = "vmess"
tag = "$((i+1))"
[inbounds.settings]
[[inbounds.settings.clients]]
id = "$ws_id"
[inbounds.streamSettings]
network = "ws"

[[routing.rules]]
type = "field"
inboundTag = "$((i+1))"
outboundTag = "$((i+1))"

[[outbounds]]
sendThrough = "${ips[i]}"
protocol = "freedom"
tag = "$((i+1))"

EOF
done

systemctl start xray
echo

red  "已启用所有IP配置完成:\n\n$serverip"
echo
yellow  "【发现IP数量不对请添加对应网卡配置！再次安装】"
echo
red "UUID：$ws_id"
red "默认端口：$ws_port"
red "传输协议：WS"
echo 
#yum install -y qrencode
> /root/vmess.txt
for ((i = 0; i < ${#ips[@]}; i++)); do
   raw="{
  \"v\":\"2\",
  \"ps\":\"\",
  \"add\":\""${ips[i]}"\",
  \"port\":\"$ws_port\",
  \"id\":\"$ws_id\",
  \"aid\":\"0\",
  \"net\":\"ws\",
  \"type\":\"none\",
  \"host\":\"\",
  \"path\":\"\",
  \"tls\":\"none\"
}"
    link=`echo -n ${raw} | base64 -w 0`
    link="vmess://${link}"
echo
redbg "总共${#ips[@]}个IP"
echo
yellow "第【$((i+1))】个IP:${ips[i]}"
echo
green  "vmess链接: $link" | tee -a /root/vmess.txt
echo
done
#echo $link | qrencode -t UTF8
systemctl restart xray

