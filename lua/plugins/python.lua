return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          on_init = function(client)
            local root = client.config.root_dir or vim.fn.getcwd()
            local is_win = vim.uv.os_uname().sysname:find("Windows") ~= nil

            local venv_python
            if is_win then
              venv_python = root .. "\\.venv\\Scripts\\python.exe"
            else
              venv_python = root .. "/.venv/bin/python"
            end

            -- If project local .venv exists, force Pyright to use it
            if vim.fn.executable(venv_python) == 1 then
              client.config.settings.python = client.config.settings.python or {}
              client.config.settings.python.pythonPath = venv_python
              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
          end,
        },
      },
    },
  },
}
