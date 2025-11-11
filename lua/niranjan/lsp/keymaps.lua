local M = {}

function M.on_attach(client, buffer)
  local opts = { buffer = buffer, noremap = true, silent = true }

  -- Keybindings for LSP navigation, actions, and information.
  local keymap = vim.keymap.set
  keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
  keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
  keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
  keymap("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Goto Type Definition" }))
  keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
  -- Information
  keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
  keymap("n", "<leader>k", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
  -- Action
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
  keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
  -- Diagnostic
  keymap("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
  keymap("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
  keymap("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show Diagnostics" }))
  keymap("n", "<leader>q", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostics List" }))

  -- TypeScript-specific keymaps
  if client.name == "typescript-tools" then
    keymap("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>", vim.tbl_extend("force", opts, { desc = "Organize Imports" }))
    keymap("n", "<leader>ts", "<cmd>TSToolsSortImports<cr>", vim.tbl_extend("force", opts, { desc = "Sort Imports" }))
  end
end

-- function M.setup()
--   -- Additional keymaps that are not tied to a specific buffer.
--   local keymap = vim.keymap.set
--   keymap("n", "<leader>xx", function() require("telescope.builtin").diagnostics() end, { desc = "Telescope Diagnostics" })
--   keymap("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, { desc = "Document Symbols" })
-- end

return M
