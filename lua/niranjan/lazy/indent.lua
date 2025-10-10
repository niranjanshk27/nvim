return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
      highlight = "IblIndent",
      smart_indent_cap = true,
      priority = 2,
      repeat_linebreak = false,
    },
    whitespace = {
      highlight = "IblWhitespace",
      remove_blankline_trail = false,
    },
    scope = {
      enabled = true,
      char = "│",
      show_start = true,
      show_end = true,
      injected_languages = false,
      highlight = "IblScope",
      priority = 1024,
      include = {
        node_type = {
          ["*"] = { "*" },
        },
      },
    },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
        "NvimTree",
        "oil",
        "lspinfo",
        "packer",
        "checkhealth",
        "man",
        "gitcommit",
        "''",
      },
      buftypes = {
        "terminal",
        "nofile",
        "quickfix",
        "prompt",
      },
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
    -- Custom highlights for better visual distinction
    -- local hooks = require("ibl.hooks")
    -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    --   vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261", nocombine = true })
    --   vim.api.nvim_set_hl(0, "IblScope", { fg = "#7c3aed", nocombine = true })
    --   vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#2d3748", nocombine = true })
    -- end)

    -- Optional: Rainbow indent guides (uncomment if you want colorful indents)
    -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    --   vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    --   vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    --   vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    --   vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    --   vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    --   vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    --   vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    -- end)
    -- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
