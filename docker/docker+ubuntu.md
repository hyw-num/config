## docker+ubuntu

### docker 镜像拉取

```
docker pull ubuntu
# 查看镜像版本
docker images
# 创建容器
docker run -it -d -p 2200:22 --name ubuntu -v /Users/hyw/Documents/workplace/ubuntu:/home/dev --privileged=true ubuntu /bin/bash 

# 安装基本工具
apt-get install vim
apt-get install net-tools
apt-get install tree
apt-get install iputils-ping
apt-get install openssh-server


```

### ssh启动

```
#查看ssh是否启动
ps -e | grep ssh
#修改配置文件
vim /etc/ssh/sshd_config
->PermitRootLogin yes

#启动
/etc/init.d/ssh start
#查看端口22
netstat-input | grep 22
#设置root密码
passwd root
（llllll）
```

### 安装g++

```
# 关掉代理
apt-get install mingw-w64
# 静态链接库文件
i686-w64-mingw32-g++(编译器在64位操作系统上构建32位应用程序)
x86-64-mingw32-g++(编译器在64位操作系统上构建64位应用程序)

cp x86_64-w64-mingw32-g++ g++
cp  x86_64-w64-mingw32-gcc gcc
#输入g++ -v
出现
```

### 安装cmake

```
apt-get install cmake
```

### 安装python

```
```

### 安装邮件工具

```
apt install sendemail
编辑脚本
vi sendemail.sh
#!/bin/bash
account='【你的QQ】@qq.com'
password='【授权码】'
to=$1
subject=$2
content=$3
sendemail -f $account -t $to -s smtp.qq.com:465 -u $subject  -xu $account -xp $password -m $content



-f 表示发送者的邮箱
-t 表示接收者的邮箱
-cc 表示抄送发给谁
-bcc 表示暗抄送给谁
-o message-content-type=html   邮件内容的格式,html表示它是html格式
-o message-charset=utf8        邮件内容编码
-s 表示SMTP服务器的域名或者ip
-u 表示邮件的主题
-xu 表示SMTP验证的用户名
-xp 表示SMTP验证的密码(注意,这个密码貌似有限制,例如我用d!5neyland就不能被正确识别)
-m 邮件的内容
-a 要发送的附件
执行命令

/home/sendemail.sh gosick79@126.com Challenge2020GCP-黄意雯-西工大-软工 "a" "黄意雯-西工大-软工.zip"
```

#### 安装

```
apt-get  install build-essential
apt-get install libfontconfig1
apt-get install manpages-dev
apt-get install software-properties-common

```

### 安装PPA

```
add-apt-repository ppa:ubuntu-toolchain-r/ppa -y

apt install gcc-9 g++-9

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 80

update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 100
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 80
update-alternatives --config gcc
```

