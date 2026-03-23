# Nix Support for Neovim Config

**Date:** 2026-03-23
**Status:** Approved

## Overview

Add full Nix language support to the existing Neovim configuration: syntax highlighting via Treesitter, LSP via `nixd`, formatting via `nixfmt`, and linting via `statix` and `deadnix`.

All tools are expected to be installed via Nix (e.g., `nix profile install`, home-manager, or a dev shell) and available on `$PATH`. Mason is not used for these tools — it has no packages for the Nix ecosystem.

## Components

### 1. Treesitter — `lua/plugins/treesitter.lua`

- Add `"nix"` to the `require("nvim-treesitter").install({...})` call
- Add `"nix"` to the `ft_pattern` list so highlighting and indentation are enabled for `.nix` files

### 2. LSP — new file `lsp/nixd.lua`

Create a new LSP config file following the same structure as existing files (`gopls.lua`, `lua_ls.lua`, etc.):

- `cmd = { "nixd" }` — invokes the nixd binary
- `filetypes = { "nix" }` — activates for Nix files
- `root_markers = { "flake.nix", "default.nix", ".git" }` — determines project root; flake.nix takes priority as it's the modern entry point

Neovim 0.11+ resolves `lsp/*.lua` files from the runtimepath automatically, so no plugin registration is needed.

### 3. LSP wiring — `lua/config/lsp.lua`

- Add `"nixd"` to the `vim.lsp.enable({...})` list alongside the existing servers

### 4. Formatting — `lua/plugins/formatting.lua`

- Add `nix = { "nixfmt" }` to `formatters_by_ft` in the conform.nvim opts
- `nixfmt` is the official Nix formatter (RFC 166 style); must be on `$PATH`

### 5. Linting — `lua/plugins/linting.lua`

- Add `nix = { "statix", "deadnix" }` to `linters_by_ft` in the nvim-lint config
- `statix` catches antipatterns and suggests idiomatic Nix rewrites
- `deadnix` finds unused/dead code in Nix files
- Both must be on `$PATH`

## Data Flow

```
.nix file opened
  → Treesitter highlights syntax
  → nixd attaches (LSP): completions, diagnostics, go-to-definition
  → on BufWritePost/InsertLeave: statix + deadnix lint the buffer
  → on <leader>cf or format command: nixfmt formats the buffer
```

## Constraints

- No Mason integration — all tools managed externally via Nix
- No binary guards — follows existing config convention (other LSPs also assume tools are on PATH)
- `nixd` provides the best flake-aware completions by evaluating Nix expressions at runtime; it requires `nixd` to be installed, not just `nil_ls`

## Files Changed

| File | Change |
|------|--------|
| `lua/plugins/treesitter.lua` | Add `"nix"` to install list and ft_pattern |
| `lsp/nixd.lua` | New file — nixd LSP config |
| `lua/config/lsp.lua` | Add `"nixd"` to `vim.lsp.enable()` |
| `lua/plugins/formatting.lua` | Add `nix = { "nixfmt" }` |
| `lua/plugins/linting.lua` | Add `nix = { "statix", "deadnix" }` |
