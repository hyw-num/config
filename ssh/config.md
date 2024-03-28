### install and config
```shell
sudo apt-get update
sudo apt-get install openssh-server -y

sudo ps -e|grep ssh #查看是否启动
sudo service ssh start

#配置ssh service 允许远程root登录
sudo vi /etc/ssh/sshd_config
#注释掉PermitRootLogin without-password
#添加PermitRootLogin yes

#检查服务器状态
service ssh status

#允许ssh绕过防火墙
sudo ufw allow ssh
```
### 建立软连接
```shell
sudo ln -s ~/config/ssh/config/ssh_config /etc/ssh/ssh_config
sudo ln -s ~/config/ssh/config/sshd_config /etc/ssh/sshd_config
```
### 设置wsl端口转发
```shell
ifconfig

#查看ip地址
ifconfig

#将端口转发到wsl，在Power Shell下执行命令，将[IP]和[PORT]替换为wsl的IP和端口。
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=2222 connectaddress=wslIp connectport=wslPort
# 查看所有的转发规则
netsh interface portproxy show all
netsh interface portproxy delete v4tov4 listenport=2222 listenaddress=0.0.0.0
#开启防火墙入站规则（也可以在控制面板-Windows Defender 防火墙-高级设置-入站规则中设置）
netsh advfirewall firewall delete rule name=wsl2
netsh advfirewall firewall add rule name=WSL2 dir=in action=allow protocol=TCP localport=2222

##edit/etc/ssh/sshd_config
Port 2222
ListenAddress 0.0.0.0
PasswordAuthentication yes
PermitRootLogin yes


```
