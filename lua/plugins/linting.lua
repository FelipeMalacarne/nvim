return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				php = { "phpstan" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				go = { "golangcilint" },
				-- statix: catches Nix antipatterns and suggests idiomatic rewrites
				-- deadnix: finds unused/dead code in Nix files
				-- Both require tools on $PATH:
				--   nix profile install nixpkgs#statix nixpkgs#deadnix
				-- Note: linting fires on BufWritePost and InsertLeave, not on file open
				nix = { "statix", "deadnix" },
				-- lua        = { "selene" },
			}

			-- Run linter on save and after leaving insert mode
			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
				callback = function()
					-- Only lint if a config file exists for the linter
					lint.try_lint()
				end,
			})
		end,
	},
}
