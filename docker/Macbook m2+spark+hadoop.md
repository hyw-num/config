## Macbook (amd 内核)+spark+hadoop

### spark

#### 拉取框架

```shell
➜ docker pull bitnami/spark:3 --platform linux/amd64
```

#### 以集群方式运行

- ```volumes```：挂载本地目录```~/Documents/workplace/spark/share```到目录```/opt/share```
- ```compose.yml```文件

```yaml
version: '2'
services:
  spark:
    image: docker.io/bitnami/spark:3
    hostname: master
    environment:
      - SPARK_MODE=master
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/Documents/workplace/spark/share:/opt/share
    ports:
      - '8080:8080'
      - '4040:4040'
  spark-worker-1:
    image: docker.io/bitnami/spark:3
    hostname: worker1
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://master:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/Documents/workplace/spark/share:/opt/share
    ports:
      - '8081:8081'
  spark-worker-2:
    image: docker.io/bitnami/spark:3
    hostname: worker2
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://master:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/Documents/workplace/spark/share:/opt/share
    ports:
      - '8082:8081'


```

- 启动 Spark Docker 集群了。在工作目录下，执行如下命令：

```shell
➜ DOCKER_DEFAULT_PLATFORM=linux/amd64 docker-compose up -d
[+] Building 0.0s (0/0) docker:desktop-linux
[+] Running 3/3
   ✔ Container spark-spark-1           Started
   ✔ Container spark-spark-worker-1-1  Started
   ✔ Container spark-spark-worker-2-1  Started 
```

可通过映射的端口访问 Spark Web UI。集群以默认的 Standalone 独立集群模式启动，通过 http://localhost:8080/ 查看集群运行状态：

#### 集群网络

- 默认情况下，通过 `docker-compose` 启动的容器集群，会创建并使用名为 `镜像名_default` 的桥接网络，如 `spark_default`。集群内的容器处于同一子网网段，因此可以相互通信。

```shell
➜ docker network ls
NETWORK ID     NAME            DRIVER    SCOPE
a66de955d10c   bridge          bridge    local
3bd8c5b40429   host            host      local
590920cb78f3   none            null      local
9a611fd0d10b   spark_default   bridge    local
```

- 通过 `inspect` 命令查看网络配置详情。以下是 `spark_default` 网络部分配置信息，其使用 `172.18.0.0/16` 子网网段，并为每个容器实例分配了 IPv4 地址。

```shell
➜ docker network inspect 9a
[
    {
        "Name": "spark_default",
        "Id": "9a611fd0d10b3381dbcfe84925442646db90b57db593750dab47cf4f566d5a7f",
        "Created": "2023-12-05T03:28:27.358198425Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.20.0.0/16",
                    "Gateway": "172.20.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "c4c6222cea857316d8f13c38d787cc685d344069eb8967de7bc9e1e9f1a45157": {
                "Name": "spark-spark-worker-1-1",
                "EndpointID": "ab44a4170e4dee734565f367b1987fc7cd9936903e3dc2578c11c6ffd93f67ad",
                "MacAddress": "02:42:ac:14:00:04",
                "IPv4Address": "172.20.0.4/16",
                "IPv6Address": ""
            },
            "d2307d1bc434597d45f80eacd1fcccac92ac11bf4890170ac42cf836666c6783": {
                "Name": "spark-spark-worker-2-1",
                "EndpointID": "7ebc4fdb819c115fc1ba2ecc45ffe24a45be1a9dbca06ba6ef312e2e1d257cfa",
                "MacAddress": "02:42:ac:14:00:03",
                "IPv4Address": "172.20.0.3/16",
                "IPv6Address": ""
            },
            "da2a9f7bbb2b2f7831e108714937ac7190ec9a3e3facfae6c9fb9260d88e4abd": {
                "Name": "spark-spark-1",
                "EndpointID": "dbdf9f240bf055f151421b3f49cd0d77235fe2f22f654673738ce098a7d3e016",
                "MacAddress": "02:42:ac:14:00:02",
                "IPv4Address": "172.20.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {
            "com.docker.compose.network": "default",
            "com.docker.compose.project": "spark",
            "com.docker.compose.version": "2.23.0"
        }
    }
]
```

