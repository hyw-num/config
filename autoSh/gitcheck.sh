if [ $# -eq 1 ];then
    remotename=$1
# order
    cd ~/"$remotename" || return 
    pwd
    git diff HEAD
else
    echo "wrong order"
fi



