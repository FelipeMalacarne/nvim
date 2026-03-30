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

        # All external tools neovim needs — replaces Mason on NixOS
        tools = with pkgs; [
          # LSP servers
          nixd
          gopls
          lua-language-server
          nodePackages.typescript-language-server
          nodePackages.intelephense

          # Formatters
          nixfmt             # nixfmt (RFC-166 style)
          stylua
          nodePackages.prettier
          gotools             # provides goimports + gofmt
          shfmt

          # Linters
          statix
          deadnix
          golangci-lint
          # phpstan: use php83Packages.phpstan if you need it
          # eslint_d: not in nixpkgs, Mason handles it outside NixOS

          # Git tools used in keymaps
          lazygit

          # Required to compile telescope-fzf-native
          gcc
          gnumake
        ];

        configDir = self;
        neovim = pkgs.neovim;

      in {
        # `nix run` — launches neovim with the full config + tools in PATH
        packages.default = pkgs.writeShellScriptBin "nvim" ''
          set -e
          export NIX_MANAGED=1
          export PATH="${pkgs.lib.makeBinPath tools}:$PATH"

          # Use a separate NVIM_APPNAME so this doesn't conflict with ~/.config/nvim
          APPNAME="nvim-flake"
          CONFIG_LINK="''${XDG_CONFIG_HOME:-$HOME/.config}/$APPNAME"

          # Symlink the config from the nix store into ~/.config/nvim-flake
          if [ "$(readlink "$CONFIG_LINK" 2>/dev/null)" != "${configDir}" ]; then
            mkdir -p "$(dirname "$CONFIG_LINK")"
            ln -sfn "${configDir}" "$CONFIG_LINK"
          fi

          export NVIM_APPNAME="$APPNAME"
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
            echo "Neovim dev environment ready — all tools are in PATH."
            echo "Run: nvim"
          '';
        };
      });
}
