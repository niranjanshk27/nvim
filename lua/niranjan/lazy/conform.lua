return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        go = { "gofmt" },
        rust = { "rustfmt" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        ruby = { "rubocop" },
        terraform = { "terraform_fmt" },
        ansible = { "ansible-lint" },
        jinja = { "djlint" },
        html = { "djlint", "prettier" },
        htmldjango = { "djlint" },
      },
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },
    })
  end,
}
