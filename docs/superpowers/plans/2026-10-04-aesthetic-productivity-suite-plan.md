# Aesthetic & Productivity Suite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enhance personal LazyVim setup with aesthetic polish (Snacks dashboard ASCII art, scope-aware indent guides, refined Gruvbox transparent statusline) and keyboard-driven productivity tools (Harpoon 2, Undotree with `<leader>gu`, Flash.nvim, and Todo-comments).

**Architecture:** Utilize native `snacks.nvim` modules for dashboard, indent guides, and pickers to keep startup latency minimal. Layer standalone modular plugins for Harpoon 2, Undotree, Flash, and Todo-comments in `lua/plugins/` adhering to standard LazyVim declarative specifications.

**Tech Stack:** Neovim >= 0.10, Lua, LazyVim, `folke/snacks.nvim`, `ThePrimeagen/harpoon` (harpoon2), `mbbill/undotree`, `folke/flash.nvim`, `folke/todo-comments.nvim`, `nvim-lualine/lualine.nvim`.

## Global Constraints
- Target codebase: `C:\Users\frant\Documents\dev-projects\mylazyvim-config` (junctioned to `$LOCALAPPDATA/nvim`).
- Preserve Gruvbox transparent background styling and high performance (<50ms startup).
- Group Undotree under `<leader>gu`.
- Ensure all plugin specs are idempotent and cross-platform compatible.

---

### Task 1: Persistent Undo Option Configuration

**Files:**
- Modify: `lua/config/options.lua`

**Interfaces:**
- Consumes: Neovim built-in `vim.opt`
- Produces: `vim.opt.undofile = true` ensuring undo history is retained across editor restarts

- [ ] **Step 1: Check existing options.lua**
Inspect `lua/config/options.lua` to ensure clean option setting.

- [ ] **Step 2: Add persistent undofile setting**
Add `vim.opt.undofile = true` to `lua/config/options.lua`.

- [ ] **Step 3: Verify option loaded**
Run:
```powershell
nvim --headless -c "lua assert(vim.opt.undofile:get() == true); print('Undofile verified')" +qa
```
Expected: Prints `Undofile verified` with exit code 0.

- [ ] **Step 4: Commit**
```bash
git add lua/config/options.lua
git commit -m "feat(config): enable persistent undofile option"
```

---

### Task 2: Configure Snacks Dashboard & Scope Indent Guides

**Files:**
- Modify: `lua/plugins/snacks.lua`

**Interfaces:**
- Consumes: `folke/snacks.nvim`
- Produces: Enhanced `opts.dashboard` with ASCII banner, quick navigation, git status widget, startup benchmark, and `opts.indent` with scope tracking enabled.

- [ ] **Step 1: Update snacks.lua with dashboard & indent options**
Enable `dashboard` and `indent` modules with custom header and section items:
```lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Enable smooth scrolling
    scroll = { enabled = true },

    -- lazygit
    lazygit = { enabled = true },

    -- Enable the modern status column
    statuscolumn = { enabled = true },

    -- Keep your explorer/picker active
    explorer = { enabled = true },
    picker = { enabled = true },

    -- Indent & active scope guides
    indent = {
      enabled = true,
      char = "│",
      scope = { enabled = true },
    },

    -- Dashboard configuration
    dashboard = {
      enabled = true,
      preset = {
        header = [[
   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
  },
  keys = {
    {
      "<leader>gg",
      function()
        Snacks.lazygit({ cwd = vim.fn.expand("%:p:h") })
      end,
      desc = "LazyGit",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "LazyGit Log",
    },
    {
      "<leader>xx",
      function()
        local win_found = false
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "qf" then
            win_found = true
            break
          end
        end

        if win_found then
          vim.cmd("cclose")
        else
          vim.diagnostic.setqflist({ open = true })
        end
      end,
      desc = "Toggle Built-in Problems Window",
    },
  },
}
```

- [ ] **Step 2: Verify Snacks configuration syntax and load**
Run:
```powershell
nvim --headless -c "lua require('snacks')" +qa
```
Expected: Exit code 0 without syntax errors.

- [ ] **Step 3: Commit**
```bash
git add lua/plugins/snacks.lua
git commit -m "feat(ui): add snacks dashboard banner and indent scope guides"
```

---

### Task 3: Refine Gruvbox Lualine Configuration

**Files:**
- Create: `lua/plugins/lualine.lua`

**Interfaces:**
- Consumes: `nvim-lualine/lualine.nvim`
- Produces: Transparent pill-style statusline matching Gruvbox with recording indicator.

- [ ] **Step 1: Create lua/plugins/lualine.lua**
Write the lualine configuration:
```lua
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.options = opts.options or {}
    opts.options.theme = "gruvbox"
    opts.options.component_separators = { left = "", right = "" }
    opts.options.section_separators = { left = "", right = "" }

    -- Custom macro recording status component
    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg ~= "" then
        return "󰑋 @" .. reg
      end
      return ""
    end

    table.insert(opts.sections.lualine_x, 1, {
      macro_recording,
      color = { fg = "#fb4934", gui = "bold" },
    })

    return opts
  end,
}
```

