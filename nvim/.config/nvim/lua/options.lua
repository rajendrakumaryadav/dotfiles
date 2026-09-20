require "nvchad.options"

local o = vim.o

-- line numbers
o.number = true
o.relativenumber = true
o.cursorline = true
o.cursorlineopt = "both"
o.signcolumn = "yes"
o.numberwidth = 2

-- searching
o.hlsearch = true
o.ignorecase = true
o.smartcase = true
o.incsearch = true

-- editing
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8
o.mouse = "a"
o.splitright = true
o.splitbelow = true
o.showcmd = true
o.cmdheight = 1
o.pumheight = 10
o.conceallevel = 0
o.timeoutlen = 300
o.updatetime = 200
o.redrawtime = 1500
o.completeopt = "menu,menuone,noselect"
o.clipboard = "unnamedplus"
o.swapfile = false
o.undofile = true
o.encoding = "utf-8"
o.termguicolors = true
o.background = "dark"

-- tabs / indentation
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
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
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
    },
})