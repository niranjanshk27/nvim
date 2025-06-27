require("niranjan.set")
require("niranjan.remap")
require("niranjan.filetype")
require("niranjan.lazy_init")

-- -- Auto-reload Treesitter and LSP for new Terraform files
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.cmd([[set filetype=terraform]])
    -- Ensure Treesitter highlighting is enabled
    if pcall(require, 'nvim-treesitter.configs') then
      vim.cmd('TSBufEnable highlight')
    end
    -- Attach LSP if not already attached (use new API)
    local clients = vim.lsp.get_clients({bufnr = 0})
    if not clients or vim.tbl_isempty(clients) then
      -- Only start LSP if not already attached
      vim.cmd('LspStart terraformls')
    end
  end
})
