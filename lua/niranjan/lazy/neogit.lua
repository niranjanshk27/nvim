return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "folke/snacks.nvim", -- used for picker integration
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit Commit" },
    { "<leader>gf", "<cmd>Neogit fetch<cr>", desc = "Neogit Fetch" },
    { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Neogit Pull" },
    { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Neogit Push" },
    { "<leader>gr", "<cmd>Neogit rebase<cr>", desc = "Neogit Rebase" },
    { "<leader>gm", "<cmd>Neogit merge<cr>", desc = "Neogit Merge" },
    { "<leader>gB", "<cmd>Neogit branch<cr>", desc = "Neogit Branch" },
    { "<leader>gl", "<cmd>Neogit log<cr>", desc = "Neogit Log" },
    { "<leader>gz", "<cmd>Neogit stash<cr>", desc = "Neogit Stash" },
  },
  config = function()
    local neogit = require("neogit")

    neogit.setup({
      -- disable_builtin_notifications = false,
      -- use_magit_keybindings = false,
      -- Hides the hints at the top of the status buffer
      disable_hint = false,
      -- Disables changing the buffer highlights based on where the cursor is.
      disable_context_highlighting = false,
      -- Disables signs for sections/items/hunks
      disable_signs = false,
      -- Changes what mode the Commit Editor starts in. `true` starts in normal mode, `false` starts in insert mode.
      disable_insert_on_commit = "auto",
      -- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem events.
      filewatcher = {
        interval = 1000,
        enabled = true,
      },
      -- "ascii" is the graph character, "unicode" is a bit nicer looking but needs a NerdFont
      graph_style = "unicode",
      -- Used to generate blame information
      git_services = {
        ["github.com"] = {
          pull_request = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
          commit = "https://github.com/${owner}/${repository}/commit/${commit_hash}",
          tree = "https://github.com/${owner}/${repository}/tree/${commit_hash}",
        },
        ["gitlab.com"] = {
          pull_request = "https://gitlab.com/${owner}/${repository}/merge_requests/create?merge_request[source_branch]=${branch_name}",
          commit = "https://gitlab.com/${owner}/${repository}/-/commit/${commit_hash}",
          tree = "https://gitlab.com/${owner}/${repository}/-/tree/${commit_hash}",
        },
        ["bitbucket.org"] = {
          pull_request = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
          commit = "https://bitbucket.org/${owner}/${repository}/commits/${commit_hash}",
          tree = "https://bitbucket.org/${owner}/${repository}/src/${commit_hash}",
        },
      },
      -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
      -- sorter instead. By default, this function returns `nil`.
      telescope_sorter = function()
        return nil
      end,
      -- Persist the values of switches/options within and across sessions
      remember_settings = true,
      -- Scope persisted settings on a per-project basis
      use_per_project_settings = true,
      -- Array-like table of settings to never persist. Uses format "Filetype--cli-value"
      ignored_settings = {
        "NeogitPushPopup--force-with-lease",
        "NeogitPushPopup--force",
        "NeogitPullPopup--rebase",
        "NeogitCommitPopup--allow-empty",
        "NeogitRevertPopup--no-edit",
      },
      -- Set to false if you want to be responsible for creating _ALL_ keymappings
      use_default_keymaps = true,
      -- Neogit refreshes its internal state after specific events
      auto_refresh = true,
      -- Value used for `--sort` option for `git branch` command
      -- By default, branches will be sorted by commit date
      sort_branches = "-committerdate",
      -- Default for new branch name prompts
      branch_name_suggestion = "based-on-branch",
      -- Automatically stage newly tracked files
      auto_stage = false,
      -- Automatically close the Neogit status buffer after a push
      -- Values: "on_success" | false
      close_after_operation = false,

      -- Signs used for sections
      signs = {
        -- { CLOSED, OPENED }
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },

      -- Integrations
      integrations = {
        -- If enabled, use telescope for menu selection rather than vim.ui.select.
        -- Allows multi-select and some things that not all vim.ui.select providers support.
        telescope = nil,
        -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
        diffview = true,
        -- If enabled, uses fzf-lua for menu selection. If the telescope integration
        -- is also selected then telescope is used instead.
        fzf_lua = nil,
        -- If enabled, uses mini.pick for menu selection.
        mini_pick = nil,
        -- If enabled, uses snacks.nvim for menu selection
        snacks = true,
      },

      sections = {
        -- Reverting/cherry-picking
        sequencer = {
          folded = false,
          hidden = false,
        },
        untracked = {
          folded = false,
          hidden = false,
        },
        unstaged = {
          folded = false,
          hidden = false,
        },
        staged = {
          folded = false,
          hidden = false,
        },
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled_upstream = {
          folded = true,
          hidden = false,
        },
        unmerged_upstream = {
          folded = false,
          hidden = false,
        },
        unpulled_pushRemote = {
          folded = true,
          hidden = false,
        },
        unmerged_pushRemote = {
          folded = false,
          hidden = false,
        },
        recent = {
          folded = true,
          hidden = false,
        },
        rebase = {
          folded = true,
          hidden = false,
        },
      },

      -- override/add mappings
      mappings = {
        commit_editor = {
          ["q"] = "Close",
          ["<c-c><c-c>"] = "Submit",
          ["<c-c><c-k>"] = "Abort",
          ["<m-p>"] = "PrevMessage",
          ["<m-n>"] = "NextMessage",
          ["<m-r>"] = "ResetMessage",
        },
        commit_editor_I = {
          ["<c-c><c-c>"] = "Submit",
          ["<c-c><c-k>"] = "Abort",
        },
        rebase_editor = {
          ["p"] = "Pick",
          ["r"] = "Reword",
          ["e"] = "Edit",
          ["s"] = "Squash",
          ["f"] = "Fixup",
          ["x"] = "Execute",
          ["d"] = "Drop",
          ["b"] = "Break",
          ["q"] = "Close",
          ["<cr>"] = "OpenCommit",
          ["gk"] = "MoveUp",
          ["gj"] = "MoveDown",
          ["<c-c><c-c>"] = "Submit",
          ["<c-c><c-k>"] = "Abort",
          ["[c"] = "OpenOrScrollUp",
          ["]c"] = "OpenOrScrollDown",
        },
        rebase_editor_I = {
          ["<c-c><c-c>"] = "Submit",
          ["<c-c><c-k>"] = "Abort",
        },
        finder = {
          ["<cr>"] = "Select",
          ["<c-c>"] = "Close",
          ["<esc>"] = "Close",
          ["<c-n>"] = "Next",
          ["<c-p>"] = "Previous",
          ["<down>"] = "Next",
          ["<up>"] = "Previous",
          ["<tab>"] = "MultiselectToggleNext",
          ["<s-tab>"] = "MultiselectTogglePrevious",
          ["<c-j>"] = "NOP",
        },
        -- Setting any of these to `false` will disable the mapping.
        popup = {
          ["?"] = "HelpPopup",
          ["A"] = "CherryPickPopup",
          ["D"] = "DiffPopup",
          ["M"] = "RemotePopup",
          ["P"] = "PushPopup",
          ["X"] = "ResetPopup",
          ["Z"] = "StashPopup",
          ["b"] = "BranchPopup",
          ["B"] = "BisectPopup",
          ["c"] = "CommitPopup",
          ["f"] = "FetchPopup",
          ["l"] = "LogPopup",
          ["m"] = "MergePopup",
          ["p"] = "PullPopup",
          ["r"] = "RebasePopup",
          ["v"] = "RevertPopup",
          ["w"] = "WorktreePopup",
        },
        status = {
          ["q"] = "Close",
          ["I"] = "InitRepo",
          ["1"] = "Depth1",
          ["2"] = "Depth2",
          ["3"] = "Depth3",
          ["4"] = "Depth4",
          ["<tab>"] = "Toggle",
          ["x"] = "Discard",
          ["s"] = "Stage",
          ["S"] = "StageUnstaged",
          ["<c-s>"] = "StageAll",
          ["K"] = "Untrack",
          ["u"] = "Unstage",
          ["U"] = "UnstageStaged",
          ["$"] = "CommandHistory",
          ["Y"] = "YankSelected",
          ["<c-r>"] = "RefreshBuffer",
          ["<cr>"] = "GoToFile",
          ["<c-v>"] = "VSplitOpen",
          ["<c-x>"] = "SplitOpen",
          ["<c-t>"] = "TabOpen",
          ["{"] = "GoToPreviousHunkHeader",
          ["}"] = "GoToNextHunkHeader",
          ["[c"] = "OpenOrScrollUp",
          ["]c"] = "OpenOrScrollDown",
          ["<c-k>"] = "PeekUp",
          ["<c-j>"] = "PeekDown",
        },
      },
    })

  end,
}