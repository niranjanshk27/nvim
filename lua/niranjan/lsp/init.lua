local M = {}

-- This function provides the LSP capabilities that will be shared across all servers.
function M.get_capabilities()
  local cmp_lsp = require("cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
  )
  -- Performance: configure capabilities
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  return capabilities
end

-- This function is called once an LSP client attaches to a buffer.
function M.on_attach(client, buffer)
  require("niranjan.lsp.keymaps").on_attach(client, buffer)

  -- Performance: disable semantic tokens for large files to improve performance.
  if client.server_capabilities.semanticTokensProvider then
    local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(buffer))
    if file_size > 100000 then -- 100KB
      client.server_capabilities.semanticTokensProvider = nil
    end
  end

  -- Auto-format on save (optional - uncomment if desired)
  -- if client.server_capabilities.documentFormattingProvider then
  --   vim.api.nvim_create_autocmd("BufWritePre", {
  --     group = vim.api.nvim_create_augroup("LspFormat", {}),
  --     buffer = ev.buf,
  --     callback = function()
  --       vim.lsp.buf.format({ async = false })
  --     end,
  --   })
  -- end
end

-- This is the main setup function for your LSP configurations.
function M.setup()
  vim.lsp.set_log_level("error")
  vim.opt.updatetime = 250

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", max_width = 80, max_height = 20 })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", max_width = 80, max_height = 15 })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      M.on_attach(client, ev.buf)
    end,
  })

  -- Configure diagnostics for a better user experience.
  vim.diagnostic.config({
    virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "✘",
        [vim.diagnostic.severity.WARN] = "▲",
        [vim.diagnostic.severity.HINT] = "⚑",
        [vim.diagnostic.severity.INFO] = "»",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      })
      vim.diagnostic.open_float(nil, opts)
    end,
  })

  -- Set up ansible-specific settings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml.ansible",
    callback = function()
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.softtabstop = 2
      vim.bo.expandtab = true
    end,
  })

  -- Set up jinja-specific settings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"jinja", "jinja2", "htmldjango"},
    callback = function()
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.softtabstop = 2
      vim.bo.expandtab = true
      vim.cmd("setlocal commentstring={#\\ %s\\ #}")
    end,
  })

  -- require("niranjan.lsp.keymaps").setup()
end

return M
