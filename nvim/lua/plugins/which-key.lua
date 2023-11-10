local packadd = require("helpers").packadd

local function configure()
    packadd("which-key.nvim") -- https://github.com/folke/which-key.nvim
    local which_key = require("which-key")

    vim.opt.timeout = true
    vim.opt.timeoutlen = 500

    which_key.setup({})
    which_key.register(
        {
            c = "code",
            f = "find",
            t = "tests"
        },
        {
            prefix = "<leader>"
        }
    )
end

return {configure = configure}
