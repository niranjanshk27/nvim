return {
  'NvChad/nvim-colorizer.lua',
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    filetypes = {
      css = { rgb_fn = true },
      html = { names = true },
      javascript = { rgb_fn = true },
      javascriptreact = { rgb_fn = true },
      typescript = { rgb_fn = true },
      typescriptreact = { rgb_fn = true },
    },
    user_default_options = {
      mode = "background",
    },
  },
}
