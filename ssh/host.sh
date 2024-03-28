
netsh interface portproxy delete v4tov4 listenport=2222 listenaddress=0.0.0.0
netsh advfirewall firewall delete rule name=WSL2
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=2222 connectaddress=$wsl connectport=2222
netsh interface portproxy show all
netsh advfirewall firewall add rule name=WSL2 dir=in action=allow protocol=TCP localport=2222
