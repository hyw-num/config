### $\textbf{docker}$配置

```
docker pull centos:7
docker images
docker run -d -p 2200:22  -p 8000:8000 -p 8001:8001 -p 8002:8002 --name centos7_arm -v /Users/huangyiwen/Documents/workplace:/home/dev --privileged=true c9a1fdca3387 /usr/sbin/init
```

```
ls


ls
ssh//此时无
#下载
yum search openssl
yum install openssl-devel.aarch64 -y 
yum search openssh
yum install openssh-server.aarch64 -y
#更换生成ssh密钥


ssh
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
//ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
#成功启动
/usr/sbin/sshd
#查看进程 
ps -aux |grep ssh

passwd root
#密码 ：llllll(小写L)
```

### 配置插件$\textbf{Remote-SSH}$文件

```\
Host Centos_loc
    HostName 127.0.0.1
    port 2200#根据映射的端口
    User root
```

### 进入挂载的目录

```
/home/dev
```

### 安装编译器

 ```
 yum search gcc
 yum install gcc-c++.aarch64 -y
 gcc -v
 ```

### 其他环境配置

#### python和gcc管理版本

```
yum -y install wget
wget https://www.python.org/ftp/python/3.8.6/Python-3.8.6.tar.xz
mkdir /usr/local/python3 
mv Python-3.8.6.tar.xz /usr/local/python3

tar -xvJf  /usr/local/python3/Python-3.8.6.tar.xz

./Python-3.8.6/configure --prefix=/usr/local/python3
make
make install

#管理gcc版本的东东
sudo yum install centos-release-scl scl-utils-build
yum search devtoolset # 搜索 GCC
sudo yum install devtoolset-7-aarch64 # 安装 GCC7
scl enable devtoolset-7 bash# 启用 GCC7 但是只对本次有效
#通过 SCL 安装的 GCC 放在 /opt/rh 目录下，我们可以发现之前启用 GCC7 的 enable 实际上是安装目录下的一个脚本，所以假如你想把 GCC7 当作是你的默认 GCC，那么可以修改你的 SHELL 配置文件，比如我用的是 zsh，则可以在 .zshrc 中加上 source /opt/rh/devtoolset-/enable
mv /usr/bin/gcc /usr/bin/gcc-4.8.5
mv /usr/bin/g++ /usr/bin/g++-4.8.5

ln -s /opt/rh/devtoolset-8/root/bin/gcc /usr/bin/gcc
ln -s /opt/rh/devtoolset-8/root/bin/g++ /usr/bin/g++
gcc --version
g++ --version

```

#### Git 代理



#### LLVM安装

```
# 下载源码
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
git checkout remotes/origin/release/9.x
# 安装一些依赖
sudo yum install ncurses-devel.x86_64 libedit.x86_64 libedit-devel.x86_6
# 
```

#### cmake安装

```
wget https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz    
tar -xzvf cmake-3.6.2.tar.gz 
cd cmake-3.6.2/
./bootstrap
make -j8 
make install
/usr/local/bin/cmake --version


yum remove cmake -y
# 下面这句可以不做，自然会去/usr/local/bin中找
ln -s /usr/local/bin/cmake /usr/bin/
cmake --version

```

#### sshd 开机自启动

```
#建立文件/root/start_ssh.sh文件内容如下

LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$LOGTIME] startup run..." >>/root/start_ssh.log
/usr/sbin/sshd
#service mysql start >>/root/star_mysql.log   //~E~V~\~M~J~_~O~Y~H~^~N



# 在/root/.bashrc中添加以下内容startup run
if [ -f /root/start_ssh.sh ]; then
      ./root/start_ssh.sh
fi
```

