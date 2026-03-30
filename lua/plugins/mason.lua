-- Mason is disabled when NIX_MANAGED=1 (nix provides all tools instead)
local nix = vim.env.NIX_MANAGED == "1"

return {
	{
		"mason-org/mason.nvim",
		enabled = not nix,
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		enabled = not nix,
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
