return {
  -- Keymap hints popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      preset = "modern",
      spec   = {
        { "<leader>f",  group = "Find / Telescope" },
        { "<leader>g",  group = "Git" },
        { "<leader>h",  group = "Git hunks" },
        { "<leader>c",  group = "Code" },
        { "<leader>b",  group = "Buffer" },
        { "<leader>d",  group = "Diagnostics" },
      },
    },
  },

  -- Nicer UI for vim.ui.select / vim.ui.input
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts  = {},
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main  = "ibl",
    opts  = {
      indent  = { char = "│" },
      scope   = { enabled = false },
      exclude = {
        filetypes = { "help", "lazy", "neo-tree", "Trouble", "toggleterm" },
      },
    },
  },

  -- Colour code highlighting (#fff, rgb(), etc.)
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      user_default_options = {
        tailwind = true, -- highlight Tailwind colour names too
      },
    },
  },
}
