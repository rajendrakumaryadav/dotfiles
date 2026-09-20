require("nvchad.configs.lspconfig").defaults()

-- Extra LSP keymaps on top of NvChad defaults (gd, gD, <leader>ra, etc.)
local map = vim.keymap.set

local function add_extra_keymaps(_, bufnr)
    local opts = { buffer = bufnr }

    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP references" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP hover doc" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP code action" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP rename" }))
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("extra_lsp_keymaps", { clear = true }),
    callback = add_extra_keymaps,
})

local servers = {
    "lua_ls",
    "pyright",
    "ts_ls",
    "html",
    "cssls",
    "jsonls",
    "bashls",
    "yamlls",
    "gopls",
    "rust_analyzer",
    "zls",
    "marksman",
    "dockerls",
    "docker_compose_language_service",
}

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

vim.lsp.config("pyright", {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
            },
        },
    },
})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            diagnostics = {
                enable = true,
            },
        },
    },
})

vim.lsp.config("gopls", {
    settings = {
        gopls = {
            usePlaceholders = true,
            staticcheck = true,
        },
    },
})

vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            validate = true,
            format = { enable = true },
        },
    },
})

vim.lsp.enable(servers)