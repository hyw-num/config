echo $(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ") # 获取ip地址

