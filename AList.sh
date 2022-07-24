function redbg(){
    echo -e "\033[37;41m\033[01m $1 \033[0m"
}

docker run -d --restart=always -v /root/data/docker_data/alist:/opt/alist/data -p 5244:5244 --name="alist" xhofe/alist:latest  #可以自己保存下来，比如创建一个config.txt的文件，把这条代码复制进去保存，下次换服务器搬家之类的就很容易。
clear
pass=$(docker exec -it alist ./alist -password)
clear
redbg "【AList 网盘】-默认面板:http://$ip:5244 $pass"
redbg "【AList 网盘文档：】https://alist-doc.nn.ci/docs/intro"
echo