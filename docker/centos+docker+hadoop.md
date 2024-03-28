### 创建centos容器

运行docker容器

```shell
docker run -itd --name hadoop01 -p 2201:22 -p 8088:8088 -p 9000:9000 -p 50070:50070 --privileged=true centos:latest /sbin/init   E:/docker/spark:/home/hadoop
c64c3cd85c1a7a0774e548309949b526023e74d6f46ba16aa9e58a68dd3c6809

docker exec -it c6 /bin/bash

```

进入容器后，需要修改yum源（因为centos官方已经停止维护centos8了，所以需要换源）：

```shell
cd /etc/yum.repos.d
vi CentOS-Linux-BaseOS.repo
vi CentOS-Linux-AppStream.repo
```

CentOS-Linux-BaseOS.repo的内容修改为：

```xml
[baseos]
name=CentOS Linux $releasever - BaseOS
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=BaseOS&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/$releasever/BaseOS/$basearch/os/
baseurl=https://vault.centos.org/centos/$releasever/BaseOS/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
```

CentOS-Linux-AppStream.repo的内容修改为：

```xml
[appstream]
name=CentOS Linux $releasever - AppStream
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=AppStream&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/$releasever/AppStream/$basearch/os/
baseurl=https://vault.centos.org/centos/$releasever/AppStream/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
```

修改完成后就可以正常使用yum命令了，建议先下载一个vim，这样后续的文本编辑也会友善很多。

```shell
yum install -y vim
```

### 安装java环境

```shell
yum install java-1.8.0-openjdk.x86_64
vim /etc/bashrc
........................................................................
#jdk environment
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk-1.8.0.312.b07-2.el8_5.x86_64
export PATH=$JAVA_HOME/bin:$PATH
........................................................................
source /etc/bashrc
```

### 创建出两个相同容器

物理机：

导出容器到镜像

docker commit命令

```shell
docker commit hadoop01 mycentos
```

查看镜像列表：

```shell
docker images
```

