require "nvchad.mappings"

local map = vim.keymap.set

-- Basics
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("i", "kj", "<ESC>", { desc = "Escape insert mode" })

-- Save / Quit
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })
map("n", "<leader>/", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window split management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<C-w>c", { desc = "Close current split" })

-- File explorer (override NvChad default so <leader>e toggles instead of only focusing)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Buffer management
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bD", ":bdelete!<CR>", { desc = "Force close buffer" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Move text up/down (visual)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Duplicate line
map("n", "<leader>d", "yyP", { desc = "Duplicate line" })

-- Format buffer (conform.nvim)
map("n", "<leader>lf", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Search navigation (centered)
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
