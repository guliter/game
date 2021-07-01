
bash <(curl -sL https://raw.githubusercontent.com/guliter/game/main/v2ray.sh)




bash <(curl -Ls https://raw.githubusercontent.com/guliter/game/main/centOSbtlnmp.sh) 运行网络脚本



stty erase '^H' && read -p "请输入宝塔面板添加的MySQL数据库名：" mysqldatabase             定义变量

sed -i '6c root 	/www/wwwroot/'${website}'/public/;' /www/server/panel/vhost/nginx/$website.conf  正行替换与变量

sed -i "s/1314521/$mysqlpassword/g" /www/wwwroot/$website/conf/application.ini 关键字替换与变量

mv proxypool-linux-amd64-v0.6.0 proxypool &&chmod 755 ./proxypool  修改指定文件名称并赋予权限
