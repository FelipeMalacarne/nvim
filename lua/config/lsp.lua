-- Global defaults applied to ALL LSP clients (lowest precedence)
vim.lsp.config("*", {
	root_markers = { ".git" },
})

-- Enable LSP servers (lsp/*.lua files are resolved from runtimepath automatically)
vim.lsp.enable({
	"intelephense",
	"gopls",
	"ts_ls",
	"lua_ls",
})

-- LSP keymaps — set per buffer on attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("config.lsp.keymaps", { clear = true }),
	callback = function(ev)
		local map = vim.keymap.set
		local opts = function(desc)
			return { buffer = ev.buf, desc = desc }
		end

		map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
		map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
		map("n", "gy", vim.lsp.buf.type_definition, opts("Go to type definition"))
		map("n", "gr", vim.lsp.buf.references, opts("References"))
		map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
		map("n", "K", vim.lsp.buf.hover, opts("Hover docs"))
		map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
		map("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
		map("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts("Format buffer"))

		-- Diagnostics
		map("n", "<leader>d", vim.diagnostic.open_float, opts("Show diagnostics"))
		map("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
		map("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))

		-- Inlay hints toggle (Neovim 0.10+)
		if vim.lsp.inlay_hint then
			map("n", "<leader>ih", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
			end, opts("Toggle inlay hints"))
		end
	end,
})
