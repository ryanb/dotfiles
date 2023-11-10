local packadd = require("helpers").packadd
local bind = require("helpers").bind

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

    bind("n", "<leader>tf", run_file, {desc = "run tests in file"})
    bind("n", "<leader>tl", neotest.run.run_last, {desc = "run last test"})
    bind("n", "<leader>tn", neotest.run.run, {desc = "run nearest test"})
    bind("n", "<leader>ts", neotest.summary.toggle, {desc = "toggle test summary"})
end

return {configure = configure}
