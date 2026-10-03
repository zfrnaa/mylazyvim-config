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
