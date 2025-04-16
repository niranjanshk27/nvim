
local local_plugins = {
  {
    "neogit",
    dir = "~/workspace/personal/neogit",
    config = function ()
      local neogit = require("neogit")
      neogit.setup{}
    end,
  }
}

return local_plugins
