return {
  -- mini.ai: better a/i textobjects (function, class, etc) + mini.move: move lines with Alt-hjkl
  {
    "echasnovski/mini.ai",
    event = "User FilePost",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 300,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ a = { "@block.outer", "@conditional.outer", "@loop.outer" }, i = { "@block.inner", "@conditional.inner", "@loop.inner" } }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
      }
    end,
  },
  {
    "echasnovski/mini.move",
    keys = {
      { "<M-h>", mode = { "n", "v" }, function() require("mini.move").move_left() end, desc = "Move left" },
      { "<M-j>", mode = { "n", "v" }, function() require("mini.move").move_down() end, desc = "Move down" },
      { "<M-k>", mode = { "n", "v" }, function() require("mini.move").move_up() end, desc = "Move up" },
      { "<M-l>", mode = { "n", "v" }, function() require("mini.move").move_right() end, desc = "Move right" },
    },
    opts = {
      mappings = {
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",
        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },
    },
  },

  -- correct commentstring for tsx/jsx/vue/svelte (with Comment.nvim you have)
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "User FilePost",
    opts = { enable_autocmd = false },
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)
      -- integrate with Comment.nvim if present
      local ok, comment = pcall(require, "Comment.utils")
      if ok then
        -- let Comment.nvim use ts_context_commentstring
        vim.g.skip_ts_context_commentstring_module = true
      end
    end,
  },

  -- treesitter textobjects: af/if, ac/ic, al/il + move ]f [f
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "User FilePost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- loaded via treesitter; no extra setup, just ensure enabled in treesitter opts
    end,
  },

  -- smarter s/S handled by flash; add dial for <C-a>/<C-x> increment booleans etc
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, desc = "Dial increment" },
      { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, desc = "Dial decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "Dial increment g" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "Dial decrement g" },
      { "<C-a>", mode = "v", function() require("dial.map").manipulate("increment", "visual") end, desc = "Dial inc visual" },
      { "<C-x>", mode = "v", function() require("dial.map").manipulate("decrement", "visual") end, desc = "Dial dec visual" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
          augend.constant.new({ elements = { "true", "false" }, word = true, cyclic = true }),
          augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true }),
        },
      })
    end,
  },

  -- ensure treesitter textobjects / context are active
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or require("nvchad.configs.treesitter")
      opts.textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        },
      }
      opts.context_commentstring = { enable = true, enable_autocmd = false }
      return opts
    end,
  },
}
