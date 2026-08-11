# Neovim Configuration Wiki & Keymaps Reference

Documentation and cheatsheet for your modular Neovim setup. Built with standard Vim conventions, explicit Leader key groupings, and LSP/debugging tools tailored for polyglot development (including Java/Spring ecosystem, database operations, and HTTP clients).

---

## 1. Core Architecture & Settings

### Architecture Overview
- **`init.lua`**: Entrypoint. Sets leader keys and boots the `config` module.
- **`lua/config/`**: Core configuration layer.
  - **`options.lua`**: Vim options (`vim.opt`).
  - **`keymaps.lua`**: Non-plugin global keybindings.
  - **`autocmds.lua`**: Event listeners (`TextYankPost`, auto-resizing, quick-close).
  - **`lazy.lua`**: Bootstrap and setup for `lazy.nvim`.
- **`lua/config/plugins/`**: Modular plugin specs (`*.lua`). Each plugin or tooling suite (LSP, DAP, Git, Treesitter) maintains its own isolated configuration file.

### Directory Structure
```text
.config/nvim/
├── init.lua
├── lazy-lock.json
└── lua
    └── config
        ├── autocmds.lua
        ├── keymaps.lua
        ├── lazy.lua
        ├── options.lua
        └── plugins/
            └── <plugin-spec>.lua   # Modular plugin configurations
```

### Global Options (options.lua)
- Indentation: 2-space soft tabs (`tabstop = 2`, `shiftwidth = 2`, `expandtab = true`, `smartindent = true`).
- Line Numbers: Hybrid relative numbers (`number = true`, `relativenumber = true`).
- System Integration: System clipboard sync (`clipboard = "unnamedplus"`), persistent undo history (`undofile = true`).
- UI/Performance: `termguicolors` enabled, `updatetime = 250ms`, `scrolloff = 8`, disabled swap/backup files.

### Autocommands (autocmds.lua)
- Yank Highlight: Visual confirmation on `TextYankPost` (`timeout = 200ms`).
- Cursor Persistence: Restores position on `BufReadPost`.
- Split Auto-Equalize: Balance splits automatically on `VimResized`.
- Quick Close: Press `q` to dismiss utility windows (`help`, `lspinfo`, `trouble`, `qf`, `checkhealth`, `notify`, `gitsigns-blame`, `spectre_panel`, `man`, `startuptime`).

---

## 2. Global Keymaps (keymaps.lua)

| Mode | Keybinding | Command / Action | Description |
| :--- | :--- | :--- | :--- |
| Normal | `<Esc>` | `<cmd>nohlsearch<cr>` | Clear search highlight matches |
| Normal | `<leader>w` | `<cmd>w<cr>` | Save current buffer |
| Normal | `<leader>q` | `<cmd>q<cr>` | Close current window |
| N / I / V | `<C-s>` | `<cmd>w<cr>` | Save buffer across all operational modes |
| Normal | `<C-h>` | `<C-w>h` | Shift window focus left |
| Normal | `<C-j>` | `<C-w>j` | Shift window focus down |
| Normal | `<C-k>` | `<C-w>k` | Shift window focus up |
| Normal | `<C-l>` | `<C-w>l` | Shift window focus right |
| Normal | `<C-d>` | `<C-d>zz` | Half-page jump down (cursor centered) |
| Normal | `<C-u>` | `<C-u>zz` | Half-page jump up (cursor centered) |
| Normal | `n` | `nzzzv` | Go to next search match (centered) |
| Normal | `N` | `Nzzzv` | Go to previous search match (centered) |
| Normal | `<A-j>` | `<cmd>m .+1<cr>==` | Move current line down |
| Normal | `<A-k>` | `<cmd>m .-2<cr>==` | Move current line up |
| Insert | `<A-j>` | `<cmd>m .+1<cr>==gi` | Move current line down |
| Insert | `<A-k>` | `<cmd>m .-2<cr>==gi` | Move current line up |
| Visual | `<A-j>` | `:m '>+1<cr>gv=gv` | Move selection down |
| Visual | `<A-k>` | `:m '<-2<cr>gv=gv` | Move selection up |
| Visual | `<` | `<gv` | Shift indent left (preserve selection) |
| Visual | `>` | `>gv` | Shift indent right (preserve selection) |
| Visual Select | `<leader>p` | `"_dP` | Paste over selection without modifying register |

---

## 3. Leader Prefixes (which-key.lua)

