return {
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSPs
				"intelephense",
				"gopls",
				"typescript-language-server",
				"lua-language-server",

				-- Formatters
				"stylua",
				"prettier",
				"goimports",
				"shfmt",
				"blade-formatter",

				-- Linters
				"eslint_d",
				"golangci-lint",
				"phpstan",
			},
			auto_update = false,
			run_on_start = true,
		},
	},
}
