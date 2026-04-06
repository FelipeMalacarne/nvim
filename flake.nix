{
  description = "Felipe's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;  # required for intelephense
        };

        # nvim-treesitter.withPlugins returns the Lua plugin; actual parser .so files
        # live in .dependencies (one derivation per grammar, each with parser/<name>.so).
        treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
          # Go
          p.go p.gomod p.gosum p.gotmpl
          # PHP
          p.php p.phpdoc
          # TypeScript / JS
          p.typescript p.tsx p.javascript p.jsdoc
          # Web
          p.html p.css p.json p.yaml
          # Shell
          p.bash
          # Git
          p.gitcommit p.gitignore p.diff
          # Misc
          p.toml p.dockerfile p.regex p.nix
          # Bundled in Neovim but explicit for safety
          p.lua p.vim p.vimdoc p.query p.markdown p.markdown_inline p.c
        ]);

        # Merge all grammar derivations into one directory with parser/*.so files.
        treesitterParsers = pkgs.symlinkJoin {
          name = "nvim-treesitter-parsers";
          paths = treesitterWithGrammars.dependencies;
        };

        # All external tools neovim needs — replaces Mason on NixOS
        tools = with pkgs; [
          # LSP servers
          nixd
          gopls
          lua-language-server
          nodePackages.typescript-language-server
          nodePackages.intelephense

          # Formatters
          nixfmt  # RFC-166 style; binary is named `nixfmt` on PATH
          stylua
          nodePackages.prettier
          gotools             # provides goimports
          go                  # provides gofmt
          shfmt

          # Linters
          statix
          deadnix
          golangci-lint
          phpstan
          # eslint_d is not in nixpkgs — Mason handles it in non-Nix environments

          # Git tools used in keymaps
          lazygit
          lazysql
          lazydocker

          # Required to compile telescope-fzf-native
          gcc
          gnumake
        ];

        neovim = pkgs.neovim;
        configDir = self;

      in {
        # `nix run` — launches neovim with the full config + tools in PATH
        packages.default = pkgs.writeShellScriptBin "nvim" ''
          set -e
          export NIX_MANAGED=1
          export PATH="${pkgs.lib.makeBinPath tools}:$PATH"

          # Use a separate NVIM_APPNAME so this doesn't conflict with ~/.config/nvim
          APPNAME="nvim-flake"
          CONFIG_LINK="''${XDG_CONFIG_HOME:-$HOME/.config}/$APPNAME"
          DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/$APPNAME"

          # Symlink the config from the nix store into ~/.config/nvim-flake
          if [ "$(readlink "$CONFIG_LINK" 2>/dev/null)" != "${configDir}" ]; then
            mkdir -p "$(dirname "$CONFIG_LINK")"
            ln -sfn "${configDir}" "$CONFIG_LINK"
          fi

          # Symlink the merged parser .so files into the nvim data dir.
          TS_LINK="$DATA_DIR/nix/nvim-treesitter"
          if [ "$(readlink "$TS_LINK" 2>/dev/null)" != "${treesitterParsers}" ]; then
            mkdir -p "$(dirname "$TS_LINK")"
            ln -sfn "${treesitterParsers}" "$TS_LINK"
          fi

          export NVIM_APPNAME="$APPNAME"
          export NVIM_TREESITTER_PARSERS="$TS_LINK"
          exec ${neovim}/bin/nvim "$@"
        '';

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };

        # `nix develop` — drops you into a shell with neovim + all tools
        # Your local config at ~/.config/nvim is used as-is
        devShells.default = pkgs.mkShell {
          buildInputs = [ neovim ] ++ tools;
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
      });
}
