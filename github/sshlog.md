## 
```shell
cd ~
ssh-keygen -t ed25519 -C "gosick79@126.com"
# -C后面的是自定义的密钥注释/标签，这里一般输入自己的邮箱
# -----------------------------------------------
# 运行上述命令，会询问你是否自定义密钥名字/路径，以及是否需要给该密钥添加密码，敲回车是跳过
# Generating public/private ed25519 key pair.
# Enter file in which to save the key (/home/xxx/.ssh/id_ed25519): github_auth
# Enter passphrase (empty for no passphrase): 
# Enter same passphrase again: 
# Your identification has been saved in github_auth.
# Your public key has been saved in github_auth.pub.
# The key fingerprint is: xxx
# The key's randomart image is: xxx
# -----------------------------------------------
# ed25519是目前最安全、加解密速度最快的key类型。
# 但有些旧版本的SSH还不支持ed25519算法，这时候可以用rsa算法。
# 因此，有ed25519就用ed25519，没有就用rsa
ssh-keygen -t rsa -b 4096 -C "gosick79@126,com"
```
一路回车就好

## 添加密钥到ssh-agent/如果自己改了路径否则不用做
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_auth
```
## 添加密钥到Github账户
生成SSH密钥后，复制公钥内容到自己的Github账户中。具体地，点击Github右上角账户图标→Settings→SSH and GPG keys→New SSH key，在Key一栏粘贴公钥内容，在Title一栏设定这个SSH密钥的标识：
```shell
cat ~/.ssh/id_ed25519.pub | xsel -b 
```
## 查看结果
```shell
ssh -T git@github.com
# 如果输出以下内容，则表示配置成功，此时即可直接进行任何git操作。
# Hi xxx! You've successfully authenticated, but GitHub does not provide shell access.
```
