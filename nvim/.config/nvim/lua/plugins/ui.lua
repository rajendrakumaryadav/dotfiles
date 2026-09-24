return {
  -- diagnostics / quickfix / lsp references
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Trouble symbols" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble loclist" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble qflist" },
      { "gR", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Trouble LSP refs" },
    },
    opts = { focus = true },
  },

  -- better folds (LSP + treesitter)
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds" },
    },
    opts = {
      provider_selector = function(_, filetype, _)
        -- use treesitter/lsp for most, indent for fallback
        local ftMap = { vim = "indent", python = { "treesitter", "indent" }, lua = { "lsp", "indent" } }
        return ftMap[filetype] or { "treesitter", "indent" }
      end,
    },
    init = function()
      -- ufo needs these; set once (options.lua:6 side)
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },

  -- highlight other uses of word under cursor
  {
    "RRethy/vim-illuminate",
    event = "User FilePost",
    opts = { delay = 200, large_file_cutoff = 2000 },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- noice: cmdline / messages / lsp progress as popup (pairs with notify)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = { enabled = true },
        hover = { enabled = true },
        signature = { enabled = true },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        -- hide noisy messages
        { filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 900,
    opts = {
      stages = "fade_in_slide_out",
      timeout = 2500,
      render = "wrapped-compact",
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.45) end,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },

  -- undo tree ( <leader>u is clear hl in mappings.lua:14 )
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
      { "<leader>uu", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
    },
  },
}
