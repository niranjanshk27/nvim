return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    scroll = { enabled = true },
    terminal = { enabled = true },
    debug = {
      scores = true,
    },
    -- Enhanced matcher for better performance
    matcher = {
      frecency = true,
    },
    picker = {
      enabled = true,
      -- Default states for showing different file types
      hidden = true,       -- Hide hidden files by default
      follow = false,        -- Follow cursor in real-time
      ignored = false,       -- Show ignored files (gitignored, etc.) by default
      -- Ivy layout with bottom position
      layout = {
        preset = "ivy",
        position = "bottom"
      },
    },
    toggles = {
      follow = "f",
      hidden = "h",
      ignored = "i",
      modified = "m",
      regex = { icon = "󰯊", value = false },
      case = { icon = "Aa", value = false },
      wrap = { icon = "󰖶", value = false },
    },
    win = {
      input = {
        keys = {
          -- Close picker on ESC instead of going to normal mode
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          ["<C-c>"] = { "close", mode = { "n", "i" } },
          ["/"] = "toggle_focus",
          -- Better toggle keys that avoid conflicts
          ["<A-f>"] = { "toggle_follow", mode = { "i", "n" } },    -- Alt+f for follow
          ["<A-h>"] = { "toggle_hidden", mode = { "i", "n" } },    -- Alt+h for hidden
          ["<A-i>"] = { "toggle_ignored", mode = { "i", "n" } },   -- Alt+i for ignored
          -- Faster navigation
          ["<C-j>"] = "move_down",
          ["<C-k>"] = "move_up",
          ["<C-d>"] = "preview_scroll_down",
          ["<C-u>"] = "preview_scroll_up",
        }
      },
      list = {
        keys = {
          ["/"] = "toggle_focus",
          ["<Tab>"] = "toggle_select",
          ["<S-Tab>"] = "toggle_select_all",
          -- Alt keys (requires terminal configuration)
          ["<A-f>"] = { "toggle_follow", mode = { "i", "n" } },
          ["<A-h>"] = { "toggle_hidden", mode = { "i", "n" } },
          ["<A-i>"] = { "toggle_ignored", mode = { "i", "n" } },
          -- Preview scrolling
          ["<C-f>"] = "preview_scroll_down",
          ["<C-b>"] = "preview_scroll_up",
          ["<C-d>"] = "preview_scroll_down",
          ["<C-u>"] = "preview_scroll_up",
          -- Quick actions
          ["<CR>"] = "confirm",
          -- ["<C-->"] = "confirm_split",
          -- ["<C-\\>"] = "confirm_vsplit",
          ["<C-t>"] = "confirm_tab",
        }
      }
    },
    styles = {
      snacks_image = {
        relative = "editor",
        col = -1,
      }
    },
    image = {
      enabled = true,
      -- For iTerm2, we need to use a fallback method since it's not natively supported
      -- Install ImageMagick: brew install imagemagick
      force = false,
      doc = {
        inline = false,
        float = true,
        max_width = 60,
        max_height = 30
      }
    }
  },
  keys = {
    -- File pickers with explicit options
    { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files (All)" },
    { "<leader>fg", function() Snacks.picker.grep({ hidden = true, ignored = true }) end, desc = "Live Grep (All)" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find Buffers" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Tags" },
    { "<leader>fm", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    -- Specialized file pickers
    { "<leader>f.", function() Snacks.picker.files({ hidden = true, ignored = false, cwd = vim.fn.expand("~") }) end, desc = "Find Dotfiles" },
    -- LSP pickers
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Other useful pickers
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fO", function() Snacks.picker.vim_options() end, desc = "Vim Options" },
    { "<leader>ft", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- Search in current buffer
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Search Lines" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        vim.print = _G.dd
      end,
    })
  end,
}
