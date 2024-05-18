-- Display help for key mappings
--
-- https://github.com/folke/which-key.nvim

local function config()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local which_key = require("which-key")

    which_key.register({
        c = { name = "code" },
        e = { name = "expore" },
        f = { name = "find" },
        g = { name = "git" },
        t = { name = "tests" },
        z = { name = "restart things" },
    }, {
        prefix = "<leader>",
    })
end

return {
    "folke/which-key.nvim",
    config = config,
}
