local opts = {
    background_colour = "#000000",
    render = "wrapped-compact",
    stages = "fade",
    top_down = false,
}

local function init()
    vim.notify = require("notify")
end

return { "rcarriga/nvim-notify", init = init, opts = opts }
