local map = vim.keymap.set
local ui = require("config.ui")

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Split windows
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Stay in indent mode after shifting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Save
map({ "n", "i" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Reload config
map("n", "<leader>rc", function()
	for _, mod in ipairs({ "config.options", "config.keymaps", "config.autocmds" }) do
		package.loaded[mod] = nil
		require(mod)
	end
	vim.notify("Config reloaded")
end, { desc = "Reload config" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Code diagnostics" })

-- Lazygit
map("n", "<leader>gg", function()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = ui.float_border,
	})
	vim.fn.termopen("lazygit", {
		on_exit = function()
			vim.api.nvim_buf_delete(buf, { force = true })
		end,
	})
	vim.cmd("startinsert")
end, { desc = "Lazygit" })

-- Lazydocker
map("n", "<leader>gd", function()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = ui.float_border,
	})
	vim.fn.termopen("lazydocker", {
		on_exit = function()
			vim.api.nvim_buf_delete(buf, { force = true })
		end,
	})
	vim.cmd("startinsert")
end, { desc = "Lazydocker" })

map("n", "<leader>gs", function()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = ui.float_border,
	})

	vim.fn.termopen("lazysql", {
		on_exit = function()
			vim.api.nvim_buf_delete(buf, { force = true })
		end,
	})
	vim.cmd("startinsert")
end, { desc = "LazySQL" })

-- claude code
local claude_buf = nil
local claude_win = nil
map({ "n", "t" }, "<C-g>", function()
	if claude_win and vim.api.nvim_win_is_valid(claude_win) then
		vim.api.nvim_win_close(claude_win, false)
		claude_win = nil
		return
	end
	if not claude_buf or not vim.api.nvim_buf_is_valid(claude_buf) then
		claude_buf = vim.api.nvim_create_buf(false, true)
	end
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	claude_win = vim.api.nvim_open_win(claude_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = ui.float_border,
	})
	if vim.bo[claude_buf].buftype ~= "terminal" then
		vim.fn.termopen("claude", {
			on_exit = function()
				claude_buf = nil
				claude_win = nil
			end,
		})
	end
	vim.cmd("startinsert")
end, { desc = "Toggle Claude Code" })

-- Terminal
local term_buf = nil
local term_win = nil
map({ "n", "t" }, "<C-/>", function()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, false)
		term_win = nil
		return
	end
	if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
		term_buf = vim.api.nvim_create_buf(false, true)
	end
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	term_win = vim.api.nvim_open_win(term_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = ui.float_border,
	})
	if vim.bo[term_buf].buftype ~= "terminal" then
		vim.fn.termopen(vim.o.shell, {
			on_exit = function()
				term_buf = nil
				term_win = nil
			end,
		})
	end
	vim.cmd("startinsert")
end, { desc = "Toggle terminal" })

-- Quit
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
