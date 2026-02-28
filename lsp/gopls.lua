-- gopls — Go LSP
-- vim.lsp.enable("gopls") is called from lua/config/lsp.lua
-- This file MUST return a table.
return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", "go.work", ".git" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
			gofumpt = true,
			hints = {
				parameterNames = true,
				assignVariableTypes = true,
				constantValues = true,
				rangeVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				functionTypeParameters = true,
			},
		},
	},
}
