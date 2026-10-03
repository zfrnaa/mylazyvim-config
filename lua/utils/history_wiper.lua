local M = {}

function M.setup()
  -- 1. AUTOMATIC CLEANUP (Runs once on startup if 3+ days have passed)
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local shada_path = vim.fn.stdpath("state") .. "/shada/main.shada"
      local stat = vim.uv.fs_stat(shada_path)

      if stat then
        local last_modified = stat.mtime.sec
        local current_time = os.time()
        local three_days_in_seconds = 3 * 24 * 60 * 60

        if (current_time - last_modified) > three_days_in_seconds then
          vim.opt.shada = ""
          vim.cmd("wshada!")
          vim.opt.shada = "!,'100,<50,s10,h"
          print("Cleared command and yank history (3+ days since last session).")
        end
      end
    end,
  })

  -- 2. MANUAL CLEANUP (Creates a :ClearHistory command you can run anytime)
  vim.api.nvim_create_user_command("ClearHistory", function()
    -- Clear active memory history lists instantly
    vim.fn.histdel(":") -- Clears command history (up/down arrows)
    vim.fn.histdel("/") -- Clears search history

    -- Empty out your yank/paste registers from active memory
    for i = 0, 9 do
      vim.fn.setreg(tostring(i), {})
    end
    vim.fn.setreg('"', {})
    vim.fn.setreg("+", {})
    vim.fn.setreg("*", {})

    -- Wipe the physical history file on disk completely
    local old_shada = vim.opt.shada
    vim.opt.shada = ""
    vim.cmd("wshada!")
    vim.opt.shada = old_shada

    print("History and yanks cleared instantly from memory and disk!")
  end, {})
end

return M