The `<leader>` key is mapped to `Space`. Major key groups are organized as follows:

```text
<leader>
├── b  -> Buffer Management
├── c  -> Code / LSP Operations
├── d  -> Debugging (DAP)
├── f  -> Find / Snacks Picker
├── g  -> Git Global Actions
├── h  -> Git Hunk Navigation
├── j  -> Java / Spring Extensions
├── n  -> Notifications
├── r  -> Refactoring / Rename
└── x  -> Trouble / Diagnostics
```

---

## 4. Plugin Keymaps Reference

### File Management (oil.lua)
| Mode | Keybinding | Command | Description |
| :--- | :--- | :--- | :--- |
| Normal | `-` | `Oil` | Open parent directory in buffer-based editor |
| Normal | `<leader>fe` | `Oil --float` | Toggle floating file explorer panel |

### Diagnostics & Workspace Issues (trouble.lua)
| Mode | Keybinding | Command | Description |
| :--- | :--- | :--- | :--- |
| Normal | `<leader>xx` | `Trouble diagnostics toggle` | Toggle workspace diagnostics panel |
| Normal | `<leader>xX` | `Trouble diagnostics toggle filter.buf=0` | Toggle current buffer diagnostics |
| Normal | `<leader>cs` | `Trouble symbols toggle` | Toggle document symbols outline |
| Normal | `<leader>cl` | `Trouble lsp toggle focus=false` | Toggle LSP definitions / references view |
| Normal | `<leader>xL` | `Trouble loclist toggle` | Toggle location list |
| Normal | `<leader>xQ` | `Trouble qflist toggle` | Toggle quickfix list |
| Normal | `[x` | `trouble.prev()` | Jump to previous diagnostic item |
| Normal | `]x` | `trouble.next()` | Jump to next diagnostic item |

### Fuzzy Finder, Picker & Utilities (snacks.lua)
| Mode | Keybinding | Command / Callback | Description |
| :--- | :--- | :--- | :--- |
| Normal | `<leader>ff` | `Snacks.picker.files()` | Search files in project root |
| Normal | `<leader>fg` | `Snacks.picker.grep()` | Search string patterns (Live Grep) |
| Normal | `<leader>fb` | `Snacks.picker.buffers()` | List and switch active buffers |
| Normal | `<leader>fh` | `Snacks.picker.help()` | Search Neovim help tags |
| Normal | `<leader>fr` | `Snacks.picker.recent()` | Search recently opened files |
| Normal | `<leader>fc` | `Snacks.picker.config()` | Search Neovim configuration files |
| Normal | `<leader>fn` | `Snacks.notifier.show_history()` | Display notification history overlay |
| Normal | `<leader>un` | `Snacks.notifier.hide()` | Dismiss active notifications |
| Normal | `<leader>bd` | `Snacks.bufdelete()` | Safely delete current buffer |
| Normal | `<leader>gg` | `Snacks.lazygit()` | Toggle LazyGit floating UI |
| Normal | `<leader>gB` | `Snacks.git.blame_line()` | Toggle inline Git blame context |

### Language Server Protocol (lsp.lua)
| Mode | Keybinding | Action / Command | Description |
| :--- | :--- | :--- | :--- |
| Normal | `gd` | `vim.lsp.buf.definition()` | Jump to definition |
| Normal | `gD` | `vim.lsp.buf.declaration()` | Jump to declaration |
| Normal | `gi` | `vim.lsp.buf.implementation()` | Jump to implementation |
| Normal | `gr` | `vim.lsp.buf.references()` | List code references |
| Normal | `K` | `vim.lsp.buf.hover()` | Show documentation under cursor |
| Normal | `<leader>rn` | `vim.lsp.buf.rename()` | Rename symbol project-wide |
| Normal | `<leader>ca` | `vim.lsp.buf.code_action()` | Trigger context code actions |
| Normal | `[d` | `vim.diagnostic.goto_prev()` | Go to previous diagnostic |
| Normal | `]d` | `vim.diagnostic.goto_next()` | Go to next diagnostic |
| Normal | `<leader>cd` | `vim.diagnostic.open_float()` | Show line diagnostic floating window |

### Code Formatting (conform.lua)
| Mode | Keybinding | Action | Description |
| :--- | :--- | :--- | :--- |
| N / V | `<leader>cf` | `conform.format()` | Format current buffer or visual selection |

