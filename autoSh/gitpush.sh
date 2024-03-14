commitname=\'$1\'

remotename=$2
echo $commitname
cd ~/$remotename
git add .
git commit -m "$commitname"
git push $remotename main
