# Nix Support Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add full Nix language support (Treesitter, LSP via nixd, formatting via nixfmt, linting via statix+deadnix) to the existing Neovim 0.11+ config.

**Architecture:** All tooling is assumed to be installed via Nix and available on `$PATH` — no Mason integration. Each layer (highlighting, LSP, formatting, linting) is wired into its existing plugin/config file independently, following the patterns already established for Go, TypeScript, and PHP.

**Tech Stack:** Neovim 0.11+, nvim-treesitter v2, conform.nvim, nvim-lint, native `vim.lsp.config` / `vim.lsp.enable`

---

## File Map

| File | Action | Responsibility |
|------|--------|----------------|
| `lua/plugins/treesitter.lua` | Modify | Add `"nix"` parser install + ft_pattern entry |
| `lsp/nixd.lua` | Create | nixd LSP server config (cmd, filetypes, root_markers) |
| `lua/config/lsp.lua` | Modify | Enable nixd via `vim.lsp.enable()` |
| `lua/plugins/formatting.lua` | Modify | Add nixfmt to conform's `formatters_by_ft` |
| `lua/plugins/linting.lua` | Modify | Add statix + deadnix to nvim-lint's `linters_by_ft` |

---

## Task 1: Treesitter — add Nix parser and filetype

**Files:**
- Modify: `lua/plugins/treesitter.lua`

- [ ] **Step 1: Add `"nix"` to the treesitter install list**

In `lua/plugins/treesitter.lua`, add `"nix"` to the `require("nvim-treesitter").install({...})` call. Place it in the "Misc" group at the end:

```lua
        -- Misc
        "toml", "dockerfile", "regex", "nix",
```

- [ ] **Step 2: Add `"nix"` to ft_pattern**

In the same file, add `"nix"` to the `ft_pattern` list. Add it in the "Misc" section near the bottom:

```lua
        "toml", "dockerfile", "nix",
```

- [ ] **Step 3: Verify the file looks correct**

Open `lua/plugins/treesitter.lua` and confirm:
- `"nix"` appears in the `install({...})` call
- `"nix"` appears in the `ft_pattern` table
- No syntax errors (both are just string additions to existing lists)

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/treesitter.lua
git commit -m "feat(treesitter): add Nix parser and filetype support"
```

---

## Task 2: Create nixd LSP config file

**Files:**
- Create: `lsp/nixd.lua`

nixd is the Nix LSP server. It uses `nixd` as the binary name. Unlike gopls, it needs no `settings` block to work — the defaults are sufficient. `flake.nix` is listed first in `root_markers` because it's the modern Nix entry point; `default.nix` covers legacy projects; `.git` is the final fallback (also set globally in `lua/config/lsp.lua`).

- [ ] **Step 1: Create `lsp/nixd.lua`**

```lua
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
}
```

- [ ] **Step 2: Commit**

```bash
git add lsp/nixd.lua
git commit -m "feat(lsp): add nixd LSP config for Nix files"
```

---

## Task 3: Enable nixd in LSP wiring

**Files:**
- Modify: `lua/config/lsp.lua`

- [ ] **Step 1: Add `"nixd"` to `vim.lsp.enable()`**

In `lua/config/lsp.lua`, add `"nixd"` to the list:

```lua
vim.lsp.enable({
	"intelephense",
	"gopls",
	"ts_ls",
	"lua_ls",
	"nixd",
})
```

- [ ] **Step 2: Commit**

```bash
git add lua/config/lsp.lua
git commit -m "feat(lsp): enable nixd for Nix LSP support"
```

---

## Task 4: Add nixfmt formatter

**Files:**
- Modify: `lua/plugins/formatting.lua`

- [ ] **Step 1: Add `nix` entry to `formatters_by_ft`**

In `lua/plugins/formatting.lua`, add the nix entry to the `formatters_by_ft` table inside `opts`. Place it after the `sh` entry:

```lua
			sh = { "shfmt" },
			-- nixfmt is the official Nix formatter (RFC 166 style)
			-- Requires nixfmt on $PATH (install via: nix profile install nixpkgs#nixfmt-rfc-style)
			-- Note: format_on_save is false — run manually with <leader>cf
			nix = { "nixfmt" },
```

- [ ] **Step 2: Commit**

```bash
git add lua/plugins/formatting.lua
git commit -m "feat(formatting): add nixfmt for Nix files"
```

---

## Task 5: Add statix and deadnix linters

**Files:**
- Modify: `lua/plugins/linting.lua`

- [ ] **Step 1: Add `nix` entry to `linters_by_ft`**

In `lua/plugins/linting.lua`, add the nix entry to the `lint.linters_by_ft` table:

```lua
			go = { "golangcilint" },
			-- statix: catches Nix antipatterns and suggests idiomatic rewrites
			-- deadnix: finds unused/dead code in Nix files
			-- Both require tools on $PATH:
			--   nix profile install nixpkgs#statix nixpkgs#deadnix
			-- Note: linting fires on BufWritePost and InsertLeave, not on file open
			nix = { "statix", "deadnix" },
```

- [ ] **Step 2: Commit**

```bash
git add lua/plugins/linting.lua
git commit -m "feat(linting): add statix and deadnix for Nix files"
```

---

## Task 6: Manual smoke test

These are manual verification steps — no automated tests exist for editor config.

- [ ] **Step 1: Ensure tools are on PATH**

Run these commands and confirm each returns a path (not "command not found"):

```bash
which nixd
which nixfmt
which statix
which deadnix
```

If any are missing, install them:
```bash
nix profile install nixpkgs#nixd nixpkgs#nixfmt-rfc-style nixpkgs#statix nixpkgs#deadnix
```

- [ ] **Step 2: Open a .nix file and verify Treesitter**

Open any `.nix` file in Neovim. Run `:InspectTree` — the syntax tree should appear, confirming the parser is active. Syntax should be highlighted.

- [ ] **Step 3: Verify nixd attaches**

With a `.nix` file open, run `:LspInfo`. You should see `nixd` listed as an active client for the buffer.

- [ ] **Step 4: Verify nixfmt formatting**

With a `.nix` file open, press `<leader>cf`. The buffer should be formatted without errors. Run `:ConformInfo` to confirm `nixfmt` is listed for the `nix` filetype.

- [ ] **Step 5: Verify statix and deadnix linting**

With a `.nix` file open, save it (`:w`). Check `:lua vim.diagnostic.get(0)` — diagnostics from statix/deadnix should appear if there are any issues. No errors in the Neovim command line means the linters ran successfully.

- [ ] **Step 6: Final commit (if any fixups needed)**

```bash
git add -p
git commit -m "fix(nix): address smoke test issues"
```
