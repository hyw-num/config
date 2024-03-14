# variable
commitname=\'$1\'
remotename=$2



# order
cd ~/$remotename
git add .
git commit -m "$commitname"
git push $remotename main
