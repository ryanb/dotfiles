local function configure()
    vim.cmd.packadd({"nvim-notify", bang = true}) -- https://github.com/rcarriga/nvim-notify
    local notify = require("notify")
    notify.setup({background_colour = "#000000", stages = "fade", top_down = false})

    -- Use it for all the notifications.
    vim.notify = require("notify")
end

return {configure = configure}
