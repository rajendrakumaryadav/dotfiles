require "nvchad.options"

local o = vim.o

o.number = true
o.relativenumber = true
o.cursorline = true
o.cursorlineopt = "both"
o.hlsearch = true
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8
o.clipboard = "unnamedplus"
o.mouse = "a"
o.splitright = true
o.splitbelow = true
o.termguicolors = true
o.background = "dark"
o.showmode = false
o.showcmd = true
o.cmdheight = 1
o.pumheight = 10
o.conceallevel = 0
o.encoding = "utf-8"
o.timeoutlen = 300
o.updatetime = 200
o.redrawtime = 1500
o.completeopt = "menu,menuone,noselect"
o.shortmess = "c"
o.whichwrap = "<>[]hl"
vim.opt.iskeyword:append("-")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.fillchars:append({
    horiz = "─",
    horizup = "┴",
    horizdown = "┬",
    vert = "│",
    vertleft = "┤",
    vertright = "├",
    verthoriz = "┼",
})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
})
