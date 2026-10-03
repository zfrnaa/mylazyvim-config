return {
  -- Auto-format messy SQL blocks cleanly on-demand
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sql_formatter" }, -- Requires: npm install -g sql-formatter
      },
    },
  },
}
