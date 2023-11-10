local packadd = require("helpers").packadd

local function configure()
    packadd("neotest")
    packadd("neotest-rspec")

    local neotest = require("neotest")
    neotest.setup(
        {
            adapters = {
                require("neotest-rspec")
            }
        }
    )

    local function run_file()
        neotest.run.run(vim.fn.expand("%"))
    end

    vim.keymap.set("n", "<leader>tf", run_file, {desc = "run tests in file"})
    vim.keymap.set("n", "<leader>tl", neotest.run.run_last, {desc = "run last test"})
    vim.keymap.set("n", "<leader>tn", neotest.run.run, {desc = "run nearest test"})
    vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, {desc = "toggle test summary"})
end

return {configure = configure}