![](https://pic4.zhimg.com/80/v2-36e79d71c42f296adbd084d1bced192f_720w.webp)

可以看到成功导出到镜像

然后使用该镜像再创建两个相同容器，这样就可以省去其他容器创建jdk的步骤。

```shell
docker run -itd --name hadoop02 -p 2202:22 -p 50090:50090 --privileged=true mycentos /sbin/init
docker run -itd --name hadoop03 -p 2203:22 --privileged=true mycentos /sbin/init

```

> 小贴士，因为容器创建后root@后面的主机名跟的是容器id,容器一多不好区分，可以使用hostnamectl或者hostname命令进行修改,如hostnamectl set-hostname hadoop01 或hostname hadoop01，运行后退出容器(ctrl+p+q)重新进入就会生效了

### 安装HADOOP

#### 1.服务器联通

安装hadoop需要保持服务器之间内网连通，而我们创建的三个容器：hadoop01、hadoop02、hadoop03；默认是放在bridge的网段的,默认是联通的，但是为了和其他不相关的容器区分开，建议还是创建一个新的网段让三台容器自己相连。

查看docker存在的网段：

```shell
docker network ls
```

创建一个新的网段，取名为bigdata

```shell
docker network create bigdata
```

将三台容器连入bigdata网段

```shell
docker network connect bigdata hadoop01
docker network connect bigdata hadoop02
docker network connect bigdata hadoop03
```

断开三台容器与bridge的连接

```shell
docker network disconnect bridge hadoop01
docker network disconnect bridge hadoop02
docker network disconnect bridge hadoop03
```

使用 docker network inspect bigdata 查看网段内的容器进行验证：

```shell
docker network inspect bigdata
```

如图所示：

![](https://pic4.zhimg.com/80/v2-e11765cd35ac989df5f1b3df79012593_720w.webp)

这样就成功创建了。

docker的centos8镜像是不带有防火墙的，所以可以省去关闭防火墙的步骤。

docker官方centos8镜像是不带有ssh以及默认密码的，为了安装同步方便，我们给三台容器分别安装ssh并指定密码:

```shell

docker exec -it c6 /bin/bash
docker exec -it 53 /bin/bash
docker exec -it b1 /bin/bash
yum -y install passwd openssh-server openssh-clients
systemctl status sshd
systemctl start sshd
systemctl enable sshd
ss -lnt
passwd root
llllll
#为root指定密码
```

安装完成后，为HADOOP01指定另外两台容器的hostname

```text
[root@hadoop01 /]# vim /etc/hosts
```

在文件后方加入每台容器ip及hostname，wq保存并退出

```shell
172.19.02 hadoop01
172.19.03 hadoop02
172.19.04 hadoop03
```

使用scp命令发给hadoop02及hadoop03容器

```shell
scp /etc/hosts hadoop02:/etc/
scp /etc/hosts hadoop03:/etc/
```

之后为每台容器配置免密登录

```shell
[root@hadoop01 /]# ssh-keygen -t rsa #之后一路回车
[root@hadoop01 ~]# cd /root/.ssh/
[root@hadoop01 ~]# ls
.  ..  id_rsa  id_rsa.pub  known_hosts
```

可以看到 id_rsa.pub为生成的公钥，id_rsa为私钥

每台容器生成之后，将容器1、2、3的密码相互发送

```shell
[root@hadoop01 .ssh]# ssh-copy-id hadoop02
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@hadoop02's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'hadoop02'"
and check to make sure that only the key(s) you wanted were added.
[root@hadoop01 .ssh]# ssh-copy-id hadoop03
[root@hadoop02 /]# ssh-copy-id hadoop01
[root@hadoop02 /]# ssh-copy-id hadoop03
[root@hadoop03 /]# ssh-copy-id hadoop01
[root@hadoop03 /]# ssh-copy-id hadoop02
```

#### 2.时间同步

此时三台容器可以互相免密登录，接下来进行容器间的时间同步

centos8取消了ntpd服务，使用chrony替代了ntpd的时间同步，为三台服务器下载chronyd：

```shell
yum -y install chrony
```

将hadoop01服务器设为时间同步主服务器，其余节点从hadoop01服务器同步时间

```shell
vim /etc/chrony.conf 

ADD
# Allow NTP client access from local network.
allow 172.19.0.4/16
# Serve time even if not synchronized to a time source.
local stratum 10
```

取消掉图中两行注释，前者代表允许该网段从本服务器同步时间，后者代表将本服务器作为时间同步主服务器

修改完成后，启动chrony服务

```text
[root@hadoop01 local]# systemctl status chronyd #查看服务状态
[root@hadoop01 local]# systemctl start chronyd #启动服务
[root@hadoop01 local]# systemctl enable chronyd #将服务设置为开机启动
```

然后在其余服务器修改时间同步来源服务器

```text
vim /etc/chrony.conf 
```

![](https://pic1.zhimg.com/80/v2-b6ada73cb72cd7ab0982cbccf2665c84_720w.webp)

注释掉原本的pool，修改为 server hadoop01 iburst

之后启动服务就OK了，这里分享几个chrony的命令

```text
查看时间同步源：
$ chronyc sources -v
查看时间同步源状态：
$ chronyc sourcestats -v
校准时间服务器：
$ chronyc tracking
```

#### 3.hadoop安装与环境变量配置

1.首先在容器外部将准备好的hadoop安装包上传至hadoop01容器

```shell
$ curl -OL https://archive.apache.org/dist/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
```

2.将文件解压至/usr/local/中并更名为hadoop

```shell
$ tar -zxvf hadoop-3.3.4.tar.gz -C /usr/local
$ cd /usr/local
$ mv hadoop-3.3.4/ hadoop/
```

3.配置HADOOP环境变量

```shell
$ vim /etc/profile
#下方加入
#HADOOP ENV
export HADOOP_HOME=/usr/local/hadoop
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
```

退出profile文件，初始化环境变量,然后验证安装结果

```shell
$ source /etc/profile
$ hadoop version
```

4.分发hadoop及环境变量

```shell
cd /usr/local/
scp -r hadoop/ hadoop02:$PWD
scp -r hadoop/ hadoop03:$PWD
scp /etc/profile hadoop02:/etc/
scp /etc/profile hadoop03:/etc/
```

最后别忘了初始化02和03服务器的环境变量

```text
source /etc/profile #在hadoop02上执行
source /etc/profile #在hadoop03上执行
```

至此，安装步骤告一段落
