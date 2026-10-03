return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.options = opts.options or {}
    opts.options.theme = "gruvbox"
    opts.options.component_separators = { left = "", right = "" }
    opts.options.section_separators = { left = "", right = "" }

    -- Custom macro recording status component
    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg ~= "" then
        return "󰑋 @" .. reg
      end
      return ""
    end

    opts.sections = opts.sections or {}
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, 1, {
      macro_recording,
      color = { fg = "#fb4934", gui = "bold" },
    })

    return opts
  end,
}
