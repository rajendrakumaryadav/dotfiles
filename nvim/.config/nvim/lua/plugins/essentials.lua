return {
    -- Toggle comments with gcc / gc
    {
        "numToStr/Comment.nvim",
        keys = { "gcc", "gbc", "gc", "gb" },
        config = function()
            require("Comment").setup()
        end,
    },

    -- Surround text with ys / cs / ds
    {
        "kylechui/nvim-surround",
        keys = {
            { "ys", mode = { "n", "v" } },
            { "yS", mode = { "n", "v" } },
            { "cs", mode = "n" },
            { "ds", mode = "n" },
        },
        opts = {},
    },

    -- Auto close / rename HTML, XML, JSX tags
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "html",
            "xml",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
        },
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    -- Highlight & jump TODO/FIXME/HACK comments
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "User FilePost",
        keys = {
            { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODO comments" },
        },
        opts = { signs = true },
    },

    -- Distraction-free writing mode
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = {
            { "<leader>uz", "<cmd>ZenMode<CR>", desc = "Toggle Zen mode" },
        },
        opts = {
            window = {
                backdrop = 0.95,
            },
        },
    },
}