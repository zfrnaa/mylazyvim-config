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
        -- Get all open windows in the current tab
        local win_found = false
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          -- Check if a quickfix/location list buffer is already visible
          if vim.bo[buf].filetype == "qf" then
            win_found = true
            break
          end
        end

        if win_found then
          vim.cmd("cclose") -- If it's open, shut it down
        else
          vim.diagnostic.setqflist({ open = true }) -- If it's closed, open it at the bottom
        end
      end,
      desc = "Toggle Built-in Problems Window",
    },
  },
}
