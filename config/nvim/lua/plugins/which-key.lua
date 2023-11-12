local function configure()
    vim.cmd.packadd({ "which-key.nvim", bang = true }) -- https://github.com/folke/which-key.nvim
    local which_key = require("which-key")

    vim.o.timeout = true
    vim.o.timeoutlen = 300

    which_key.setup({})
    which_key.register({
        c = "code",
        e = "file explorer",
        f = "find",
        t = "tests",
    }, {
        prefix = "<leader>",
    })
end

return { configure = configure }
