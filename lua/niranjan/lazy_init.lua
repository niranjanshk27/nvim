local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = "niranjan.lazy",
  change_detection = { notify = false }
})

-- File type indicator
vim.filetype.add({
  filename = {
    ["Fastfile"] = "ruby",
  },
})

-- open in safari if markdown file is open
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "markdown",
--     callback = function ()
--         require("peek").open()
--     end,
-- })
