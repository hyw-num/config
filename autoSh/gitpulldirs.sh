# core.sparsecheckout用于控制是否允许设置pull指定文件/夹，true为允许。
## 在.git/info/sparse-checkout文件中（如果没有则创建）添加指定的文件/夹
git config core.sparsecheckout true
echo "$1" >> .git/info/sparse-checkout
