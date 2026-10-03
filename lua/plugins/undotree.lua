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
