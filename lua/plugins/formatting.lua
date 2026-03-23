return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "Format buffer (conform)",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofmt" },
				php = { "pint" }, -- Laravel Pint (falls back to php-cs-fixer)
				blade = { "blade-formatter" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				sh = { "shfmt" },
				-- nixfmt is the official Nix formatter (RFC 166 style)
				-- Requires nixfmt on $PATH (install via: nix profile install nixpkgs#nixfmt-rfc-style)
				-- Note: format_on_save is false — run manually with <leader>cf
				nix = { "nixfmt" },
			},
			format_on_save = false,
		},
	},
}
