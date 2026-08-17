# 🛠️ System Dotfiles & Development Ecosystem

Modular configuration ecosystem optimized for **Debian 13 (Trixie)** running on Btrfs + LUKS. Focused on performance, reproducibility, and isolated development using **Neovim**, **Nix (Flakes + Direnv)**, and **WezTerm**.

## 📋 Table of Contents
- [Overview](#-overview)
- [Prerequisites](#-prerequisites)
- [Deployment](#-deployment)
- [Core Architecture](#-core-architecture)
- [Maintenance Engine](#️-maintenance-engine)
- [Neovim IDE Architecture](#-neovim-ide-architecture)
- [Nix Environments](#-nix-environments)

---

## 🥊 Overview

- **Clean `$HOME`:** Massive redirection of application caches via XDG standards, injected dynamically per project environment.
- **Isolated Runtimes:** Nix Flakes + Direnv manage toolchains (LSPs, formatters, compilers) without polluting the global OS.
- **Modular Bash:** Configurations are split into isolated `.sh` modules (`aliases`, `env`, `keybindings`, `themes`, `updates`) executed by `~/.bashrc`.

---

## 🧰 Prerequisites

### 1. Base System & Modern CLI
Install fundamental tools, container engines, and Rust-based alternatives via Debian APT:

```bash
sudo apt update && sudo apt install -y \
    git curl build-essential unzip ripgrep fd-find fzf stow direnv \
    eza bat zoxide podman starship
```
> **Note:** This environment explicitly tracks the Debian Trixie Stable. Here `bat` is installed as `batcat` (automatically handled by the aliases module).

### 2. External Binaries
**Nix Package Manager (Determinate Systems):**
```bash
curl --proto '=https' --tlsv1.2 -sSf [https://install.determinate.systems/nix](https://install.determinate.systems/nix) | sh -- daemon-install
```
*(Note: Nix installer telemetry is explicitly disabled via `DETSYS_IDS_TELEMETRY=disabled` in the environment for privacy).*

---

## 🚀 Deployment

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/arnoldevs/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Link Configurations (GNU Stow):**
   ```bash
   stow bash nvim wezterm bin starship cava
   source ~/.bashrc
   ```

3. **Bootstrap User Space (The Magic Step):**
   Execute the built-in maintenance engine to automatically download and seamlessly integrate user binaries (**Neovim**, **Nerd Fonts**, **Beekeeper Studio**, **Kind**) into `~/.local`:
   ```bash
   updates -u
   ```

---

## 🧩 Core Architecture

### Terminal & CLI (WezTerm + Bash)
- **Aliases:** `ls` → `eza`, `cat` → `batcat`. Core utilities (`rm`, `cp`, `mv`) are aliased to their interactive modes to prevent data loss.
- **Dynamic Theming:** Adapts `bat` and `fzf` color schemes to Gruvbox (dark or light) based on the terminal's `$WEZTERM_THEME_MODE` environment variable.
- **Keybindings:**
  - <kbd>Esc</kbd> <kbd>Esc</kbd>: Instantly toggles `sudo ` at the beginning of the current (or previous) command.
  - <kbd>Alt</kbd> + <kbd>v</kbd>: Appends ` | nvim -` to pipe the standard output of any CLI tool directly into Neovim.

### Containerization (Podman)
- **Rootless Podman** serves as a drop-in replacement for Docker.
- Ecosystem compatibility (e.g., Docker Compose) is maintained by automatically routing `$DOCKER_HOST` to the Podman UNIX socket.
- **Kind** (Kubernetes in Docker) is forced to use the Podman backend via `$KIND_EXPERIMENTAL_PROVIDER=podman`.

---

## ⚙️ Maintenance Engine (`updates`)

A robust, custom Bash orchestrator (`~/.bashrc.d/updates.sh`) handles atomic upgrades and system maintenance.
> ⚠️ **Scope:** This framework is designed strictly for **updating an existing installation**. It is not an initial OS installation script.

| Command | Description |
| :--- | :--- |
| `updates -u` | **User-space Updates:** Safely updates applications without root (Neovim release binary, Beekeeper Studio AppImage, Kind CLI, Flatpaks, and Nerd Fonts). |
| `updates -s` | **System-space Updates:** Executes root-level upgrades (APT packages, fwupdmgr, Determinate Nix Engine, and MineGrub themes). |
| `updates -a` | **Full Sequence:** Runs all user and system modules sequentially. |

---

## 📝 Neovim IDE Architecture

Configured as the primary development environment, this setup is built on top of **LazyVim** but heavily customized into a granular, modular plugin structure (`lua/config/plugins/`). It acts as the interactive frontend for the toolchains dynamically injected by Nix and Direnv.

### Key Capabilities

* **Database Management (`dadbod.lua`):** Provides a native, in-editor UI for database interaction. It seamlessly consumes the isolated `psql` and `mysql` binaries provided by the project's Nix flakes.
* **Enterprise Java Integration (`java.lua` & `dap.lua`):** Fully configured Debug Adapter Protocol (DAP) and JDTLS integrations tailored for Spring Boot development and testing.
* **Filesystem as a Buffer (`oil.lua`):** Allows editing the directory structure directly as a standard Neovim text buffer, streamlining file operations.
* **Formatting & Diagnostics (`conform.lua`, `lsp.lua`, `trouble.lua`):** Handshakes directly with the isolated language servers and formatters (like Prettier, Google Java Format, and Ruff) spun up by the active project environment.
* **Modern UI & Utilities (`snacks.lua`, `lualine.lua`, `bufferline.lua`):** Enhances the visual feedback loop with optimized status lines and modern Neovim utility collections.

> **💡 Custom Keymaps:** A comprehensive breakdown of all custom shortcuts and leader-key bindings is maintained locally in `nvim/.config/nvim/KEYMAPS.md`. The entire environment is strictly keyboard-centric, rewarding touch typing optimization and muscle memory by keeping hands firmly on the home row.

---

## 🧬 Nix Environments (`templates/`)

Project-level isolation is handled natively by Nix Flakes (`flake.nix`). To initialize, simply copy the desired template and run `echo "use flake" > .envrc && direnv allow`. 

XDG cache variables (like `$GOPATH`, `$CARGO_HOME`, `$PIP_CACHE_DIR`, and `$MAVEN_OPTS`) are **injected dynamically via `shellHook`** only when a project is active, leaving the base system entirely clean.

### ☕ `java-spring`
- **Runtime & Build:** JDK 21, Maven, Gradle, Spring Boot CLI.
- **IDE Tooling:** Includes JDTLS, Google Java Format, Lombok, YAML/XML LSPs, and Neovim DAP bundles (`vscode-java-debug`, `vscode-java-test`).
- **Database CLI:** Embeds `psql` and `mysql` binaries for seamless Neovim `vim-dadbod` integration without host installation.

### 🧪 `multi-lang`
- **Polyglot Lab:** Complete LSPs, formatters, and linters for Nix, Java, Node.js, Python (`pyright`, `ruff`), Go, Rust, Bash, and Lua.
- **Python Isolation:** Automatically crafts a `.build/pip` directory to encapsulate dependencies directly inside the project tree.
