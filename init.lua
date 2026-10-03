-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- custom history and shada cleanup
require("utils.history_wiper").setup()
