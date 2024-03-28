### docker+hexo+Mac

```
//拉取
docker pull taskbjorn/hexo
//建立数据卷
docker volume create my_hexo_data
//建立容器
docker run -it --name my_hexo_container -p 4000:4000 -v hexo_data:/home/hexo/.hexo taskbjorn/hexo
```





```
docker exec my_hexo_container hexo <command>
//打开交互式命令
docker exec -it my_hexo_container sh
hexo generate
```

