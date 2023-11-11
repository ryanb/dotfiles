if not vim.g.vscode then
    require("options").configure()
    require("key_mappings").configure()

    -- Some other packages need this:
    require("plugins/plenary").configure()

    -- Language support:
    require("plugins/treesitter").configure()
    require("plugins/cmp").configure()
    require("plugins/lspconfig").configure()
    require("plugins/neotest").configure()

    -- Appearance:
    require("plugins/web-devicons").configure()
    require("plugins/jellybeans").configure()
    require("plugins/lualine").configure()
    require("plugins/gitsigns").configure()
    require("plugins/nvim-notify").configure()

    -- Navigation:
    require("plugins/telescope").configure()
    -- require("plugins/nvim-tree").configure()
    require("plugins/neo-tree").configure()
    require("plugins/rails").configure()
    require("plugins/which-key").configure()

    -- Editing:
    require("plugins/autopairs").configure()
    require("plugins/autotag").configure()
    require("plugins/commentary").configure()
    require("plugins/nvim-surround").configure()
    require("plugins/neoformat").configure()
end
