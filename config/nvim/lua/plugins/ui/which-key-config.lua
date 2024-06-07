local function config()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local which_key = require("which-key")

    which_key.register({
        ["<leader>"] = {
            c = { name = "code" },
            e = { name = "explore" },
            f = { name = "find" },
            g = { name = "git" },
            m = { name = "move" }, -- This doesn't show up correctly for some reason.
            t = { name = "tests" },
            z = { name = "restart things" },
        },
    })
end

return config
