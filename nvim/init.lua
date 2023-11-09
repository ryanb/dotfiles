local packadd = require("packadd")

if not vim.g.vscode then
    packadd("plenary.nvim") -- Some other packages need this.

    require("options").configure()
    require("appearance").configure()

    require("plugins").configure()
    require("testing").configure()

    require("completion").configure()
    require("lsp").configure()

    require("bindings").configure()

    require("whitespace").remove_trailing_whitespace_on_save()
end
