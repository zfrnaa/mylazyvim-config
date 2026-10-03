# Design Specification: Aesthetic & Productivity Suite

## 1. Overview
This specification details the addition of curated aesthetic enhancements and high-velocity workflow tools to the LazyVim setup at `C:\Users\frant\Documents\dev-projects\mylazyvim-config` (mirrored to `$LOCALAPPDATA/nvim`).

The goal is to maintain the lightweight, portable, fast-startup nature of the configuration while adding visual polish (custom dashboard, scope-aware indent guides, refined Gruvbox statusline) and keyboard-driven productivity tools (Harpoon 2, Undotree, Flash, Todo-comments).

---

## 2. Architecture & Plugin Breakdown

### 2.1 Aesthetic Enhancements

#### 2.1.1 Snacks Dashboard (`lua/plugins/snacks.lua`)
- **ASCII Banner**: Centered stylized Neovim header.
- **Action Buttons**:
  - `f` / `<leader>ff`: Find File
  - `r` / `<leader>fr`: Recent Files
  - `g` / `<leader>sg`: Grep / Find Text
  - `p` / `<leader>fp`: Projects
  - `c` / `<leader>fc`: Neovim Config
  - `q`: Quit
- **Dynamic Widgets**:
  - Live Git status widget (shows recent branch/changes if in a Git repo).
  - Startup time benchmark indicator (e.g. `⚡ Neovim loaded in X ms`).

#### 2.1.2 Scope & Indent Guides (`lua/plugins/snacks.lua`)
- Enable `snacks.indent` with subtle line characters (`│`).
- Enable active scope tracking (`scope = { enabled = true }`) to visually highlight the current block/function context.

#### 2.1.3 Gruvbox Lualine Polish (`lua/plugins/ui.lua`)
- Seamless transparent background matching Gruvbox transparent mode.
- Rounded/pill separators.
- Statusline sections:
  - Mode badge
  - Git branch & diff counters
  - LSP Diagnostics
  - Active filename with dirty/readonly indicator
  - Macro recording indicator (`recording @...`)
  - Filetype, file encoding, cursor position

---

### 2.2 Productivity Powerhouses

#### 2.2.1 Harpoon 2 (`lua/plugins/harpoon.lua`)
- **Plugin**: `ThePrimeagen/harpoon` (branch `harpoon2`), depending on `nvim-lua/plenary.nvim`.
- **Keybindings**:
  - `<leader>ha`: Add current file to Harpoon list.
  - `<leader>hh`: Toggle Harpoon quick menu (floating list).
  - `<leader>1`: Switch to file 1.
  - `<leader>2`: Switch to file 2.
  - `<leader>3`: Switch to file 3.
  - `<leader>4`: Switch to file 4.
  - `<leader>hn`: Next Harpoon buffer.
  - `<leader>hp`: Previous Harpoon buffer.

#### 2.2.2 Undotree (`lua/plugins/undotree.lua`)
- **Plugin**: `mbbill/undotree`.
- **Keybinding**: `<leader>gu` (grouped with Git/history tools like LazyGit `<leader>gg` and Git Log `<leader>gl`).
- **Options**: Ensure `vim.opt.undofile = true` is active for persistent undo across editor restarts.

#### 2.2.3 Flash.nvim (`lua/plugins/flash.lua`)
- **Plugin**: `folke/flash.nvim`.
- **Keybindings**:
  - `s`: Jump anywhere on screen using 2-letter search + character tag.
  - `S`: Treesitter node selection jump.
  - `r`: Remote flash (in operator-pending mode, e.g. `yr` to yank remote text).

#### 2.2.4 Todo-Comments (`lua/plugins/todo-comments.lua`)
- **Plugin**: `folke/todo-comments.nvim`.
- **Keywords**: `TODO`, `FIXME`, `BUG`, `NOTE`, `HACK`, `WARN`.
- **Keybindings**:
  - `]t`: Jump to next TODO comment.
  - `[t`: Jump to previous TODO comment.
  - `<leader>st`: Search all workspace TODO comments with Snacks picker.

---

## 3. Testing & Verification Plan

1. **Syntax & Load Check**:
   - Run `nvim --headless "+Lazy! sync" +qa` to download new plugins and update `lazy-lock.json`.
   - Run headless healthcheck `nvim --headless "+checkhealth" +qa` to confirm zero errors.
2. **Interactive UI Verification**:
   - Verify Snacks dashboard displays the ASCII banner and key actions without error.
   - Verify indent guides and active scope highlight when opening a nested code file.
   - Verify lualine renders smoothly with Gruvbox transparent background.
3. **Keymap Verification**:
   - Verify `<leader>gu` toggles Undotree.
   - Verify `<leader>ha` and `<leader>hh` open and navigate Harpoon 2.
   - Verify `s` activates Flash jump labels.
   - Verify `<leader>st` queries TODO comments via Snacks picker.
4. **Git State**:
   - Commit changes to `docs/` and new plugin specs.
