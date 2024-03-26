~/config/ssh/myssh.sh 608  "powershell chcp 65001; ipconfig   | findstr "IPv4"   | findstr /V "$HostIp""  | grep "IPv4 Address" |  awk -F ': ' '{print $2}'
