-- lua_ls — Lua LSP (lua-language-server)
-- vim.lsp.enable("lua_ls") is called from lua/config/lsp.lua
-- This file MUST return a table.
return {
  cmd       = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT", -- Neovim uses LuaJIT
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Include lazy.nvim plugin types if lazydev.nvim is not installed
          -- "${3rd}/luv/library",
        },
      },
      diagnostics = {
        globals = { "vim" },
      },
      hint = {
        enable = true,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
