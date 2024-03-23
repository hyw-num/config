#!/usr/bin/bash
echo "$sshPath/$1"
source "$sshPath/$1"
if [ -v port ]
then
    expect -c "
        spawn ssh -p $port $usr@$ip
        expect {
            \"yes/no*\" { send \"yes\r\" ; exp_continue }    
            \"$usr@$ip's password:\" { send \"$passwd\r\" }

        }
        expect EOF
"
else
    expect -c " 
        spawn ssh $usr@$ip
        expect {
            \"yes/no*\" { send \"yes\r\"; exp_continue }    
            \"$usr@$ip's password:\" { send \"$passwd\r\" ;  }
        }
        expect EOF
"
fi
