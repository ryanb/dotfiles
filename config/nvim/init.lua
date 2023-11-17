if not vim.g.vscode then
    require("bootstrap_lazy").bootstrap()

    require("options").configure()
    require("lazy").setup("plugins")
    require("key_mappings").configure()
end
