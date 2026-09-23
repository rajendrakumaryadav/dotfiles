local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        -- ruff handles both formatting and import sorting (replaces black+isort), run via uv
        python = { "ruff_organize_imports", "ruff_format" },

        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        less = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        xml = { "prettierd", "prettier", stop_after_first = true },
        svg = { "prettierd", "prettier", stop_after_first = true },

        go = { "gofumpt", "goimports", "gofmt" },
        rust = { "rustfmt", "trim_whitespace", "injected" },
        zig = { "zigfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },

        dockerfile = { "hadolint" },
        ["docker-compose"] = { "yamlfmt" },
    },

    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

return options