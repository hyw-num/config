source $sshPath/608wsl
function run(){
    order="$1"
    echo $order
    expect -c "
        spawn sudo  $order 
        expect {
        \"password for\" { send \"$passwd\r\" ; puts \"ok\" ;  exp_continue }
        \"Starting OpenBSD Secure Shell server sshd\" { }
    }
    expect EOF 
"
}

run "sudo service ssh start"
