return {
  'norcalli/nvim-colorizer.lua',
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      css = { rgb_fn = true },
      html = { names = true },
      javascript = { rgb_fn = true },
      javascriptreact = { rgb_fn = true },
      typescript = { rgb_fn = true },
      typescriptreact = { rgb_fn = true },
    },
    {
      mode = "background", -- "foreground" | "background"
    })
  end,
}
