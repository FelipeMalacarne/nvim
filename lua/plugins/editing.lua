-- Small editing quality-of-life plugins
return {
	-- Auto-close brackets, quotes, etc.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true, -- use treesitter to check context
			ts_config = {
				lua = { "string" }, -- don't pair inside lua strings
				javascript = { "template_string" },
			},
			disable_filetype = { "TelescopePrompt" },
		},
	},

	-- Better text objects (aa, ia, etc.)
	{
		"echasnovski/mini.ai",
		version = "*",
		event = "BufReadPost",
		opts = {},
	},

	-- Surround (ys, cs, ds)
	{
		"echasnovski/mini.surround",
		version = "*",
		event = "BufReadPost",
		opts = {
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "gsn",
			},
		},
	},

	-- Context-aware commentstring for JSX/TSX
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = { enable_autocmd = false },
	},

	-- Comment toggling (gc, gcc)
	{
		"echasnovski/mini.comment",
		version = "*",
		event = "BufReadPost",
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
		},
	},

	-- Jump to any character on screen
	{
		"echasnovski/mini.jump2d",
		version = "*",
		keys = { { "<leader>j", mode = { "n", "v" }, desc = "Jump 2D" } },
		opts = {},
	},
}
