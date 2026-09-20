return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "lua", "luadoc", "printf", "vim", "vimdoc",

                "html", "css", "javascript", "typescript",
                "tsx", "jsx", "json", "jsonc", "markdown",
                "markdown_inline", "yaml", "bash", "python",
                "go", "rust", "zig", "toml", "xml", "sql",
                "dockerfile", "comment", "diff", "gitcommit",
            },
        },
    },
}