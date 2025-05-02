vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc = "Open file Explore. Same as :Ex"})

-- move highlighted line(s) up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted line Down", noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted line Up", noremap = true, silent = true })

-- jump half-page with cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump half-page Down", noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump half-page Up", noremap = true, silent = true })

-- global replace
vim.keymap.set("n", "<leader>gr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", {desc = "Global replace", noremap = true, silent = true })


-- This mapping preserves your clipboard/yank buffer, making pasting over text non-destructive to your copy.
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Paste from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>pp", [["+p]], { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader>PP", [["+P]], { desc = "Paste before from system clipboard" })

-- leader + s to save the file.
-- vim.keymap.set('n', '<leader>s', ':w<CR>', { noremap = true, silent = true, desc = "Save file" })
