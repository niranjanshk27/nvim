return {
  "akinsho/git-conflict.nvim",
  version = "*",
  config = function()
    require("git-conflict").setup({
      default_mappings = true, -- Keep default mappings: co (ours), ct (theirs), cb (both), c0 (none)
      default_commands = true, -- Keep default commands
      disable_diagnostics = false, -- Keep diagnostics visible during conflicts
      list_opener = 'Telescope quickfix', -- Use Telescope to show conflicts
      
      -- Enhanced highlights for better visual distinction
      highlights = {
        incoming = 'DiffAdd',    -- Highlight incoming changes (theirs)
        current = 'DiffText',    -- Highlight current changes (ours)
      },
      
      -- Additional useful options
      default_mappings_prefix = 'c', -- Prefix for default mappings (co, ct, cb, c0)
      
      -- Auto-detect conflict markers and set up buffer
      auto_setup_attachment = true,
      
      -- Show conflict info in status line (if you use a status line plugin)
      signs = {
        priority = 100,
      }
    })

    -- Custom keymaps for enhanced workflow
    local keymap = vim.keymap.set
    keymap('n', '<leader>gl', function()
      -- First populate quickfix with conflicts, then open in telescope with clean input
      vim.cmd('GitConflictListQf')
      vim.schedule(function()
        require('telescope.builtin').quickfix({
          prompt_title = "Git Conflicts",
        })
      end)
    end, { desc = 'List git conflicts in Telescope' })
    keymap('n', '[x', '<cmd>GitConflictPrevConflict<cr>', { desc = 'Previous conflict' })
    keymap('n', ']x', '<cmd>GitConflictNextConflict<cr>', { desc = 'Next conflict' })
    
    -- Additional quick resolution mappings (optional)
    keymap('n', '<leader>co', '<cmd>GitConflictChooseOurs<cr>', { desc = 'Choose ours (current)' })
    keymap('n', '<leader>ct', '<cmd>GitConflictChooseTheirs<cr>', { desc = 'Choose theirs (incoming)' })
    keymap('n', '<leader>cb', '<cmd>GitConflictChooseBoth<cr>', { desc = 'Choose both' })
    keymap('n', '<leader>cn', '<cmd>GitConflictChooseNone<cr>', { desc = 'Choose none' })
  end
}