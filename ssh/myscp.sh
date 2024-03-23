if [ $# -eq 4 ]
then 
    a=$1 
    path_a=$2
    source $sshPath/$a
    ip_a=$ip
    usr_a=$usr
    passwd_a=$passwd
    
    b=$3
    path_b=$4
    source $sshPath/$b
    ip_b=$ip
    usr_b=$usr
    passwd_b=$passwd
    
    echo "scp $usr_a@$ip_a:$path_a $usr_b@$ip_b:$path_b"
else
    echo "wrong"
fi
