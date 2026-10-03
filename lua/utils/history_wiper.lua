local M = {}

local function wipe_all(silent)
  -- Clear in-memory history
  vim.fn.histdel(":")
  vim.fn.histdel("/")

  -- Empty numbered (0-9) and special registers
  for i = 0, 9 do
    vim.fn.setreg(tostring(i), {})
  end
  for _, reg in ipairs({ '"', "+", "*", "-" }) do
    vim.fn.setreg(reg, {})
  end

  -- Remove physical shada file
  local shada_path = vim.fs.joinpath(vim.fn.stdpath("state"), "shada", "main.shada")
  pcall(vim.uv.fs_unlink, shada_path)

  -- Reset disk shada using scalar option vim.o.shada
  local old_shada = vim.o.shada
  vim.o.shada = ""
  vim.cmd("wshada!")
  vim.o.shada = old_shada

  if not silent then
    vim.notify("History and yanks cleared instantly from memory and disk!", vim.log.levels.INFO)
  end
end

M.wipe_all = wipe_all

function M.setup()
  -- 1. AUTOMATIC CLEANUP (Runs once on startup if 3+ days have passed)
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local shada_path = vim.fs.joinpath(vim.fn.stdpath("state"), "shada", "main.shada")
      local stat = vim.uv.fs_stat(shada_path)

      if stat then
        local last_modified = stat.mtime.sec
        local current_time = os.time()
        local three_days_in_seconds = 3 * 24 * 60 * 60

        if (current_time - last_modified) > three_days_in_seconds then
          wipe_all(true)
        end
      end
    end,
  })

  -- 2. MANUAL CLEANUP (Creates a :ClearHistory command you can run anytime)
  vim.api.nvim_create_user_command("ClearHistory", function()
    wipe_all(false)
  end, {})
end

return M
