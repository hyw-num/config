file=$1
sed -i -e "s/ip=*.*.*.*/ip=$2/"  $sshPath/$file

