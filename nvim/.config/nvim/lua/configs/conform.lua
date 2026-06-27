local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt", "trim_whitespace", "injected" },
        zig = { "zig_fmt" },
        -- css = { "prettier" },
        -- html = { "prettier" },
    },

    -- format_on_save = {
    --   -- These options will be passed to conform.format()
    --   timeout_ms = 500,
    --   lsp_fallback = true,
    -- },
}

return options
