{
  description = "Java 21 and Spring Boot Complete IDE Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # --- Java Runtime & Build Systems ---
          jdk21
          maven
          gradle

          # --- Language Servers & Code Quality Tooling ---
          jdt-language-server
          google-java-format      # Formatter for Java source files
          lombok
          yaml-language-server    # Language server for application.yml completion
          lemminx                  # XML Language Server for pom.xml validation
          xmlstarlet              # CLI XML utility

          # --- Web & Markup Language Servers / Formatters ---
          prettier                # Formatter for HTML, CSS, JS, JSON, YAML
          vscode-langservers-extracted # Provides html-lsp, css-lsp, json-lsp

          # --- IDE Extension Bundles (DAP & Testing Jars) ---
          vscode-extensions.vscjava.vscode-java-debug
          vscode-extensions.vscjava.vscode-java-test

          # --- CLI Utilities & REST Testing Tooling ---
          spring-boot-cli
          curl
          tree-sitter
          gcc
          gnumake
          httpie

          # --- Database CLI Clients for vim-dadbod Integration ---
          postgresql              # Provides psql binary for PostgreSQL connections
          mariadb                 # Provides mysql binary for MySQL/MariaDB connections
        ];

        shellHook = ''
          # --- Base Environment Configuration ---
          export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"
          export JAVA_HOME="${pkgs.jdk21}"
          export LOMBOK_JAR="${pkgs.lombok}/share/java/lombok.jar"

          # --- Neovim Java LSP & Debugger Extension Bundles ---
          export JAVA_DEBUG_JAR="${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server"
          export JAVA_TEST_JARS="${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server"

          # --- Isolated Build Tool & Runtime Cache Locations ---
          export MAVEN_USER_HOME="$XDG_CACHE_HOME/m2"
          export MAVEN_OPTS="-Dmaven.repo.local=$MAVEN_USER_HOME/repository"
          export MAVEN_CONFIG="-Dmaven.repo.local=$MAVEN_USER_HOME/repository"
          export GRADLE_USER_HOME="$XDG_CACHE_HOME/gradle"
          export PATH="$JAVA_HOME/bin:$PATH"

          # Ensure isolated cache directories exist
          mkdir -p "$MAVEN_USER_HOME"/{repository,wrapper} "$XDG_CACHE_HOME"/{gradle,eclipse}

          echo "🚀 Complete Spring Boot IDE Environment Active (Java 21 | JDTLS | DAP | Web/YAML/XML LS | DB & REST Tools)"
        '';
      };
    };
}
