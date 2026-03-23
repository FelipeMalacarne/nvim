-- nixd — Nix LSP
-- Provides completions, diagnostics, and go-to-definition for Nix files.
-- Requires nixd on $PATH (install via: nix profile install nixpkgs#nixd)
-- vim.lsp.enable("nixd") is called from lua/config/lsp.lua
-- This file MUST return a table.
return {
	cmd = { "nixd" },
	filetypes = { "nix" },
	-- flake.nix first: most Nix projects today use flakes
	-- default.nix: covers classic/legacy Nix projects
	-- .git: fallback for projects without a Nix entry point at root
	root_markers = { "flake.nix", "default.nix", ".git" },
	-- Uncomment and adjust to enable rich pkgs.* completions.
	-- Without this, nixd starts but nixpkgs attribute completions will be empty.
	-- See: https://github.com/nix-community/nixd/blob/main/docs/configuration.md
	-- settings = {
	-- 	nixd = {
	-- 		nixpkgs = { expr = "import <nixpkgs> {}" },
	-- 		formatting = { command = { "nixfmt" } },
	-- 	},
	-- },
}
