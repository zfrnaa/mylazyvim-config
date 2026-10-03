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
