if not vim.g.vscode then
    require("options").configure()

    require("bootstrap_lazy").bootstrap()
    require("lazy").setup({
        spec = {
            { import = "plugins.appearance" },
            { import = "plugins.editing" },
            { import = "plugins.language" },
            { import = "plugins.navigation" },
        },
        install = {
            colorscheme = { "jellybeans" },
        },
    })

    require("key_mappings").configure()
end
