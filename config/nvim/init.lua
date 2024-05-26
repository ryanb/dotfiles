if not vim.g.vscode then
    require("options").configure()
    require("file_types").configure()

    require("bootstrap_lazy").bootstrap()
    require("lazy").setup({
        -- Don't notify whenever a config file changes. It's not helpful.
        change_detection = {
            enabled = true,
            notify = false,
        },
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
            colorscheme = { "nightfox" },
        },
    })

    require("key_mappings").configure()
end
