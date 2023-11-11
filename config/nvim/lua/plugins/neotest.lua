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

    local function run_file()
        neotest.run.run(vim.fn.expand("%"))
    end

    vim.keymap.set("n", "<leader>tf", run_file, { desc = "run tests in file" })
    vim.keymap.set("n", "<leader>tl", neotest.run.run_last, { desc = "run last test" })
    vim.keymap.set("n", "<leader>tn", neotest.run.run, { desc = "run nearest test" })
    vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "toggle test summary" })
end

return { configure = configure }
