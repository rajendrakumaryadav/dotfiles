-- ~/.config/nvim/lua/configs/lspconfig.lua

local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

vim.lsp.config["lua_ls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

vim.lsp.config["pyright"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config["ts_ls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config["html"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config["cssls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config["gopls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config["rust_analyzer"] = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}

vim.lsp.config["zls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "html", "cssls", "gopls", "rust_analyzer", "zls" })