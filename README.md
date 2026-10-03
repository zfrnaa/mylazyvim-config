# ⚡ Portable LazyVim Configuration

A clean, reproducible, cross-platform [LazyVim](https://www.lazyvim.org/) configuration optimized for fast development workflows across **Windows**, **macOS**, and **Linux**.

---

## ✨ Features & Highlights

- 🎨 **Aesthetic & Theme**: Clean Gruvbox theme (`ellisonleao/gruvbox.nvim`) configured with native background transparency for terminal compositors.
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

### Snacks & Git
| Key | Mode | Description |
| :--- | :--- | :--- |
| `<leader>gg` | Normal | Open LazyGit scoped to the current buffer's directory |
| `<leader>gl` | Normal | Open LazyGit commit log |
| `<leader>xx` | Normal | Toggle built-in diagnostics problems list (Quickfix) |

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
    │   ├── mssql.lua      # MSSQL runner & keybindings
    │   ├── python.lua     # Cross-platform venv autodetection for Pyright
    │   ├── snacks.lua     # Snacks.nvim (scroll, statuscolumn, lazygit, quickfix)
    │   └── sql-utils.lua  # SQL formatting via conform.nvim
    └── utils/
        └── history_wiper.lua # Inactivity-based & manual history cleaner
```

---

## 🔧 Customization & Updating

- **Add Plugins**: Place new plugin specifications in `lua/plugins/*.lua`. LazyVim will automatically load them.
- **Update Plugins**: Run `:Lazy` inside Neovim and press `U` to update plugins. Lock changes with `:Lazy log` or commit the updated `lazy-lock.json`.
- **Formatting**: Run `stylua .` to format the Lua codebase according to `stylua.toml`.
