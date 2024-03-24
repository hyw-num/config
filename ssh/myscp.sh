localpath=~/tmp
if [ $# -eq 4 ];
then 
    a=$1 
    path_a=$2
    source $sshPath/$a
    ip_a=$ip
    usr_a=$usr
    passwd_a=$passwd
    
    filename=$(basename $path_a)
    b=$3
    path_b=$4
    source $sshPath/$b
    ip_b=$ip
    usr_b=$usr
    passwd_b=$passwd
    

    echo "scp -r $usr_a@$ip_a:$path_a $localpath"
    expect -c "        
    spawn scp $usr_a@$ip_a:$path_a $localpath
    expect {
            \"yes/no*\" { send \"yes\r\" ; exp_continue }  
            \"$usr_a@$ip_a's password:\" { send \"$passwd_a\r\" ;}

        }
        expect EOF
"
    echo "scp -r $localpath/$filename $usr_b@$ip_b:$path_b"
    expect -c "        
    spawn scp $localpath/$filename $usr_b@$ip_b:$path_b    
    expect {
            \"yes/no*\" { send \"yes\r\" ; exp_continue }  
            \"$usr_b@$ip_b's password:\" { send \"$passwd_b\r\" }

        }
        expect EOF
"
elif [ $# -eq 3 ];
then
    first=$1
    if [ ! -d $first ] && [ ! -f $first ] ;
    then  
        localpath=$3
        remotePath=$2
        a=$1
        source $sshPath/$a
        echo "scp -r $usr@$ip:$remotePath $localpath"
        expect -c "        
        spawn scp -r $usr@$ip:$remotePath $localpath   
        expect {
            \"yes/no*\" { send \"yes\r\" ; exp_continue }  
            \"$usr@$ip's password:\" { send \"$passwd\r\" }

        }
        expect EOF
"    

    else
        localpath=$1
        remotePath=$3
        a=$2
        source $sshPath/$a

        echo $usr 
        echo "scp -r $localpath $usr@$ip:$remotePath"
        expect -c "        
        spawn scp -r $localpath $usr@$ip:$remotePath    
        expect {
            \"yes/no*\" { send \"yes\r\" ; exp_continue }  
            \"$usr@$ip's password:\" { send \"$passwd\r\" }

        }
        expect EOF
"    
    fi
else
    echo "wrong"
fi
