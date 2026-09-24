return {
  -- Disable NvChad's nvim-cmp (replaced by blink.cmp)
  { "hrsh7th/nvim-cmp", enabled = false },
  { "saadparwaiz1/cmp_luasnip", enabled = false },
  { "hrsh7th/cmp-nvim-lua", enabled = false },
  { "hrsh7th/cmp-nvim-lsp", enabled = false },
  { "hrsh7th/cmp-buffer", enabled = false },
  { "https://codeberg.org/FelipeLema/cmp-async-path.git", enabled = false },

  -- Keep autopairs standalone (was dependency of nvim-cmp)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
    end,
  },

  -- Keep LuaSnip standalone (optional, blink can use it)
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = { history = true, updateevents = "TextChanged,TextChangedI" },
    config = function(_, opts)
      require("luasnip").config.set_config(opts)
      require "nvchad.configs.luasnip"
    end,
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    build = "cargo build --release",
    -- must be ready before LSP attaches (Nvim 0.11: User FilePost)
    -- lazy=false ensures get_lsp_capabilities() is available in configs/lspconfig.lua:1
    lazy = false,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-d>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        menu = {
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = { enabled = true },
        list = { selection = { preselect = true, auto_insert = false } },
      },

      snippets = { preset = "luasnip" },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = { score_offset = 0 },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },

      signature = { enabled = true },

      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        completion = {
          menu = { auto_show = true },
          ghost_text = { enabled = true },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
