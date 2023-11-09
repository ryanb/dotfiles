local packadd = require("packadd")
local bind = vim.keymap.set

if vim.g.vscode then
    -- Clean for now.
else
    packadd("plenary.nvim") -- Some other packages need this.

    require("options").configure()
    require("styling").configure()
    require("navigation").configure()
    require("plugins").configure()
    require("whitespace").remove_trailing_whitespace_on_save()

    packadd("neotest")
    packadd("neotest-rspec")
    require("neotest").setup({
        adapters = {
            require("neotest-rspec")
        }
    })
end
