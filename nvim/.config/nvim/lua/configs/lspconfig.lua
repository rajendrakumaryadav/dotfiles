-- ~/.config/nvim/lua/configs/lspconfig.lua

-- This line is important to reuse NvChad's default LSP attachment function
local on_attach = require("nvchad.configs.lspconfig").on_attach
-- This line is important to reuse NvChad's default LSP capabilities
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- 1. Add the names of your language servers here
local servers = { "lua_ls", "pyright", "ts_ls", "html", "cssls", "gopls" }

-- 2. This loop sets up each server with your default settings
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- If you need custom settings for a specific server, you can do it here.
-- For example, for lua_ls to recognize Neovim globals:
lspconfig.lua_ls.setup {
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
