user=hyw-num
pass=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

if [ $# -eq 2 ];then
    commitname=$1
    remotename=$2
    cd ~/"$remotename" || return 
    git add .
    git commit -m "$commitname"
    git push "$remotename" main

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
else
    echo "wrong order"
fi



