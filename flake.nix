{
  description = "Felipe's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      # Default color palette — Catppuccin Mocha
      # Format: base16 attrset without # prefix (compatible with nix-colors colorScheme.palette)
      catppuccinMocha = {
        base00 = "1e1e2e";
        base01 = "181825";
        base02 = "313244";
        base03 = "45475a";
        base04 = "585b70";
        base05 = "cdd6f4";
        base06 = "f5e0dc";
        base07 = "b4befe";
        base08 = "f38ba8";
        base09 = "fab387";
        base0A = "f9e2af";
        base0B = "a6e3a1";
        base0C = "94e2d5";
        base0D = "89b4fa";
        base0E = "cba6f7";
        base0F = "f2cdcd";
      };

      mkTools =
        pkgs: with pkgs; [
          nodejs
          # LSP servers
          nixd
          gopls
          lua-language-server
          typescript-language-server
          intelephense

          # Formatters
          nixfmt
          stylua
          prettier
          gotools
          go
          shfmt

          # Linters
          statix
          deadnix
          golangci-lint
          phpstan
          eslint_d

          # Git tools used in keymaps
          lazygit
          lazysql
          lazydocker

          # Required to compile telescope-fzf-native
          gcc
          gnumake
          fd
          ripgrep

        ];

      mkTreesitterParsers =
        pkgs:
        let
          treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
            # Go
            p.go
            p.gomod
            p.gosum
            p.gotmpl
            # PHP
            p.php
            p.php_only
            p.phpdoc
            p.blade
            # TypeScript / JS
            p.typescript
            p.tsx
            p.javascript
            p.jsdoc
            # Web
            p.html
            p.css
            p.json
            p.yaml
            # Shell
            p.bash
            # Git
            p.gitcommit
            p.gitignore
            p.diff
            # Misc
            p.toml
            p.dockerfile
            p.regex
            p.nix
            # Bundled in Neovim but explicit for safety
            p.lua
            p.vim
            p.vimdoc
            p.query
            p.markdown
            p.markdown_inline
            p.c
          ]);
        in
        pkgs.symlinkJoin {
          name = "nvim-treesitter-parsers";
          # Base nvim-treesitter provides ALL query dirs (including virtual ones like
          # ecma/jsx/scss that inherited queries depend on) but no compiled parsers.
          # Grammar .dependencies provide the compiled parser .so files.
          # Both from same nixpkgs revision → version-compatible.
          paths = [ pkgs.vimPlugins.nvim-treesitter ] ++ treesitterWithGrammars.dependencies;
        };

      # Build the wrapped nvim package with an injected color palette.
      #
      # colors: base16 attrset without # prefix.
      #         Pass catppuccinMocha (default) or nix-colors colorScheme.palette.
      #
      # Each color is exported as NIX_COLOR_BASE00..NIX_COLOR_BASE0F so the
      # Lua config can read them via vim.fn.getenv("NIX_COLOR_BASE0E") etc.
      mkPackage =
        pkgs: colors:
        let
          tools = mkTools pkgs;
          treesitterParsers = mkTreesitterParsers pkgs;
          colorExports = builtins.concatStringsSep "\n" (
            map (n: "export NIX_COLOR_${n}=\"#${colors.${n}}\"") (builtins.attrNames colors)
          );
        in
        pkgs.writeShellScriptBin "nvim" ''
          set -e
          export NIX_MANAGED=1
          ${colorExports}
          export PATH="${pkgs.lib.makeBinPath tools}:$PATH"

          APPNAME="nvim-flake"
          CONFIG_LINK="''${XDG_CONFIG_HOME:-$HOME/.config}/$APPNAME"
          DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/$APPNAME"

          if [ "$(readlink "$CONFIG_LINK" 2>/dev/null)" != "${self}" ]; then
            mkdir -p "$(dirname "$CONFIG_LINK")"
            ln -sfn "${self}" "$CONFIG_LINK"
          fi

          TS_LINK="$DATA_DIR/nix/nvim-treesitter"
          if [ "$(readlink "$TS_LINK" 2>/dev/null)" != "${treesitterParsers}" ]; then
            mkdir -p "$(dirname "$TS_LINK")"
            ln -sfn "${treesitterParsers}" "$TS_LINK"
          fi

          export NVIM_APPNAME="$APPNAME"
          export NVIM_TREESITTER_PARSERS="$TS_LINK"
          exec ${pkgs.neovim}/bin/nvim "$@"
        '';

    in
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        tools = mkTools pkgs;
        treesitterParsers = mkTreesitterParsers pkgs;
      in
      {
        # `nix run` — uses catppuccin-mocha by default
        packages.default = mkPackage pkgs catppuccinMocha;

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };

        # `nix develop` — drops you into a shell with neovim + all tools
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.neovim ] ++ tools;
          shellHook = ''
            export NIX_MANAGED=1
            TS_LINK="''${XDG_DATA_HOME:-$HOME/.local/share}/nvim/nix/nvim-treesitter"
            if [ "$(readlink "$TS_LINK" 2>/dev/null)" != "${treesitterParsers}" ]; then
              mkdir -p "$(dirname "$TS_LINK")"
              ln -sfn "${treesitterParsers}" "$TS_LINK"
            fi
            export NVIM_TREESITTER_PARSERS="$TS_LINK"
            echo "Neovim dev environment ready — all tools are in PATH."
            echo "Run: nvim"
          '';
        };
      }
    ))
    // {
      # Exported for use in external configs.
      # Usage: inputs.nvim-config.lib.mkPackage pkgs config.colorScheme.palette
      lib.mkPackage = mkPackage;
    };
}
