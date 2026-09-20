require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd("TextYankPost", {
    desc = "Highlight on yank",
    group = augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- Restore cursor position on file open
autocmd("BufReadPost", {
    desc = "Restore cursor position",
    group = augroup("restore_cursor", { clear = true }),
    callback = function()
        local line = vim.fn.line "'\""
        if line > 1 and line <= vim.fn.line "$" and vim.bo.filetype ~= "commit" then
            vim.cmd 'normal! g`"'
        end
    end,
})

-- Create parent directories when saving a new file
autocmd("BufWritePre", {
    desc = "Auto create parent dirs",
    group = augroup("auto_mkdir", { clear = true }),
    callback = function()
        local file = vim.fn.expand "<afile>"
        local dir = vim.fn.fnamemodify(file, ":h")
        if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- Close quickfix window with q
autocmd("FileType", {
    desc = "Quickfix q closes window",
    group = augroup("better_quickfix", { clear = true }),
    pattern = { "qf", "help" },
    callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
    end,
})

-- Highlight references of the symbol under the cursor (needs LSP attached)
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Enable lsp document highlight",
    group = augroup("lsp_document_highlight", { clear = true }),
    callback = function(args)
        if args.data and args.data.client_id then
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    buffer = args.buf,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    buffer = args.buf,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end
    end,
})