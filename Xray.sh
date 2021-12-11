#/bin/sh

ws_port="80"
ws_id="778ce72b-b78a-4aad-8212-439e0879aed3"

ips=(
11.22.33.44
22.33.44.55
66.77.88.99
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
