user=hyw-num
pass=token
if [ $# -eq 2 ];then
    commitname=$1
    remotename=$2
    cd ~/"$remotename" || return 
    git add .
    git commit -m "$commitname"
    git push "$remotename" main
    # expect ~/config/autoSh/gitpush.exp "$user" "$pass" "$remotename"
elif [ $# -eq 1 ];then
    remotename=$1
# order
    date=$(date +%Y_%m_%d)
    cd ~/"$remotename" || return 
    pwd
    echo "$date"
    git add .
    git commit -m "$date"
    git push "$remotename" main
    # expect ~/config/autoSh/gitpush.exp "$user" "$pass" "$remotename"
else
    echo "wrong order"
fi



