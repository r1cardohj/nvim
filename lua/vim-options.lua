vim.cmd("set ai")
vim.cmd("set signcolumn=yes")
vim.cmd("set encoding=utf-8")
vim.cmd("set expandtab")
vim.cmd("set completeopt=longest,menu")
vim.cmd("set pumheight=10")
vim.cmd("set nu")
vim.cmd("set tabstop=2")
vim.cmd("set nocompatible")
vim.cmd("set nobackup")
vim.cmd("set nowritebackup")
vim.cmd("set shiftwidth=2")
vim.cmd("set hlsearch")
-- use system clipboard
vim.keymap.set("v", '<C-c>', "\"+y", {})
vim.g.mapleader = " "
vim.g.background = "dark"
