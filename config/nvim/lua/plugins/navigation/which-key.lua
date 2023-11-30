-- https://github.com/folke/which-key.nvim

local function config()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local which_key = require("which-key")

    which_key.register({
        c = "code...",
        t = "tests...",
        r = "restart things...",
    }, {
        prefix = "<leader>",
    })
end

return {
    "folke/which-key.nvim",
    config = config,
}
