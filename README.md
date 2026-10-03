# ⚡ Portable LazyVim Configuration

A clean, reproducible, cross-platform [LazyVim](https://www.lazyvim.org/) configuration optimized for fast development workflows across **Windows**, **macOS**, and **Linux**.

---

## ✨ Features & Highlights

- 🎨 **Aesthetic & UI Suite**:
  - **Gruvbox Theme**: Clean Gruvbox theme (`ellisonleao/gruvbox.nvim`) configured with native background transparency for terminal compositors.
  - **Rounded Pill Lualine Statusline**: Gruvbox-themed statusline (`nvim-lualine/lualine.nvim`) with rounded bubble separators (`` / ``) and real-time macro recording indicator (`󰑋 @<reg>`).
  - **Snacks Dashboard**: Custom Neovim ASCII banner with quick action keybindings (`f` find, `n` new, `g` grep, `r` recent, `c` config, `l` lazy, `q` quit).
  - **Scope-Aware Indent Guides**: Subtle vertical guide lines (`│`) with active Treesitter/syntax scope highlighting powered by `snacks.nvim`.
- ⚡ **Productivity & Navigation Suite**:
  - **Harpoon 2** (`ThePrimeagen/harpoon`): Lightning-fast file bookmarking and switching across your 4 most frequented buffers (`<leader>1`-`<leader>4`, `<leader>ha`, `<leader>hh`, `<leader>hn`, `<leader>hp`).
  - **Flash.nvim** (`folke/flash.nvim`): Next-generation code navigation with search labels (`s`), Treesitter node selection (`S`), and operator-pending remote motions (`r`).
  - **Undotree** (`mbbill/undotree`): Visual undo history tree explorer (`<leader>gu`) to inspect and revert changes across branching edit sessions.
  - **Todo-Comments** (`folke/todo-comments.nvim`): Syntax highlighting and rapid navigation for `TODO`, `FIXME`, `HACK`, `PERF`, `NOTE`, and `WARN` comments (`]t`, `[t`), with workspace search via Snacks picker (`<leader>st`).
- ⌨️ **Ergonomic Keymaps**: Seamless exit from insert mode with `jk`.
- 🍿 **Snacks.nvim Integration**:
  - Smooth terminal scrolling.
  - Modern, minimalist statuscolumn.
  - Quick Git integration via LazyGit (`<leader>gg` in current file's directory, `<leader>gl` for commit log).
  - One-touch toggle for built-in diagnostic problems (`<leader>xx`).
- 🐍 **Smart Python LSP**: Automatic virtual environment detection for Pyright LSP (seamlessly handles Windows `.venv\Scripts\python.exe` and Unix `.venv/bin/python`).
- 🗄️ **Database & SQL**:
  - MSSQL Runner (`Kurren123/mssql.nvim`) with SSMS-style `<F5>` query execution, `<leader>mc` connect, and `<leader>mn` new query.
  - On-demand SQL formatting via `conform.nvim` using `sql-formatter`.
- 🧹 **Privacy & History Wiper**:
  - Automatic cleanup of Neovim ShaDa command and yank history after 3+ days of inactivity.
  - On-demand manual purge via `:ClearHistory`.
- 📦 **Preconfigured LazyVim Extras**:
  - Languages & Tools: `docker`, `git`, `java`, `markdown`, `php`, `python`, `sql`, `yaml`
  - Productivity & UI: `prettier`, `yanky`, `mini-animate`

---

## 🛠️ Prerequisites & Recommendations

To make full use of all plugins and LSP servers, ensure the following tools are installed:

| Tool | Purpose | Windows (`winget`) | macOS (`brew`) | Linux (`apt` / `pacman`) |
| :--- | :--- | :--- | :--- | :--- |
| **Neovim** (>= 0.10.0) | Core Editor | `winget install Neovim.Neovim` | `brew install neovim` | Package manager |
| **Git** | Plugin & Version Control | `winget install Git.Git` | `brew install git` | `apt install git` |
| **Ripgrep (`rg`)** | Fast code & file search | `winget install BurntSushi.ripgrep.MSVC` | `brew install ripgrep` | `apt install ripgrep` |
| **fd** | Fast directory traversal | `winget install sharkdp.fd` | `brew install fd` | `apt install fd-find` |
| **LazyGit** | Terminal Git UI | `winget install JesseDuffield.lazygit` | `brew install lazygit` | Package manager / go |
| **Node.js** | Mason LSPs & SQL formatting | `winget install OpenJS.NodeJS` | `brew install node` | `apt install nodejs npm` |
| **Python** | Python tooling & LSPs | `winget install Python.Python.3.12` | `brew install python` | `apt install python3` |
| **sqlcmd** | MSSQL query execution | `winget install Microsoft.SqlCmd` | `brew install sqlcmd` | `mssql-tools` / package manager |

> [!TIP]
> For SQL formatting support, install `sql-formatter` globally with Node.js:
> ```bash
> npm install -g sql-formatter
> ```

---

## 🚀 Installation

Clone this repository and run the included turnkey installation script for your operating system.

### Windows (PowerShell)

```powershell
# 1. Clone this repository to your preferred location
git clone https://github.com/your-username/mylazyvim-config.git "$HOME\Documents\dev-projects\mylazyvim-config"
cd "$HOME\Documents\dev-projects\mylazyvim-config"

# 2. Run the installer (backs up existing config, creates link, checks prereqs)
.\install.ps1
```

> **Note on Windows permissions**: `install.ps1` automatically tries to create a Directory Symbolic Link first. If Developer Mode is disabled or privileges are insufficient, it seamlessly falls back to creating a Directory Junction (`mklink /J`), which requires **no administrative privileges**.

### Linux / macOS (Bash / Zsh)

```bash
# 1. Clone this repository
git clone https://github.com/your-username/mylazyvim-config.git "$HOME/.config/mylazyvim-config"
cd "$HOME/.config/mylazyvim-config"

# 2. Run the installer
chmod +x ./install.sh
./install.sh
```

The script will back up any existing `~/.config/nvim` directory with a timestamped extension (`.bak.<timestamp>`), create a symlink pointing to the cloned repository, and prompt you to run `nvim`.

---

## ⌨️ Key Keybindings Cheat Sheet

### General & Navigation
| Key | Mode | Description |
| :--- | :--- | :--- |
| `jk` | Insert | Exit insert mode to normal mode |
| `<leader>qq` | Normal | Quit Neovim |
| `<leader>w` | Normal | Save file |

### Motion & Jumping (Flash.nvim)
| Key | Mode | Description |
| :--- | :--- | :--- |
| `s` | Normal, Visual, Operator | Flash jump to search target |
| `S` | Normal, Visual, Operator | Flash Treesitter node selection |
| `r` | Operator-pending | Remote Flash jump |

### Quick Buffer Switching (Harpoon 2)
| Key | Mode | Description |
| :--- | :--- | :--- |
| `<leader>ha` | Normal | Add current buffer to Harpoon list |
| `<leader>hh` | Normal | Toggle Harpoon quick menu UI |
| `<leader>1` - `<leader>4` | Normal | Instantly jump to Harpoon mark 1 through 4 |
| `<leader>hn` | Normal | Jump to next Harpoon file |
| `<leader>hp` | Normal | Jump to previous Harpoon file |

### Git & Undo History
| Key | Mode | Description |
| :--- | :--- | :--- |
| `<leader>gg` | Normal | Open LazyGit scoped to the current buffer's directory |
| `<leader>gl` | Normal | Open LazyGit commit log |
| `<leader>gu` | Normal | Toggle Undo Tree visual branch history browser |

### Diagnostics & Todo-Comments (Snacks & Trouble)
| Key | Mode | Description |
| :--- | :--- | :--- |
| `<leader>xx` | Normal | Toggle built-in diagnostics problems list (Quickfix) |
| `<leader>st` | Normal | Search Todo comments workspace-wide via Snacks Picker |
| `]t` | Normal | Jump to next Todo comment |
| `[t` | Normal | Jump to previous Todo comment |

### Snacks Dashboard (Startup Screen)
| Key | Description | Action |
| :--- | :--- | :--- |
| `f` | Find File | Search project files via Snacks picker |
| `n` | New File | Open new empty buffer and enter insert mode |
| `g` | Find Text | Live grep across workspace via Snacks picker |
| `r` | Recent Files | Search recent files via Snacks picker |
| `c` | Config | Browse Neovim configuration files |
| `l` | Lazy | Open Lazy.nvim plugin manager |
| `q` | Quit | Quit Neovim |

### Database & MSSQL
| Key | Mode | Description |
| :--- | :--- | :--- |
| `<F5>` | Normal | Execute T-SQL Query (SSMS Style) |
| `<leader>me` | Normal | Execute T-SQL Query |
| `<leader>mc` | Normal | Connect to MSSQL Server |
| `<leader>mn` | Normal | Open New T-SQL Query Window |
| `<leader>cf` | Normal | Format buffer (uses `sql-formatter` for SQL) |

### ShaDa & History Wiper
| Command | Mode | Description |
| :--- | :--- | :--- |
| `:ClearHistory` | Command | Instantly wipe command history, search history, yank registers, and physical ShaDa file |

---

## 📂 Repository Structure

```
├── .gitignore             # Standard ignore rules (logs, swap files, local shada)
├── init.lua               # Bootstrap entry point & history wiper initializer
├── install.ps1            # Windows automated installer (symlink/junction)
├── install.sh             # Linux/macOS automated installer (symlink)
├── lazy-lock.json         # Pinned reproducible plugin versions
├── lazyvim.json           # Enabled LazyVim extras and version info
├── stylua.toml            # Lua code formatter configuration
├── README.md              # Documentation
└── lua/
    ├── config/
    │   ├── autocmds.lua   # Custom user autocommands
    │   ├── keymaps.lua    # Custom keymaps (e.g., jk escape)
    │   ├── lazy.lua       # Lazy.nvim plugin manager configuration
    │   └── options.lua    # Global Neovim options (timeoutlen, wrap)
    ├── plugins/
    │   ├── colorscheme.lua# Transparent Gruvbox theme configuration
    │   ├── flash.lua      # Flash.nvim motion & jumping (s, S, r)
    │   ├── git-conflict.lua # Inline git merge conflict resolution
    │   ├── harpoon.lua    # Harpoon 2 fast file navigation
    │   ├── lualine.lua    # Gruvbox pill statusline with macro recorder
    │   ├── mssql.lua      # MSSQL runner & keybindings
    │   ├── python.lua     # Cross-platform venv autodetection for Pyright
    │   ├── snacks.lua     # Snacks.nvim (dashboard, indent guides, scroll, statuscolumn, lazygit)
    │   ├── sql-utils.lua  # SQL formatting via conform.nvim
    │   ├── todo-comments.lua # Todo-comments highlighting & picker integration
    │   └── undotree.lua   # Visual undo history browser (<leader>gu)
    └── utils/
        └── history_wiper.lua # Inactivity-based & manual history cleaner
```

---

## 🔧 Customization & Updating

- **Add Plugins**: Place new plugin specifications in `lua/plugins/*.lua`. LazyVim will automatically load them.
- **Update Plugins**: Run `:Lazy` inside Neovim and press `U` to update plugins. Lock changes with `:Lazy log` or commit the updated `lazy-lock.json`.
- **Formatting**: Run `stylua .` to format the Lua codebase according to `stylua.toml`.
