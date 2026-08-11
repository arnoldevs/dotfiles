# 🛠️ System Dotfiles & Development Ecosystem

Ecosistema de configuración modular enfocado en rendimiento, reproducibilidad y desarrollo aislado utilizando **Debian**, **Neovim (LazyVim)**, **Nix (Flakes + Direnv)** y **WezTerm**.

---

## 📋 Tabla de Contenidos

- [Vista General](#-vista-general)
- [Prerrequisitos del Sistema](#-prerrequisitos-del-sistema)
  - [Paquetes Base](#paquetes-base)
  - [Nix (Determinate Systems)](#nix-determinate-systems)
  - [Nerd Fonts](#-fuentes-nerd-fonts)
  - [WezTerm](#-emulador-de-terminal-wezterm)
- [Estructura del Repositorio](#-estructura-del-repositorio)
- [Instalación y Despliegue](#-instalación-y-despliegue)
- [Componentes Principales](#-componentes-principales)
  - [Terminal & Shell (WezTerm + Bash)](#terminal--shell-wezterm--bash)
  - [Editor de Texto (Neovim / LazyVim)](#editor-de-texto-neovim--lazyvim)
  - [Entornos de Desarrollo (Nix + Direnv)](#entornos-de-desarrollo-nix--direnv)
- [Mantenimiento y Comandos Útiles](#-mantenimiento-y-comandos-útiles)

---

## 🥊 Vista General

Este repositorio gestiona el entorno de desarrollo bajo los siguientes principios:

* **Persistencia limpia (XDG Spec):** Redirección masiva de cachés (`.cache/cargo`, `.cache/m2`, `.cache/go`, etc.) para mantener `$HOME` despejado.
* **Desarrollo inmutable por proyecto:** Nix Flakes + Direnv gestionan LSPs, formateadores y toolchains sin contaminar la instalación global del sistema operativo.
* **Flujo de trabajo optimizado:** Neovim integrado con binarios locales heredados del entorno del shell (`PATH`), sin dependencia de gestores de binarios de terceros dentro del editor.

---

## 🧰 Prerrequisitos del Sistema

### Paquetes Base

Instala las herramientas fundamentales antes de desplegar las configuraciones:

```bash
sudo apt update && sudo apt install -y \
    git \
    curl \
    build-essential \
    unzip \
    ripgrep \
    fd-find \
    fzf \
    stow
```

### Nix (Determinate Systems)

Se utiliza el instalador de **Determinate Systems** por su estabilidad, gestión automática de servicios y soporte nativo habilitado para Flakes:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://install.determinate.systems/nix | sh -- daemon-install
```

> **Nota:** Este instalador habilita automáticamente `nix-command` y `flakes`, por lo que no requiere configuración adicional en `nix.conf`.

### 🔤 Fuentes (Nerd Fonts)

Para la correcta visualización de iconos y símbolos en la terminal y el editor (Neovim, status de Git, árboles de archivos), se requiere una fuente parcheada de **Nerd Fonts**:

```bash
mkdir -p ~/.local/share/fonts
cd /tmp
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts/
rm JetBrainsMono.zip
fc-cache -fv
```

### 🖥️ Emulador de Terminal (WezTerm)

WezTerm provee aceleración por GPU, verdadero color (24-bit) y configuración programable en Lua:

```bash
# Agregar repositorio oficial e instalar en Debian
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/wezterm-archive-keyring.gpg] https://apt.fury.io/wez/ * *" | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update && sudo apt install wezterm
```

---

## 📁 Estructura del Repositorio

```text
.
├── .config/
│   ├── nvim/             # Configuración modular de Neovim (LazyVim base)
│   │   ├── init.lua
│   │   └── lua/
│   │       ├── config/   # Opciones, keymaps y autocomandos
│   │       └── plugins/  # Especificaciones de plugins (LSP, UI, Tools)
│   ├── wezterm/          # Configuración de WezTerm (wezterm.lua)
│   └── nix/              # Configuraciones globales de Nix
├── .bashrc               # Shell rc con alias, exports XDG y hooks (direnv)
├── templates/            # Plantillas de Nix Flakes para proyectos
│   ├── multi-lang/       # Flake laboratorio (Java, Go, Rust, Python, TS, Lua, Shell)
│   └── java-spring/      # Flake dedicado a Java 21 + Spring Boot + Gradle/Maven
└── README.md
```

---

## 🚀 Instalación y Despliegue

### 1. Clonar el Repositorio

```bash
git clone https://github.com/TU_USUARIO/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Crear Enlaces Simbólicos (Symlinks)

Puedes utilizar GNU `stow` o enlazar los directorios manualmente:

```bash
# Mediante enlaces simbólicos directos:
ln -sfn ~/.dotfiles/.config/nvim ~/.config/nvim
ln -sfn ~/.dotfiles/.config/wezterm ~/.config/wezterm
ln -sf ~/.dotfiles/.bashrc ~/.bashrc

# Recargar configuración de Bash
source ~/.bashrc
```

---

## 🧩 Componentes Principales

### Terminal & Shell (WezTerm + Bash)

* **WezTerm:** Mapeo de portapapeles, fuentes de alta densidad y renderizado asistido por GPU.
* **Bash:** Configurado con variables XDG globales para aislamiento de cachés:
  * `GOPATH` / `GOCACHE` $\rightarrow$ `$XDG_CACHE_HOME/go`
  * `CARGO_HOME` $\rightarrow$ `$XDG_CACHE_HOME/cargo`
  * `PIP_CACHE_DIR` $\rightarrow$ `$XDG_CACHE_HOME/pip`
  * `MAVEN_OPTS` $\rightarrow$ `-Dmaven.repo.local=$XDG_CACHE_HOME/m2`

### Editor de Texto (Neovim / LazyVim)

Configuración orientada a integrarse con herramientas declaradas en el sistema o en el shell de Nix:

* **LSP (`nvim-lspconfig`):** Configurado nativamente utilizando `vim.lsp.config` sin dependencia de gestores de binarios externos.
* **Formateo (`conform.nvim`):** Detección dinámica de ejecutables en el `PATH` (`stylua`, `prettierd`, `google-java-format`, `ruff`, `shfmt`).
* **Sintaxis (`nvim-treesitter`):** Manejo de parsers de sintaxis integrados.
* **UI/Utilidades (`snacks.nvim`):** Gestión eficiente de buffers, terminales flotantes y notificaciones.

### Entornos de Desarrollo (Nix + Direnv)

Para iniciar un proyecto con LSPs y herramientas aisladas:

1. **Copiar plantilla al proyecto objetivo:**
   ```bash
   cp -r ~/.dotfiles/templates/multi-lang/flake.nix ./
   ```
2. **Crear o actualizar `.envrc`:**
   ```bash
   echo "use flake" > .envrc
   direnv allow
   ```
3. Al entrar al directorio, `direnv` cargará automáticamente los ejecutables (`pyright`, `gopls`, `rust-analyzer`, `jdtls`, etc.) en el `PATH`, haciendo que Neovim los reconozca de manera automática.

---

## ⚙️ Mantenimiento y Comandos Útiles

| Acción | Comando |
| :--- | :--- |
| **Actualizar plugins de Neovim** | Abrir `nvim` y ejecutar `:Lazy update` |
| **Limpiar caché/basura de Nix** | `nix-store --gc` / `nix-collect-garbage -d` |
| **Actualizar locks de Flakes** | `nix flake update` *(dentro del directorio del proyecto)* |
| **Verificar estado de Direnv** | `direnv status` |
