-- https://github.com/rcarriga/nvim-notify

local function config()
    local notify = require("notify")

    notify.setup({
        background_colour = "#000000",
        render = "wrapped-compact",
        stages = "fade",
        top_down = false,
    })

    vim.notify = notify
end

return { "rcarriga/nvim-notify", config = config }
