source $sshPath/608wsl
function run(){
    order="$1"
    echo $order
    expect -c "
        spawn sudo  $order 
        expect {
        \"password for\" { send \"$passwd\r\" ; puts \"ok\" ; }
    }
    expect EOF 
"
}

run "service ssh start"
ps -ef | grep ssh
