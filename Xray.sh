#/bin/sh

ws_port="80"
ws_id="e98b29e6-83bb-4128-a439-3d0fcb5738c2"

ips=(
104.249.172.6
104.249.172.5
104.249.172.6
104.249.172.7
104.249.172.8
104.249.172.9
)

# Xray Installation
wget -O /usr/local/bin/xray https://github.com/none-blue/xray-amd64/raw/main/xray
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
systemctl status xray
