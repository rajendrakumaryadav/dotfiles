require "nvchad.mappings"

local map = vim.keymap.set

-- Basics
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("i", "kj", "<ESC>", { desc = "Escape insert mode" })

-- Save / Quit
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>wqa<CR>", { desc = "Save all and quit" })
map("n", "<leader>u", ":nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Window split management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<C-w>c", { desc = "Close current split" })

-- File explorer (toggle instead of NvChad default focus)
map("n", "<leader>e", function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle file explorer" })
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Buffer management
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bD", ":bdelete!<CR>", { desc = "Force close buffer" })

-- File operations — shown as "File" group in NvCheatsheet (<leader>ch)
map("n", "<leader>fn", function()
  vim.ui.input({ prompt = "File create new file: " }, function(input)
    if input and input ~= "" then
      local dir = vim.fn.fnamemodify(input, ":h")
      if dir ~= "" and dir ~= "." and vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
      end
      vim.cmd("edit " .. vim.fn.fnameescape(input))
    end
  end)
end, { desc = "File create new file" })

map("n", "<leader>fN", "<cmd>enew<CR>", { desc = "File create new buffer" })

map("n", "<leader>fr", function()
  local old = vim.api.nvim_buf_get_name(0)
  if old == "" then
    vim.notify("No file to rename", vim.log.levels.WARN)
    return
  end
  vim.ui.input({ prompt = "File rename to: ", default = old }, function(new)
    if not new or new == "" or new == old then
      return
    end
    local dir = vim.fn.fnamemodify(new, ":h")
    if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
    vim.cmd("saveas " .. vim.fn.fnameescape(new))
    -- delete old file after saveas (ask)
    if vim.fn.filereadable(old) == 1 then
      local ok = vim.fn.confirm("Delete old file?\n" .. old, "&Yes\n&No", 2)
      if ok == 1 then
        vim.fn.delete(old)
      end
    end
    vim.notify("Renamed to " .. new, vim.log.levels.INFO)
  end)
end, { desc = "File rename file on disk" })

map("n", "<leader>fd", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file to delete", vim.log.levels.WARN)
    return
  end
  local choice = vim.fn.confirm("File delete: " .. file .. "?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.fn.delete(file)
    vim.cmd "bdelete!"
    vim.notify("Deleted " .. file, vim.log.levels.INFO)
  end
end, { desc = "File delete current file" })

map("n", "<leader>fy", function()
  local path = vim.fn.expand "%:p"
  if path == "" then
    vim.notify("No file", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", path)
  vim.notify("File yank path: " .. path, vim.log.levels.INFO)
end, { desc = "File copy path to clipboard" })

-- LSP rename grouped under File for cheatsheet (updates references via ty/ruff/pyright)
map("n", "<leader>fR", vim.lsp.buf.rename, { desc = "File rename symbol with references" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Move text up/down (visual)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Duplicate / delete line
map("n", "<leader>d", "yyP", { desc = "Duplicate line" })
map("n", "<leader>dd", '"_dd', { desc = "Delete line without yanking" })

-- Format buffer (conform.nvim)
map("n", "<leader>lf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Search navigation (centered)
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- Better habits
map("n", "Y", "y$", { desc = "Yank to end of line" })
map("n", "Q", "<cmd>qa<CR>", { desc = "Quit all" })

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic in float" })

-- TextMate-style Python runner (lua/utils/textmate_run.lua:1) — NvChad aligned
-- Uses floating overlay (chadrc.lua:80 style) closed with Esc/q, no split
map("n", "<leader>r", function()
  require("utils.textmate_run").run()
end, { desc = "TextMate Run line / function (float)" })
map("v", "<leader>r", function()
  require("utils.textmate_run").run_visual()
end, { desc = "TextMate Run selection (float)" })
-- Mac Cmd+R only on macOS (avoids hijacking <C-r> redo on Linux)
if vim.fn.has "mac" == 1 then
  map({ "n", "v" }, "<D-r>", function()
    local m = vim.fn.mode()
    if m:match "[vV]" then
      require("utils.textmate_run").run_visual()
    else
      require("utils.textmate_run").run()
    end
  end, { desc = "TextMate Run (Cmd+R)" })
end
-- Whole file (fixes "not loading all contents" — use when line needs imports)
map("n", "<leader>R", function()
  require("utils.textmate_run").run_file()
end, { desc = "TextMate Run whole file (float)" })