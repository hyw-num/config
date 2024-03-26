ipPath=~/config/info/ip/ip
toPath=$winRealHome/ip_$today
echo $Lan_ip > $ipPath 
~/config/ssh/myscp.sh $ipPath 608 $toPath
mv $winhome/ip_$today ~/config/info/ip/ 
