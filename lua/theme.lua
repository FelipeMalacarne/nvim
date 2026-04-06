local M = {}

-- Catppuccin Mocha — base16 palette used as standalone default
local default = {
  base00 = '#1e1e2e', base01 = '#181825', base02 = '#313244', base03 = '#45475a',
  base04 = '#585b70', base05 = '#cdd6f4', base06 = '#f5e0dc', base07 = '#b4befe',
  base08 = '#f38ba8', base09 = '#fab387', base0A = '#f9e2af', base0B = '#a6e3a1',
  base0C = '#94e2d5', base0D = '#89b4fa', base0E = '#cba6f7', base0F = '#f2cdcd',
}

-- Returns the active palette.
-- Nix context:  reads NIX_COLOR_BASE00..BASE0F injected by the flake wrapper.
-- Standalone:   returns catppuccin-mocha defaults.
function M.palette()
  if vim.env.NIX_MANAGED ~= '1' then return default end

  local p = {}
  for _, b in ipairs({
    'base00', 'base01', 'base02', 'base03', 'base04', 'base05', 'base06', 'base07',
    'base08', 'base09', 'base0A', 'base0B', 'base0C', 'base0D', 'base0E', 'base0F',
  }) do
    p[b] = vim.env['NIX_COLOR_' .. b] or default[b]
  end
  return p
end

function M.setup()
  require('base16-colorscheme').setup(M.palette())
end

return M
