return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local Path = require("plenary.path")

    telescope.setup({})

    -- File store path: ~/.local/share/nvim/telescope_flags.json
    local flag_file_path = vim.fn.stdpath("data") .. "/telescope_flags.json"

    -- Default values
    local find_files_opts = {
      hidden = false,
      no_ignore = false,
      follow = false,
    }

    -- Load flags from file
    local function load_flags()
      local flag_file = Path:new(flag_file_path)
      if flag_file:exists() then
        local content = flag_file:read()
        local ok, data = pcall(vim.fn.json_decode, content)
        if ok and type(data) == "table" then
          find_files_opts = vim.tbl_deep_extend("force", find_files_opts, data)
        end
      end
    end

    -- Save flags to file
    local function save_flags()
      local flag_file = Path:new(flag_file_path)
      flag_file:write(vim.fn.json_encode(find_files_opts), "w")
    end

    -- Notify current flag status
    local function notify_flags()
      vim.notify(string.format(
        "Find Files Flags:\n• hidden: %s\n• no_ignore: %s\n• follow: %s",
        tostring(find_files_opts.hidden),
        tostring(find_files_opts.no_ignore),
        tostring(find_files_opts.follow)
      ), vim.log.levels.INFO, { title = "Telescope Flags" })
    end

    -- Toggle helpers
    local function toggle_flag(key)
      find_files_opts[key] = not find_files_opts[key]
      save_flags()
      builtin.find_files(vim.tbl_extend("force", find_files_opts, {
        prompt_title = string.format("Find Filse (hidden: %s | ignore: %s | follow: %s)",
          tostring(find_files_opts.hidden),
          tostring(find_files_opts.no_ignore),
          tostring(find_files_opts.follow)
        )
      }))
      notify_flags()
    end

    -- Toggle all flags
    local function toggle_all_flags()
      for k in pairs(find_files_opts) do
        find_files_opts[k] = not find_files_opts[k]
      end
      save_flags()
      local opts = vim.tbl_extend("force", find_files_opts, {
        prompt_title = string.format("Find Files (hidden: %s | ignore: %s | follow: %s)",
          tostring(find_files_opts.hidden),
          tostring(find_files_opts.no_ignore),
          tostring(find_files_opts.follow)
        )
      })
      builtin.find_files(opts)
      notify_flags()
    end

    -- Persistent find_files
    local function find_files_with_flags()
      builtin.find_files(vim.tbl_extend("force", find_files_opts, {
        prompt_title = string.format("Find Filse (hidden: %s | ignore: %s | follow: %s)",
          tostring(find_files_opts.hidden),
          tostring(find_files_opts.no_ignore),
          tostring(find_files_opts.follow)
        )
      }))
    end

    -- Load saved flags on startup
    load_flags()

    -- Keymaps
    vim.keymap.set('n', '<leader>pf', find_files_with_flags, { desc = "Find files (with persistent flags)" })
    vim.keymap.set('n', '<leader>tt', toggle_all_flags, { desc = "Toggle all find_files flags" })
    vim.keymap.set('n', '<leader>th', function() toggle_flag("hidden") end, { desc = "Toggle hidden files" })
    vim.keymap.set('n', '<leader>ti', function() toggle_flag("no_ignore") end, { desc = "Toggle ignore files" })
    vim.keymap.set('n', '<leader>tf', function() toggle_flag("follow") end, { desc = "Toggle follow symlinks" })

    vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Git files" })
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = "Live grep" })

    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, { desc = "Search full WORD under cursor" })

    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "Search by input" })

    vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Help tags" })
  end
}

