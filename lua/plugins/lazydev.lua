-- lazydev.nvim: supercharges lua_ls for Neovim config editing
-- Provides completions for vim.*, vim.api.*, vim.lsp.*, etc.
return {
  {
    "folke/lazydev.nvim",
    ft   = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
