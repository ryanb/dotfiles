local level_symbols = { ERROR = "󰅚 ", INFO = "󰋽 ", WARN = "󰀪 " }

local function format_notification(notification)
    return string.format(" %s %s ", level_symbols[notification.level] or "?", notification.msg)
end

local function window_config()
    return { anchor = "SE", border = "rounded", row = vim.o.lines - 2 }
end

return function()
    local mini_notify = require("mini.notify")

    mini_notify.setup({
        content = { format = format_notification },
        lsp_progress = { duration_last = 3000 },
        window = { config = window_config, winblend = 0 },
    })

    vim.notify = mini_notify.make_notify()
end
