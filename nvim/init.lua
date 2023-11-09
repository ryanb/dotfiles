local packadd = require("helpers/packadd")

if not vim.g.vscode then
    packadd("plenary.nvim") -- Some other packages need this.

    require("language_support").configure()
    require("appearance").configure()
    require("navigation").configure()
    require("editing").configure()
    require("options").configure()
end
