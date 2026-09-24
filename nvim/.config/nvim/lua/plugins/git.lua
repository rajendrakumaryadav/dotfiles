return {
  -- diffview: :DiffviewOpen, :DiffviewFileHistory
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git diffview open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Git branch history" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Git diffview close" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = { merge_tool = { layout = "diff3_mixed" } },
    },
  },

  -- lazygit float (requires `lazygit` binary; fallback is no-op if missing)
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Lazygit" },
    },
    init = function()
      -- let lazygit.nvim know floating window style matches NvChad
      vim.g.lazygit_floating_window_scaling_factor = 0.9
    end,
    cond = function() return vim.fn.executable("lazygit") == 1 end,
  },

  -- neogit: magit-like (optional, no binary dep)
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit<CR>", desc = "Neogit" },
    },
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" },
    opts = {
      integrations = { diffview = true, telescope = true },
    },
  },
}
