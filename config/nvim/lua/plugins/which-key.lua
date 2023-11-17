local function init()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local which_key = require("which-key")

    which_key.register({
        c = "code...",
        g = "git...",
        t = "tests...",
    }, {
        prefix = "<leader>",
    })
end

return {
    "folke/which-key.nvim",
    init = init,
}