### Git Integration (gitsigns.lua)
| Mode | Keybinding | Command | Description |
| :--- | :--- | :--- | :--- |
| Normal | `]h` | `Gitsigns next_hunk` | Jump to next git hunk |
| Normal | `[h` | `Gitsigns prev_hunk` | Jump to previous git hunk |
| Normal | `<leader>hs` | `Gitsigns stage_hunk` | Stage current hunk |
| Normal | `<leader>hr` | `Gitsigns reset_hunk` | Reset current hunk modifications |
| Normal | `<leader>hp` | `Gitsigns preview_hunk` | Preview hunk diff in floating window |
| Normal | `<leader>hb` | `Gitsigns blame_line` | Trigger full blame for active line |

### Debug Adapter Protocol (dap.lua)
| Mode | Keybinding | Command | Description |
| :--- | :--- | :--- | :--- |
| Normal | `<leader>db` | `dap.toggle_breakpoint()` | Toggle breakpoint on target line |
| Normal | `<leader>dB` | `dap.set_breakpoint(...)` | Set conditional breakpoint |
| Normal | `<leader>dc` | `dap.continue()` | Start or continue execution |
| Normal | `<leader>di` | `dap.step_into()` | Step into function |
| Normal | `<leader>do` | `dap.step_over()` | Step over line/function |
| Normal | `<leader>dO` | `dap.step_out()` | Step out of scope |
| Normal | `<leader>dt` | `dap.terminate()` | Terminate debug session |
| Normal | `<leader>du` | `dapui.toggle()` | Toggle DAP interface panels |

### Java & Spring Development (java.lua)
| Mode | Keybinding | Command | Description |
| :--- | :--- | :--- | :--- |
| Normal | `<leader>jo` | `jdtls.organize_imports()` | Clean up and organize Java imports |
| Normal | `<leader>jt` | `jdtls.test_class()` | Execute test suite for active class |
| Normal | `<leader>jn` | `jdtls.test_nearest_method()` | Execute closest test method |
| Normal | `<leader>jr` | `Spring Boot Run` | Initialize local Spring Boot runner |

### Database Management (dadbod.lua)
| Mode | Keybinding | Command | Description |
| :--- | :--- | :--- | :--- |
| Normal | `<leader>Du` | `DBUIToggle` | Toggle database manager panel |
| Normal | `<leader>Df` | `DBUIFindBuffer` | Locate active database query buffer |
| Normal | `<leader>Dr` | `DBUIRenameBuffer` | Rename current SQL execution buffer |

### REST & HTTP Client (rest.lua)
| Mode | Keybinding | Command | Description |
| :--- | :--- | :--- | :--- |
| Normal | `<leader>rs` | `Rest run` | Execute HTTP request under cursor |
| Normal | `<leader>rl` | `Rest run last` | Re-run last executed HTTP request |

### Text Objects & Navigation (treesitter.lua)
#### Text Object Selection (Visual & Operator Pending)
| Keybinding | Target / Query | Description |
| :--- | :--- | :--- |
| `af` | Outer Function | Select entire function definition |
| `if` | Inner Function | Select function body |
| `ac` | Outer Class | Select entire class structure |
| `ic` | Inner Class | Select class body |
| `aa` | Outer Parameter | Select function argument/parameter |
| `ia` | Inner Parameter | Select parameter content |

#### AST Navigation Motions (Normal Mode)
| Keybinding | Motion | Description |
| :--- | :--- | :--- |
| `]m` / `[m` | Next / Prev Function Start | Jump to start of next/previous method |
| `]M` / `[M` | Next / Prev Function End | Jump to end of next/previous method |
| `]]` / `[[` | Next / Prev Class Start | Jump to start of next/previous class |
| `][` / `[]` | Next / Prev Class End | Jump to end of next/previous class |

### Text Objects & Surround (surround.lua)
- Add Surround: `ys{motion}{char}` (e.g., `ysiw"` wraps inner word in double quotes)
- Delete Surround: `ds{char}` (e.g., `ds"` removes surrounding double quotes)
- Change Surround: `cs{target}{replacement}` (e.g., `cs"'` changes surrounding double quotes to single quotes)

---

## 5. Maintenance Commands

```vim
" Plugin Manager Maintenance
:Lazy           " Open lazy.nvim control panel
:Lazy sync      " Update and clean installed plugins
:Lazy health    " Check plugin configuration health

" Environment Verification
:checkhealth    " Run system diagnostic suite
:LspInfo        " Display attached LSP clients and status
