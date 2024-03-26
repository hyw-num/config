#!/bin/bash
if [ $# -eq 4 ]
then 
    source ~/config/info/email/$1
    account=$user@$suffix
    key=$key
    to=$2
    if [ -f ~/config/info/email/$2 ] 
    then
        to=$(source  ~/config/info/email/$2 && echo $user@$suffix)
    fi
    subject=$3
    content=$4
    sendemail -f $account -t $to -s $smtp -u $subject  -xu $account -xp $key -m $content
elif [ $# -eq 5 ] 
then
    source ~/config/info/email/$1
    account=$user@$suffix
    key=$key
    to=$2
    if [ -f ~/config/info/email/$2 ] 
    then
        to=$(source  ~/config/info/email/$2 && echo $user@$suffix)
    fi
    subject=$3
    content=$4
    file=$5
    sendemail -f $account -t $to -s $smtp -u $subject  -xu $account -xp $key -m $content -a $file

fi
