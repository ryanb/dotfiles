if not vim.g.vscode then
    require("options").configure()
    require("file_types").configure()

    require("bootstrap_lazy").bootstrap()
    require("lazy").setup({
        spec = {
            -- Lazy will load every file in these directories.
            { import = "plugins.appearance" },
            { import = "plugins.completion" },
            { import = "plugins.editing" },
            { import = "plugins.languages" },
            { import = "plugins.lsp" },
            { import = "plugins.navigation" },
            { import = "plugins.treesitter" },
        },
        install = {
            -- This doesn't set the colorscheme for neovim, it just tells Lazy
            -- to use this colorscheme while it's setting everything up.
            colorscheme = { "jellybeans" },
        },
    })

    require("key_mappings").configure()
end