- [ ] **Step 2: Verify lualine loads cleanly**
Run:
```powershell
nvim --headless -c "lua require('lazy')" +qa
```
Expected: Exit code 0 without errors.

- [ ] **Step 3: Commit**
```bash
git add lua/plugins/lualine.lua
git commit -m "feat(ui): configure gruvbox rounded pill lualine statusline"
```

---

### Task 4: Add Undotree with `<leader>gu` Mapping

**Files:**
- Create: `lua/plugins/undotree.lua`

**Interfaces:**
- Consumes: `mbbill/undotree`
- Produces: `<leader>gu` toggle for visual undo history window

- [ ] **Step 1: Create lua/plugins/undotree.lua**
Write:
```lua
return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>gu", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
  },
  init = function()
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SplitWidth = 35
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}
```

- [ ] **Step 2: Verify Undotree registration**
Run:
```powershell
nvim --headless -c "lua require('lazy')" +qa
```
Expected: Clean startup without error.

- [ ] **Step 3: Commit**
```bash
git add lua/plugins/undotree.lua
git commit -m "feat(workflow): add undotree mapped to <leader>gu"
```

---

### Task 5: Add Harpoon 2 for High-Speed File Bookmarking

**Files:**
- Create: `lua/plugins/harpoon.lua`

**Interfaces:**
- Consumes: `ThePrimeagen/harpoon` (branch `harpoon2`)
- Produces: Fast file bookmarks (`<leader>ha`, `<leader>hh`, `<leader>1`-`<leader>4`, `<leader>hn`, `<leader>hp`)

- [ ] **Step 1: Create lua/plugins/harpoon.lua**
Write:
```lua
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local harpoon = require("harpoon")
    return {
      {
        "<leader>ha",
        function()
          harpoon:list():add()
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>hh",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "<leader>1",
        function()
          harpoon:list():select(1)
        end,
        desc = "Harpoon File 1",
      },
      {
        "<leader>2",
        function()
          harpoon:list():select(2)
        end,
        desc = "Harpoon File 2",
      },
      {
        "<leader>3",
        function()
          harpoon:list():select(3)
        end,
        desc = "Harpoon File 3",
      },
      {
        "<leader>4",
        function()
          harpoon:list():select(4)
        end,
        desc = "Harpoon File 4",
      },
      {
        "<leader>hn",
        function()
          harpoon:list():next()
        end,
        desc = "Harpoon Next File",
      },
      {
        "<leader>hp",
        function()
          harpoon:list():prev()
        end,
        desc = "Harpoon Prev File",
      },
    }
  end,
  config = function()
    require("harpoon"):setup()
  end,
}
```

- [ ] **Step 2: Sync and test Harpoon loading**
Run:
```powershell
nvim --headless "+Lazy! sync" +qa
```
Expected: Harpoon2 cloned and synchronized.

- [ ] **Step 3: Commit**
```bash
git add lua/plugins/harpoon.lua lazy-lock.json
git commit -m "feat(workflow): add harpoon 2 fast file navigation"
```

---

### Task 6: Add Flash.nvim & Todo-Comments

**Files:**
- Create: `lua/plugins/flash.lua`
- Create: `lua/plugins/todo-comments.lua`

**Interfaces:**
- Consumes: `folke/flash.nvim`, `folke/todo-comments.nvim`
- Produces: Instant on-screen search/jump (`s`, `S`, `r`) and TODO highlight/search (`<leader>st`, `]t`, `[t`).

- [ ] **Step 1: Create lua/plugins/flash.lua**
Write:
```lua
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash Jump",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
  },
}
```

- [ ] **Step 2: Create lua/plugins/todo-comments.lua**
Write:
```lua
return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "LazyFile",
  opts = {},
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next Todo Comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous Todo Comment",
    },
    {
      "<leader>st",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo (Snacks Picker)",
    },
  },
}
```

- [ ] **Step 3: Run Lazy sync and complete validation**
Run:
```powershell
nvim --headless "+Lazy! sync" +qa
```
Expected: All plugins downloaded and lazy-lock updated cleanly.

- [ ] **Step 4: Commit**
```bash
git add lua/plugins/flash.lua lua/plugins/todo-comments.lua lazy-lock.json
git commit -m "feat(workflow): add flash.nvim jumping and todo-comments with snacks picker"
```

---

### Task 7: Update Documentation & Final Health Check

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: All keymaps from Tasks 1-6
- Produces: Updated keymaps table and feature overview in `README.md`

- [ ] **Step 1: Update README.md with new keymaps and features**
Document:
- `<leader>gu`: Undotree
- `<leader>ha`, `<leader>hh`, `<leader>1`-`<leader>4`: Harpoon 2
- `s`, `S`: Flash jump
- `<leader>st`, `]t`, `[t`: Todo-comments
- Dashboard & Indent guides

- [ ] **Step 2: Run headless healthcheck**
Run:
```powershell
nvim --headless "+checkhealth" +qa
```
Ensure zero critical errors.

- [ ] **Step 3: Commit**
```bash
git add README.md
git commit -m "docs: update readme with aesthetic and productivity features"
```
