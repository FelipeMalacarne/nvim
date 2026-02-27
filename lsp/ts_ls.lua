-- ts_ls — TypeScript / JavaScript LSP (typescript-language-server)
-- vim.lsp.enable("ts_ls") is called from lua/config/lsp.lua
-- This file MUST return a table.
return {
  cmd       = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints           = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints   = true,
        includeInlayVariableTypeHints            = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints  = true,
        includeInlayEnumMemberValueHints         = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints           = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints   = true,
        includeInlayVariableTypeHints            = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints  = true,
        includeInlayEnumMemberValueHints         = true,
      },
    },
  },
}
