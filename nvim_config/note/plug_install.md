## plugins.lua
一个强大的 Nvim 离不开插件的支持。

### 安装插件管理器

> Packer.nvim 还支持了不少命令，不过你不需要把他们都记住。因为这个模板会自动帮我们处理好。值得一提的是如果因为网络问题安装失败的话，在它弹出的窗口里面按照提示按下大写的 R 就会自动重新下载。在 Packer.nvim 提示全都安装成功后，重启 Nvim 就生效了

@[code cpp]()
### 安装各种 lsp mason
通过 mason 可以自动的安装各种 lsp， 在 neovim 中执行 :Mason 可以检查各种插件的执行状态。

对于 mason 不支持的 lsp，就需要手动安装了，例如 sudo apt install ccls
