{
  description = "Multi-language development laboratory environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # --- Nix Development ---
          nil
          alejandra

          # --- Java ---
          jdk
          maven
          gradle
          jdt-language-server
          google-java-format

          # --- Node.js / JS / TS / Web ---
          nodejs
          typescript-language-server
          prettierd
          vscode-langservers-extracted

          # --- Python ---
          python3
          python3Packages.pip
          python3Packages.virtualenv
          pyright
          ruff

          # --- Go ---
          go
          gopls
          gotools
          golangci-lint

          # --- Rust ---
          rustc
          cargo
          rust-analyzer
          rustfmt
          clippy

          # --- Config / Markup / Docs ---
          marksman
          taplo
          yaml-language-server

          # --- Bash / Shell ---
          bash-language-server
          shellcheck
          shfmt

          # --- Lua ---
          lua-language-server
          stylua

          # --- CLI Utilities (Neovim / General) ---
          ripgrep
          fd
          jq
          tree-sitter
          gcc
          gnumake
        ];

        shellHook = ''
          # Standard XDG Cache base directory
          export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"

          # --- Java / Maven ---
          export JAVA_HOME="${pkgs.jdk}"
          export MAVEN_OPTS="-Dmaven.repo.local=$XDG_CACHE_HOME/m2"

          # --- Node.js / npm ---
          export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"

          # --- Go ---
          export GOPATH="$XDG_CACHE_HOME/go"
          export GOCACHE="$XDG_CACHE_HOME/go-build"

          # --- Rust / Cargo ---
          export CARGO_HOME="$XDG_CACHE_HOME/cargo"

          # --- Python / Pip ---
          export PIP_CACHE_DIR="$XDG_CACHE_HOME/pip"
          PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
          export PIP_PREFIX="$(pwd)/.build/pip"
          export PYTHONPATH="$PIP_PREFIX/lib/python$PYTHON_VERSION/site-packages:$PYTHONPATH"

          # Add toolchain binaries to PATH
          export PATH="$GOPATH/bin:$CARGO_HOME/bin:$PIP_PREFIX/bin:$JAVA_HOME/bin:$PATH"

          # Ensure required cache and local directories exist
          mkdir -p "$XDG_CACHE_HOME"/{m2,npm,go,go-build,cargo,pip}
          mkdir -p "$PIP_PREFIX/lib/python$PYTHON_VERSION/site-packages"

          echo "🧪 Active Dev Environment (XDG & Toolchain Ready): Nix, Java, Node.js, Python, Go, Rust, Web, Bash, Lua"
        '';
      };
    };
}
