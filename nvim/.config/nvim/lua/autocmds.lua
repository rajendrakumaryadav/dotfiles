vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight on yank",
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Better quickfix",
    group = vim.api.nvim_create_augroup("better_quickfix", { clear = true }),
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    desc = "Terminal settings",
    group = vim.api.nvim_create_augroup("terminal_settings", { clear = true }),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})
