return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        keys = {
            { "<leader>lf", desc = "Format buffer" },
            { "<leader>fm", desc = "Format file" },
        },
        opts = require "configs.conform",
    },

    {
        "neovim/nvim-lspconfig",
        event = "User FilePost",
        config = function()
            require "configs.lspconfig"
        end,
    },
}