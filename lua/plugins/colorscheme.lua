return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,   -- load before all other plugins
    lazy     = false,  -- must load at startup
    opts = {
      flavour               = "mocha",
      transparent_background = true,
      integrations = {
        treesitter = true,
        gitsigns   = true,
        telescope  = { enabled = true },
        which_key  = true,
        native_lsp = {
          enabled    = true,
          underlines = {
            errors      = { "underline" },
            hints       = { "underline" },
            warnings    = { "underline" },
            information = { "underline" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
