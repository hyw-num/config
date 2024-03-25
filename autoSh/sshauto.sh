source $sshPath/608wsl
expect -c "
    spawn sudo service ssh start
    expect {
    \"password for\" { send \"$passwd\r\" ; }
    \"Starting OpenBSD Secure Shell server sshd\" { }
}

    spawn sudo service ssh status
    expect {
    \"password for\" { send \"$passwd\r\" ; }
    \"Starting OpenBSD Secure Shell server sshd\" { }
}

expect EOF 
"