#### 使用 Spark Shell 进行交互

- 查看正在运行的容器实例，找到 master 实例的容器 ID：da2a9f7bbb2b。


```shell
➜  ~ docker ps                
CONTAINER ID   IMAGE             COMMAND                   CREATED       STATUS       PORTS                                            NAMES
d2307d1bc434   bitnami/spark:3   "/opt/bitnami/script…"   3 hours ago   Up 3 hours   0.0.0.0:8082->8081/tcp                           spark-spark-worker-2-1
c4c6222cea85   bitnami/spark:3   "/opt/bitnami/script…"   3 hours ago   Up 3 hours   0.0.0.0:8081->8081/tcp                           spark-spark-worker-1-1
da2a9f7bbb2b   bitnami/spark:3   "/opt/bitnami/script…"   3 hours ago   Up 3 hours   0.0.0.0:4040->4040/tcp, 0.0.0.0:8080->8080/tcp   spark-spark-1                                                                                                                     spark-spark-worker-2-1
```

- 执行如下命令进入到 master 容器内部。


```shell
➜ docker exec -it da bash
I have no name!@master:/opt/bitnami/spark$
```

注：实际上 `-it` 参数的作用是分配一个交互式虚拟终端；容器 ID 的前两位可以唯一标识该容器，如 a1。

现在，可以通过 `pyspark` 或 `spark-shell` 命令启动 Spark 交互式命令行，下面以 `pyspark` 为例：

- 现在，可以通过 `pyspark` 或 `spark-shell` 命令启动 Spark 交互式命令行，下面以 `pyspark` 为例：

```shell
$ pyspark
Python 3.8.13 (default, May  5 2022, 12:51:09) 
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
23/12/05 06:56:56 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.3.0
      /_/

Using Python version 3.8.13 (default, May  5 2022 12:51:09)
Spark context Web UI available at http://master:4040
Spark context available as 'sc' (master = local[*], app id = local-1701759417687).
SparkSession available as 'spark'.
```

- 在启动交互式 Shell 时，**Spark 驱动器程序（Driver Program）会创建一个名为 sc 的 SparkContext 对象，我们可以通过该对象来创建 RDD**。例如，通过 `sc.textFile()` 方法读取本地或 HDFS 文件，或者通过 `sc.parallelize()` 方法直接由 Python 集合创建 RDD。

```shell
>>> lines = sc.textFile('README.md')
>>> lines.count()
108                                   
>>> lines.filter(lambda line: len(line) > 10)
PythonRDD[3] at RDD at PythonRDD.scala:53
>>> lines.filter(lambda line: len(line) > 10).count()
67
>>> strs = sc.parallelize(['hello world', 'i am spark', 'hadoop'])
>>> strs.flatMap(lambda s: s.split(' ')).collect()
['hello', 'world', 'i', 'am', 'spark', 'hadoop']
>>> strs.flatMap(lambda s: s.split(' ')).reduce(lambda x, y: x + '-' + y)
'hello-world-i-am-spark-hadoop'
```

#### 使用 spark-submit 提交独立应用

Spark Shell 支持与存储在硬盘或内存上的分布式数据进行交互，如 HDFS。因此 Spark Shell 适用于即时数据分析，比如数据探索阶段。但我们的最终目的是创建一个独立的 Java、Scala 或 Python 应用，将其提交到 Spark 集群上运行。

Spark 为各种集群管理器提供了统一的工具来提交作业，这个工具就是 `spark-submit`

#### 未完待续

### hadoop

#### 安装hadoop

- 确定hadoop版本

