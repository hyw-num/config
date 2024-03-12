### 网络配置
配置代理，不然大概率装不下来
clash 服务模式+混合代理配置
### 安装各种依赖
```shell
sudo apt install -y gcc wget iputils-ping python3-pip git bear tig shellcheck ripgrep

# 安装 neovim 的各种依赖 https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
sudo apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
```
### 安装nvim
```shell
git clone --depth=1 https://github.com/neovim/neovim && cd neovim
make CMAKE_BUILD_TYPE=Release -j8
sudo make install
```
### 安装nerdfonts
```shell
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hasklig.zip
unzip Hasklig.zip -d ~/.fonts
fc-cache -fv
```
### 安装bear
clangd 理解 C++ 代码，并向编辑器添加智能功能：代码完成、编译错误、转到定义等。
clangd是一个语言服务器，可以通过插件与许多编辑器一起使用。这是带有 clangd 插件的 Visual Studio Code，演示了代码完成：
clangd 需要通过 bear 生成的 "compile_commands.json" 来构建索引数据。
```shell
sudo apt install bear
```
### 安装各种 lsp
- 通过 mason 可以自动的安装各种 lsp， 在 neovim 中执行 :Mason 可以检查各种插件的执行状态。

- 对于 mason 不支持的 lsp，就需要手动安装了，例如 sudo apt install ccls

### 配置文件
在安装完成之后，如果 ~/.config/nvim 目录不存在，创建目录并新建 init.lua 文件
```shell
mkdir ~/.config/nvim
mkdir ~/.config/nvim/lua
touch ~/.config/nvim/init.lua
```


