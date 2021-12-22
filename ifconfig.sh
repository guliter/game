#!/bin/bash

#======用户填写信息网卡聚合后的IP信息

gatewayset=1.1.1.1

netmask=255.255.255.0                   # 子网掩码

a=(                             # 请将IP地址放置括号内，分隔符是换行或者空格

1.1.1.1

)

dnsset=8.8.8.8

dnsset1=114.114.114.114

# IP写入

sed -i 's/^SELINUX=.*/SELINUX=Disabled/g' /etc/sysconfig/selinux 

                                                        # 匹配  ^ 开头字符为SELINUX和该行后面的所有字符

                                                        # 更改为 SELINUX=Disabled，后面是文件路径

                                                        # 关闭 selinux

getenforce                                      # 查看状态：显示参数为disabled则为成功关闭

########################## 查找原始网卡路径 ##############################

listeth=`ip a| grep "BROADCAST" | awk -F ":" '{print $2}' | sed "s/ //g"` ; echo "网卡名为："$eth ;

 echo "如果网卡名称不正确，修改 eth 变量中的NR==2 是列出所有网卡选择第二张，"   

 

 # 命令 ip a 查看网卡 过滤；broadcast  [ˈbrɔːdkɑːst] >广播；字段的行

                                                                                 # awk -F ":" 以冒号为分隔符 ; 选择第一行，第二列，sed删除空格

                                        # 符号  ; 分号表示第一条命令结束，第二条开始



szeth=(

$listeth

)

echo "查看网卡数组变量: ${szeth[*]} 

总数为：${#szeth[*]}

" 



for((i=0;i<${#szeth[*]};i++))

do

echo "网卡名: ${szeth[$i]}  对应编号：$i   



速率为: `ethtool ${szeth[$i]} | grep Speed  `

------------------------------------------"

done





echo "网卡速率为100M的是外网卡,并输入数字编号进行选择配置外网卡!" 



read -p "请输入 数字编号：" rp

echo "您选择的 网卡为： ${szeth[$rp]}"





eth=${szeth[$rp]}

echo "此时将对网卡  $eth  进行批量覆盖式修改"

ethCatalog=$(find / -name "*$eth" | grep "/etc/" | sed "s/ //g" ) ;  echo "网卡路径为: "  $ethCatalog

                                                                                # catalog [ˈkætəlɔg] 目录

                                                                                # find 查找网卡名称的路径，grep 过滤/etc 目录下网卡名称。sed删除空格

ip=$(cat $ethCatalog | grep IPADDR | awk -F "=" 'NR==1{print $2}' | sed "s/ //g") ; echo "IP地址为: " $ip

                                                                                # 查看网卡文件，过滤IPADDR的行，awk -F"=" 分隔符是冒号，打印第一行第二列

echo "使用变量‘$ip’传来的网卡名,再使用find 查看命令，'*$ip'  星号是网卡名前面还有字符模糊匹配。网卡路径为：$ifcfg"

                                                        # 我要在/etc 目录里，查找网卡名开头字符为ifcfg的网卡名字和路径：

                                                        # find /etc  -name  ifcfg*    # -name指定名字，符号 * 后面所有内容

echo "==========没有需改的网卡信息为============" 

cat $ethCatalog

sed -i "/IPADDR/d" $ethCatalog

sed -i "/NETMASK/d" $ethCatalog

sed -i "/GATEWAY/d" $ethCatalog

sed -i "/DNS/d" $ethCatalog

sed -i "/PREFIX/d" $ethCatalog

echo "网卡恢复初始化完成，查看网卡配置信息 "

cat $ethCatalog

sed -i  's/BOOTPROTO.*/BOOTPROTO=static/g'  $ethCatalog

sed -i  's/^ONBOOT.*/ONBOOT=yes/g' $ethCatalog

                                                        #  -e 修改多个  .* 后面的所有内容    \ 多行换行

                                                        # 设置为static静态

                                                        # 开启 onboot=yes

                                                        # 最后跟上文件路径

IPADDR=$(grep -r IPADDR1 $jhetc| awk -F = '{print $0}');

ags=${#a[*]}

echo "数组有效元素为：$ags"

ipgs=$ags                                                                           # 限制循环打印次数：数组个数为循环次数

for ((i=0;i<=$ipgs;i++))

do

echo "IPADDR""$i"=${a[$i]} >> $ethCatalog                               # $i 是换行自加加循环，也用来指定数组角标对应的值

done

echo "GATEWAY="$gatewayset >> $ethCatalog                                       # 只有一个网关和DNS，不能为1，否则无法连接

echo "DNS="$dnsset >> $ethCatalog

echo "DNS1="$dnsset1 >> $ethCatalog

#=====netmask

qa=1                                                                                    # 定义qa变量值为1

while(( $qa<=$ipgs ))                                           # while  [wʌɪl] 同时，对变量进行约束定义

do                                                              # do 行动

        echo "NETMASK"$qa"=$netmask" >> $ethCatalog                 # 打印变量

        let "qa++"                                                                      # 定义变量的规则

done

echo "会自动删除多余信息，请等待。。。"

sed -i '/^$/d' $ethCatalog                                          # '/^$/d' 删除 d ;   开头和后面所有为空 ^$ 

sed -i 's/IPADDR0/IPADDR/g' $ethCatalog

sed -i 's/NETMASK0/NETMASK/g' $ethCatalog                                   # 将名称为0 的网卡去掉0

                                                                                                                # 文件路径

sed -i "/"IPADDR$ipgs"/d" $ethCatalog

sed -i "/"NETMASK$ipgs"/d"  $ethCatalog                                             # 删除多余信息

echo "==========修改后的网卡信息为============" 

cat $ethCatalog

echo "网卡路径：" $ethCatalog

ip a

/etc/init.d/network restart ; ip a ; ping -c10 -w10  eisc.cn

                                                                                                # 重启 ，查看ip ， ping -c 10 次数C  10次，-w 单次ping等待时间秒