```shell
$ pyspark
>>> sc._gateway.jvm.org.apache.hadoop.util.VersionInfo.getVersion()
'3.3.2'
```

在 Hadoop 官网找到 Hadoop 3.3.2 安装包的[下载地址](https://link.zhihu.com/?target=https%3A//hadoop.apache.org/release/3.3.2.html)，稍后在构建镜像时通过 `curl -OL` 命令下载此安装包。

#### 准备配置文件及启动脚本

在工作目录下创建 config 文件夹，编写需要覆盖的 Hadoop 配置文件。完整的配置文件已经上传至 GitHub：[hyw/spark-hadoop-docker](https://link.zhihu.com/?target=https%3A//github.com/hyw/spark-hadoop-docker)。

```text
➜ tree ~/docker/spark/config
config
├── core-site.xml
├── hadoop-env.sh
├── hdfs-site.xml
├── mapred-site.xml
├── workers
└── yarn-site.xml
```

注：其他详细配置请参考 Apache Hadoop 官方文档：[Hadoop Cluster Setup](https://link.zhihu.com/?target=https%3A//hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/ClusterSetup.html)。另外，经评论区同学 zing 提醒，Hadoop 3.x 之后，配置文件的 slaves 已更名为 workers。官方文档原文为：“Slaves File - List all worker hostnames or IP addresses in your etc/hadoop/workers file, one per line.”

除了配置文件外，还需要编写 Hadoop 启动脚本。由于设置了 ssh 免密通信，首先需要启动 ssh 服务，然后依次启动 HDFS 和 YARN 集群。

#### 基于 bitnami/spark 构建新镜像

在工作目录下，创建用于构建新镜像的 Dockerfile。新镜像基于 `docker.io/bitnami/spark:3`，依次执行如下指令：

- 设置 Hadoop 环境变量；
- 配置集群间 ssh 免密通信。此处直接将 ssh-keygen 工具生成的公钥写入 authorized_keys 文件中，由于容器集群基于同一个镜像创建的，因此集群的公钥都相同且 authorized_keys 为自己本身；
- 下载 Hadoop 3.3.2 安装包并解压；
- 创建 HDFS NameNode 和 DataNode 工作目录；
- 覆盖 `$HADOOP_CONF_DIR` 目录下的 Hadoop 配置文件；
- 拷贝 Hadoop 启动脚本并设置为可执行文件；
- 格式化 HDFS 文件系统。

```shell
FROM docker.io/bitnami/spark:3
LABEL maintainer="lishu2 <gosick79@126.com>"
LABEL description="Docker image with Spark (3.3.0) and Hadoop (3.3.2), based on bitnami/spark:3. \
For more information, please visit https://github.com/hyw/spark-hadoop-docker."

USER root

ENV HADOOP_HOME="/opt/hadoop"
ENV HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"
ENV HADOOP_LOG_DIR="/var/log/hadoop"
ENV PATH="$HADOOP_HOME/hadoop/sbin:$HADOOP_HOME/bin:$PATH"

WORKDIR /opt

RUN apt-get update && apt-get install -y openssh-server

RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

RUN curl -OL https://archive.apache.org/dist/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz
RUN tar -xzvf hadoop-3.3.2.tar.gz && \
  mv hadoop-3.3.2 hadoop && \
  rm -rf hadoop-3.3.2.tar.gz && \
  mkdir /var/log/hadoop

RUN mkdir -p /root/hdfs/namenode && \ 
    mkdir -p /root/hdfs/datanode 

COPY config/* /tmp/

RUN mv /tmp/ssh_config /root/.ssh/config && \
    mv /tmp/hadoop-env.sh $HADOOP_CONF_DIR/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_CONF_DIR/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml && \
    mv /tmp/workers $HADOOP_CONF_DIR/workers

COPY start-hadoop.sh /opt/start-hadoop.sh

RUN chmod +x /opt/start-hadoop.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

RUN hdfs namenode -format

ENTRYPOINT [ "/opt/bitnami/scripts/spark/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spark/run.sh" ]
```

在工作目录下，执行如下命令构建镜像：

```shell
➜ docker build -t hyw/spark-hadoop:3 .
```

#### 启动 spark-hadoop 集群

构建镜像完成后，还需要修改 `docker-compose.yml` 文件，使其从新的镜像 `hyw/spark-hadoop:3` 中启动容器集群，同时映射 Hadoop Web UI 端口。

```shell
version: '2'

services:
  spark:
    image: hyw/spark-hadoop:3
    hostname: master
    environment:
      - SPARK_MODE=master
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/Documents/workplace/spark/share:/opt/share
    ports:
      - '8080:8080'
      - '4040:4040'
      - '8088:8088'
      - '8042:8042'
      - '9870:9870'
      - '19888:19888'
  spark-worker-1:
    image: hyw/spark-hadoop:3
    hostname: worker1
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://master:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/Documents/workplace/spark/share:/opt/share
    ports:
      - '8081:8081'
  spark-worker-2:
    image: hyw/spark-hadoop:3
    hostname: worker2
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://master:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/Documents/workplace/spark/share:/opt/share
    ports:
      - '8082:8081'
```

运行 `docker-compose` 启动命令重建集群，不需要停止或删除旧集群。

```shell
➜ DOCKER_DEFAULT_PLATFORM=linux/amd64 docker-compose up -d                   
[+] Running 0/3
 ⠼ Container spark-spark-1           Recreate                                        6.4s
 ⠼ Container spark-spark-worker-2-1  Recreate                                        6.4s
 ⠼ Container spark-spark-worker-1-1  Recreate                                        6.4s
```

启动容器集群后，进入 master 容器执行启动脚本：

```shell
➜ docker ps 
CONTAINER ID   IMAGE                COMMAND                   CREATED         STATUS         PORTS                                                                                                                                              NAMES
bdb428eda207   hyw/spark-hadoop:3   "/opt/bitnami/script…"   2 minutes ago   Up 2 minutes   0.0.0.0:8081->8081/tcp                                                                                                                             spark-spark-worker-1-1
8b12964ee5b8   hyw/spark-hadoop:3   "/opt/bitnami/script…"   2 minutes ago   Up 2 minutes   0.0.0.0:4040->4040/tcp, 0.0.0.0:8042->8042/tcp, 0.0.0.0:8080->8080/tcp, 0.0.0.0:8088->8088/tcp, 0.0.0.0:9870->9870/tcp, 0.0.0.0:19888->19888/tcp   spark-spark-1
a6ace0200dee   hyw/spark-hadoop:3   "/opt/bitnami/script…"   2 minutes ago   Up 2 minutes   0.0.0.0:8082->8081/tcp                                                                                                                             spark-spark-worker-2-1
➜ docker exec -it 8b bash
$ ./start-hadoop.sh 
Starting OpenBSD Secure Shell server: sshd.
Starting namenodes on [master]
Starting secondary namenodes [master]
Starting resourcemanager
Starting nodemanagers
```

### Web UI 汇总

|         Web UI         |           ip            |                           Content                            |
| :--------------------: | :---------------------: | :----------------------------------------------------------: |
|  * Spark Application   | http://localhost:4040/  | 由 SparkContext 启动，显示以本地或 Standalone 模式运行的 Spark 应用 |
| Spark Standalone Maste | http://localhost:8080/  |     显示集群状态，以及以 Standalone 模式提交的Spark 应用     |
|    * HDFS NameNode     | http://localhost:9870/  |                     可浏览 HDFS 文件系统                     |
| * YARN ResourceManager | http://localhost:8088/  |                显示提交到 YARN上的 Spark 应用                |
|    YARN NodeManager    | http://localhost:8042/  |               显示工作节点配置信息和运行时日志               |
| MapReduce Job History  | http://localhost:19888/ |                      MapReduce 历史任务                      |

