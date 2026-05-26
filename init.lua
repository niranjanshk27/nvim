-- Workaround for macOS fswatch / libuv malloc crashes when deleting huge directories like node_modules
local original_watch = vim.fs.watch
vim.fs.watch = function(path, opts, callback)
  if path:match("node_modules") or path:match("%.git") then
    return function() end -- Dummy cancel function
  end
  return original_watch(path, opts, callback)
end

require("niranjan")
