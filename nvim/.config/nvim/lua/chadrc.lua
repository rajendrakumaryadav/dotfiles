-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "chocolate",
    theme_toggle = { "chocolate", "carbonfox" },

    hl_override = {
        Comment = { italic = true },
        ["@comment"] = { italic = true },
    },
    transparency = false,
}

M.ui = {
    cmp = { style = "flat_dark", icons_left = false },
    telescope = { style = "borderless" },
    statusline = {
        theme = "default",
        separator_style = "block",
    },
    tabufline = {
        enabled = true,
        lazyload = true,
    },
}

M.nvdash = {
    load_on_startup = true,
    header = {
        " ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║╚██╗ ██╔╝██║██╔████╔██║",
        " ██║╚██╗██║ ╚████╔╝ ██║██║╚██╔╝██║",
        " ██║ ╚████║  ╚██╔╝  ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝   ╚═╝   ╚═╝╚═╝     ╚═╝",
    },

    buttons = {
        { txt = "    Find File", keys = "ff", cmd = "Telescope find_files" },
        { txt = "  󰈚  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
        { txt = "  󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
        { txt = "  󰮤  File Explorer", keys = " e", cmd = "NvimTreeToggle" },
        { txt = "  󰣇  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
        { txt = "    Mappings", keys = "ch", cmd = "NvCheatsheet" },

        { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

        {
            txt = function()
                local stats = require("lazy").stats()
                local ms = math.floor(stats.startuptime) .. " ms"
                return "  󰢱 Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
            end,
            hl = "NvDashFooter",
            no_gap = true,
            content = "fit",
        },

        { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

        { txt = "  󰂺 use manual: :MasonInstallAll + :TSInstallAll", hl = "NvDashFooter", no_gap = true },
    },
}

M.term = {
    startinsert = true,
    base46_colors = true,
    winopts = { number = false, relativenumber = false },
    sizes = {
        sp = 0.3,
        vsp = 0.25,
        ["bo sp"] = 0.3,
        ["bo vsp"] = 0.25,
    },
    float = {
        relative = "editor",
        row = 0.25,
        col = 0.15,
        width = 0.7,
        height = 0.6,
        border = "single",
    },
}

M.lsp = { signature = true }

M.cheatsheet = {
    theme = "grid", -- simple/grid
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" },
}

-- packages installed by :MasonInstallAll (LSP servers, linters, formatters)
M.mason = {
    pkgs = {
        -- lsp servers
        "lua-language-server",
        "pyright",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "gopls",
        "rust-analyzer",
        "zls",
        "bash-language-server",
        "yaml-language-server",
        "marksman",
        "dockerfile-language-server",
        "docker-compose-language-service",

        -- formatters
        "stylua",
        "black",
        "isort",
        "prettierd",
        "shfmt",
        "goimports",
        "gofumpt",
        "yamlfmt",

        -- linters
        "eslint_d",
        "mypy",
        "shellcheck",
        "markdownlint",
        "hadolint",
    },
}

return M