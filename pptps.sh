ips=(
192.168.0.167
192.168.0.163
192.168.0.161
192.168.0.168
192.168.0.165
192.168.0.154
192.168.0.155
192.168.0.160
192.168.0.157
192.168.0.172
192.168.0.250
192.168.0.158
192.168.0.171
192.168.0.159
192.168.0.156
192.168.0.162
192.168.0.166
192.168.0.170
192.168.0.169
)

for ((i = 0; i < ${#ips[@]}; i++)); do
echo "iptables -t nat -A POSTROUTING -s 10.0.$i.0/24 -j SNAT --to-source ${ips[i]}"
done





[modules]
log_file
log_syslog
log_tcp
l2tp
pptp
auth_mschap_v2
auth_mschap_v1
auth_chap_md5
auth_pap
chap-secrets
ippool

[core]
log-error=/var/log/accel-ppp/core.log
thread-count=4

[ppp]
verbose=1
mtu=1500
mru=1500
ipv4=require
ipv6=deny

[pptp]
verbose=1

[l2tp]
verbose=1

[dns]
dns1=114.114.114.114
dns2=119.29.29.29

[client-ip-range]
0.0.0.0/0

[ip-pool]
gw-ip-address=10.0.0.1
attr=Framed-Pool
10.0.0.0/24,name=pool0
10.0.1.0/24,name=pool1
10.0.2.0/24,name=pool2
10.0.3.0/24,name=pool3
10.0.4.0/24,name=pool4
10.0.5.0/24,name=pool5
10.0.6.0/24,name=pool6
10.0.7.0/24,name=pool7
10.0.8.0/24,name=pool8
10.0.9.0/24,name=pool9
10.0.10.0/24,name=pool10
10.0.11.0/24,name=pool11
10.0.12.0/24,name=pool12
10.0.13.0/24,name=pool13
10.0.14.0/24,name=pool14
10.0.15.0/24,name=pool15
10.0.16.0/24,name=pool16
10.0.17.0/24,name=pool17
10.0.18.0/24,name=pool18

[log]
log-file=/var/log/accel-ppp/accel-ppp.log
log-emerg=/var/log/accel-ppp/emerg.log
log-fail-file=/var/log/accel-ppp/auth-fail.log
copy=1
level=3

[pppd-compat]
verbose=1
ip-up=/etc/ppp/ip-up
ip-down=/etc/ppp/ip-down


[chap-secrets]
gw-ip-address=10.0.0.1
chap-secrets=/etc/ppp/chap-secrets



cat <<EOF > /etc/ppp/chap-secrets
admin0 * admin0 ipoe_poo0
admin1 * admin1 ipoe_pool
admin2 * admin2 ipoe_poo2
EOF
