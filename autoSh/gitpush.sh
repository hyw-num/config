user=hyw-num
pass=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
if [ $# -eq 2 ];then
    commitname=$1
    remotename=$2
    cd ~/"$remotename" || return 
    git add .
    git commit -m "$commitname"
    expect ~/config/autoSh/gitpush.exp "$user" "$pass" "$remotename"
elif [ $# -eq 1 ];then
    remotename=$1
# order
    date=$(date +%Y_%m_%d)
    cd ~/"$remotename" || return 
    pwd
    echo "$date"
    git add .
    git commit -m "$date"
    expect ~/config/autoSh/gitpush.exp "$user" "$pass" "$remotename"
else
    echo "wrong order"
fi



