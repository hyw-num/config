ipPath=~/config/info/ip/ip
toPath=$winRealHome/
LanIp=$(curl ip.sb)
echo "$LanIp" > $ipPath 
~/config/ssh/myscp.sh $ipPath 608 $toPath
mv $winhome/ip ~/config/info/ip/ip_$today
