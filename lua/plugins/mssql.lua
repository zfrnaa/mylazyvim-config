return {
  "Kurren123/mssql.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  -- Only load the plugin when you explicitly call these commands or hit the keymaps
  cmd = { "MSSQL", "MSSQLConnect", "MSSQLExecute", "MSSQLNewQuery" },
  keys = {
    { "<leader>mc", "<cmd>MSSQL Connect<cr>", desc = "Connect to MSSQL Server" },
    { "<F5>", "<cmd>MSSQL Execute<cr>", desc = "Execute T-SQL Query (SSMS Style)" },
    { "<leader>me", "<cmd>MSSQL Execute<cr>", desc = "Execute T-SQL Query" },
    { "<leader>mn", "<cmd>MSSQL NewQuery<cr>", desc = "Open New T-SQL Query Window" },
  },
}
