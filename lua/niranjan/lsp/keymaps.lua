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
  --Formatting
  keymap("n", "<leader>fd", function ()
    vim.lsp.buf.format({ async = true })
  end, vim.tbl_extend("force", opts, { desc = "Format Document" }))

  -- TypeScript-specific keymaps
  if client.name == "typescript-tools" then
    keymap("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>", vim.tbl_extend("force", opts, { desc = "Organize Imports" }))
    keymap("n", "<leader>ts", "<cmd>TSToolsSortImports<cr>", vim.tbl_extend("force", opts, { desc = "Sort Imports" }))
    keymap("n", "<leader>tu", "<cmd>TSToolsRemoveUnusedImports<cr>", vim.tbl_extend("force", opts, { desc = "Remove Unused Imports" }))
    keymap("n", "<leader>ti", "<cmd>TSToolsAddMissingImports<cr>", vim.tbl_extend("force", opts, { desc = "Add Missing Imports" }))
    keymap("n", "<leader>tf", "<cmd>TSToolsFixAll<cr>", vim.tbl_extend("force", opts, { desc = "Fix All" }))
    keymap("n", "<leader>tg", "<cmd>TSToolsGoToSourceDefinition<cr>", vim.tbl_extend("force", opts, { desc = "Go To Source Definition" }))
    keymap("n", "<leader>tr", "<cmd>TSToolsRenameFile<cr>", vim.tbl_extend("force", opts, { desc = "Rename File" }))
    keymap("n", "<leader>ta", "<cmd>TSToolsFileReferences<cr>", vim.tbl_extend("force", opts, { desc = "File References" }))
  end
end

return M
