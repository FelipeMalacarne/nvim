local M = {}

local cached_branch = ""
local last_check = 0

function M.branch()
	local now = vim.uv.now() -- vim.uv is the correct API (vim.loop is deprecated)
	if now - last_check > 5000 then
		cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
		last_check = now
	end
	if cached_branch ~= "" then
		return " \u{e725} " .. cached_branch .. " "
	end
	return ""
end

return M
