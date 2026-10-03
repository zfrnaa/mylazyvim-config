return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      transparent_mode = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  -- Disable default Tokyonight download since Gruvbox is our primary theme
  { "folke/tokyonight.nvim", enabled = false },
}
