-- https://github.com/rcarriga/nvim-notify

local opts = {
    background_colour = "#000000",
    render = "wrapped-compact",
    stages = "fade",
    top_down = false,
}

local function config()
    vim.notify = require("notify")
end

return { "rcarriga/nvim-notify", config = config, opts = opts }
