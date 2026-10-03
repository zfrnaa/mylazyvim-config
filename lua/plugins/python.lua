return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            local root = config.root_dir or vim.fn.getcwd()
            local is_win = vim.fn.has("win32") == 1
            local venv_python = vim.fs.joinpath(
              root,
              ".venv",
              is_win and "Scripts" or "bin",
              is_win and "python.exe" or "python"
            )

            -- If project local .venv exists, force Pyright to use it
            if vim.fn.executable(venv_python) == 1 then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv_python
            end
          end,
        },
      },
    },
  },
}
