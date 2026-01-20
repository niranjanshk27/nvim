return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  dependencies = { 
    { "echasnovski/mini.icons", opts = {} },
    -- Alternative: { "nvim-tree/nvim-web-devicons" }
  },
  lazy = false,
  
  config = function()
    require("oil").setup({
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      default_file_explorer = true,
      
      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        "permissions",
        "size",
        "mtime",
        "icon",
      },
      
      -- Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
        buftype = "",
      },
      
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      
      -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
      delete_to_trash = false,
      
      -- Skip the confirmation popup for simple operations (:help oil.skip-confirm)
      skip_confirm_for_simple_edits = false,
      
      -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
      -- (:help prompt_save_on_select_new_entry)
      prompt_save_on_select_new_entry = true,
      
      -- Oil will automatically delete hidden buffers after this delay
      -- You can set this to false to disable cleanup entirely
      -- Note that the cleanup process only starts when you enter Oil the first time
      cleanup_delay_ms = 2000,
      
      lsp_file_methods = {
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only autosave unmodified buffers
        autosave_changes = false,
      },
      
      -- Constrain the cursor to the editable parts of the oil buffer
      -- Set to `false` to disable, or "name" to keep it on the file names
      constrain_cursor = "editable",
      
      -- Set to true to watch the filesystem for changes and reload oil
      watch_for_changes = false,
      
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "..." })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
      use_default_keymaps = true,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        -- ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        -- ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
        ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        -- ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        
        -- Custom keymaps
        -- ["<leader>ff"] = "actions.select",
        -- ["<leader>fv"] = { "actions.select", opts = { vertical = true } },
        -- ["<leader>fh"] = { "actions.select", opts = { horizontal = true } },
        -- ["<leader>ft"] = { "actions.select", opts = { tab = true } },
        -- ["<leader>fp"] = "actions.preview",
        -- ["<leader>fr"] = "actions.refresh",
        -- ["<leader>fu"] = "actions.parent",
        -- ["<leader>fd"] = "actions.cd",
        -- ["<leader>fq"] = "actions.close",
        
        -- Yank operations
        ["yy"] = "actions.copy_entry_path",
        ["yn"] = "actions.copy_entry_filename",
        
        -- Quick navigation
        ["H"] = "actions.parent",
        ["L"] = "actions.select",
        
        -- Toggle operations
        ["gh"] = "actions.toggle_hidden",
        ["gt"] = "actions.toggle_trash",
      },
      
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = false,
      
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return false
        end,
        -- Sort file names in a more intuitive order for humans. Is less performant,
        -- so you can set to "fast" or false to disable.
        natural_order = true,
        -- Sort file and directory names case insensitive
        case_insensitive = false,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { "type", "asc" },
          { "name", "asc" },
        },
      },
      
      -- Extra arguments to pass to SCP when moving/copying files over SSH
      extra_scp_args = {},
      
      -- EXPERIMENTAL support for performing file operations with git
      -- git = {
      --   -- Return true to automatically git add/mv/rm files
      --   add = function(path)
      --     return false
      --   end,
      --   mv = function(src_path, dest_path)
      --     return false
      --   end,
      --   rm = function(path)
      --     return false
      --   end,
      -- },
      
      -- Configuration for the floating window in oil.open_float
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "auto",
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
      
      -- Configuration for the actions floating preview window
      preview = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a single value or a list of mixed integer/float types.
        max_width = 0.9,
        -- min_width = {40, 0.4} means "at least 40 columns, or at least 40% of total"
        min_width = { 40, 0.4 },
        -- optionally define an integer/float for the exact width of the preview window
        width = nil,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a single value or a list of mixed integer/float types.
        max_height = 0.9,
        min_height = { 5, 0.1 },
        -- optionally define an integer/float for the exact height of the preview window
        height = nil,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
      },
      
      -- Configuration for the floating progress window
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
      },
      
      -- Configuration for the floating SSH window
      ssh = {
        border = "rounded",
      },
      
      -- Configuration for the floating keymaps help window
      keymaps_help = {
        border = "rounded",
      },
    })
    
    -- Global keymaps for oil
    -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    -- vim.keymap.set("n", "<leader>-", "<CMD>Oil --float<CR>", { desc = "Open parent directory in floating window" })
    -- vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open file explorer" })
    vim.keymap.set("n", "<leader>E", "<CMD>Oil --float<CR>", { desc = "Open file explorer in floating window" })
    
    -- Optional: Set up autocommands for better performance
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.opt_local.colorcolumn = ""
        vim.opt_local.signcolumn = "no"
        vim.opt_local.statuscolumn = ""
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = true
        vim.opt_local.wrap = false
      end,
    })
    
    -- Optional: Create command to toggle oil
    vim.api.nvim_create_user_command("OilToggle", function()
      if vim.bo.filetype == "oil" then
        vim.cmd("bd")
      else
        vim.cmd("Oil")
      end
    end, { desc = "Toggle Oil file explorer" })
  end,
}
