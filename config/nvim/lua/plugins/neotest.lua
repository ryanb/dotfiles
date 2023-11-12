local function configure()
    vim.cmd.packadd({ "neotest", bang = true }) -- https://github.com/nvim-neotest/neotest
    vim.cmd.packadd({ "neotest-rspec", bang = true }) -- https://github.com/olimorris/neotest-rspec
    vim.cmd.packadd({ "neotest-vitest", bang = true }) -- https://github.com/marilari88/neotest-vitest.git

    local neotest = require("neotest")
    neotest.setup({
        adapters = {
            require("neotest-rspec"),
            require("neotest-vitest"),
        },
    })
end

return { configure = configure }
