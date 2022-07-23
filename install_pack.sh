reds='\033[0;31m'
greens='\033[0;32m'
yellows='\033[0;33m'
plains='\033[0m'

error_detect_depends(){
    local command=$1
    local depend
    depend=$(echo "${command}" | awk '{print $4}')
    echo -e "[${greens}Info${plains}] 开始安装 ${depend}"
    ${command} > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "[${reds}Error${plains}] 安装失败 ${reds}${depend}${plains}"
        exit 1
    fi
}
        
install_dependencies(){        
        yum_depends=(
            unzip gzip socat dos2unix git net-tools curl
            gcc openldap-devel pam-devel openssl-devel
            gcc automake autoconf libtool make
        )
        for depend in ${yum_depends[@]}; do
            error_detect_depends "yum -y install ${depend}"
        done
} 
install_dependencies