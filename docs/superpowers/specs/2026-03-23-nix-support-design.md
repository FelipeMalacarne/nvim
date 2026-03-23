# Nix Support for Neovim Config

**Date:** 2026-03-23
**Status:** Approved

## Overview

Add full Nix language support to the existing Neovim configuration: syntax highlighting via Treesitter, LSP via `nixd`, formatting via `nixfmt`, and linting via `statix` and `deadnix`.

All tools are expected to be installed via Nix (e.g., `nix profile install`, home-manager, or a dev shell) and available on `$PATH`. Mason is not used for these tools — it has no packages for the Nix ecosystem.

## Components

### 1. Treesitter — `lua/plugins/treesitter.lua`

Two separate additions are required:

- Add `"nix"` to the `require("nvim-treesitter").install({...})` call — this downloads and compiles the parser
- Add `"nix"` to the `ft_pattern` list — this enables Treesitter highlighting and indentation when a `.nix` file is opened

Both are required; omitting either will result in partial or broken support.

### 2. LSP — new file `lsp/nixd.lua`

Create a new LSP config file following the structure of `lsp/gopls.lua` (use this as the reference, not `lsp/lua_ls.lua` which has a typo in its `root_markers` key):

- `cmd = { "nixd" }` — invokes the nixd binary
- `filetypes = { "nix" }` — activates for Nix files
- `root_markers = { "flake.nix", "default.nix", ".git" }` — determines project root; `flake.nix` takes priority as it's the modern Nix entry point

Neovim 0.11+ resolves `lsp/*.lua` files from the runtimepath automatically, so no plugin registration is needed.

### 3. LSP wiring — `lua/config/lsp.lua`

- Add `"nixd"` to the `vim.lsp.enable({...})` list alongside the existing servers

### 4. Formatting — `lua/plugins/formatting.lua`

- Add `nix = { "nixfmt" }` to `formatters_by_ft` in the conform.nvim opts
- `nixfmt` is the official Nix formatter (RFC 166 style); must be on `$PATH`
- Note: `format_on_save = false` is the convention in this config — `nixfmt` will only run on manual invocation via `<leader>cf` or `:ConformInfo`

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
  → on BufWritePost or InsertLeave: statix + deadnix lint the buffer
      (note: linting does NOT fire on file open — first run is on first write or InsertLeave)
  → on <leader>cf or manual format command: nixfmt formats the buffer
      (format_on_save is disabled by convention in this config)
```

## Constraints

- No Mason integration — all tools managed externally via Nix
- No binary guards — follows existing config convention (other LSPs also assume tools are on PATH)
- `nixd` provides the best flake-aware completions by evaluating Nix expressions at runtime

## Files Changed

| File | Change |
|------|--------|
| `lua/plugins/treesitter.lua` | Add `"nix"` to install list AND to ft_pattern (two separate additions) |
| `lsp/nixd.lua` | New file — nixd LSP config (model: `gopls.lua`) |
| `lua/config/lsp.lua` | Add `"nixd"` to `vim.lsp.enable()` |
| `lua/plugins/formatting.lua` | Add `nix = { "nixfmt" }` |
| `lua/plugins/linting.lua` | Add `nix = { "statix", "deadnix" }` |
