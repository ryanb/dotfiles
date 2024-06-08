local dressing_spec = {
    -- https://github.com/stevearc/dressing.nvim
    "stevearc/dressing.nvim",
    opts = {},
}

local lualine_spec = {
    "nvim-lualine/lualine.nvim",
    opts = require("plugins/ui/lualine-opts"),
}

local nightfox_spec = {
    "EdenEast/nightfox.nvim",
    opts = {
        groups = {
            all = {
                -- Work around this issue:
                -- https://github.com/EdenEast/nightfox.nvim/issues/440
                NeoTreeTitleBar = { fg = "#131a24", bg = "#71839b" },
            },
        },
        options = { transparent = true },
    },
    lazy = false,
    priority = 1000,
}

local notify_spec = {
    "rcarriga/nvim-notify",
    config = function()
        local notify = require("notify")
        notify.setup({ top_down = false })
        vim.notify = notify
    end,
}

local which_key_spec = {
    "folke/which-key.nvim",
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
}

return { dressing_spec, lualine_spec, nightfox_spec, notify_spec, which_key_spec }
