## `plugins.lua`
> 一个强大的 Nvim 离不开插件的支持。
参考来自@[Martinlwx'github](https://github.com/MartinLwx/dotfiles.git)
### 安装插件管理器
#### 下载`lazy.nvim`
添加到 `plugins.lua`
```lua
-- 下载lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
```
#### 添加`lazy.nvim`到`init.lua`
```lua
require("lazy").setup(plugins, opts)
```

#### lazy 语法
- `plugins`: this should be a table or a string
    - `table`: a list with your Plugin Spec
    - `string`: a Lua module name that contains your Plugin Spec. See Structuring Your Plugins
- `opts`: see Configuration (optional)

``` lua
-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

require("lazy").setup({
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
})
```

#### 加载各类插件

brew install yarn

