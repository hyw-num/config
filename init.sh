cd ~/config || return
mkdir info
cd info || return 
git remote add info git@github.com:hyw-num/info.git
git pull info main
