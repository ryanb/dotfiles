if not vim.g.vscode then
    require("options").configure()

    -- Some other packages need this:
    require("plugins/plenary").configure()

    -- Language support:
    require("plugins/nvim-treesitter").configure()
    require("plugins/nvim-cmp").configure()
    require("plugins/nvim-lspconfig").configure()
    require("plugins/neotest").configure()

    -- Appearance:
    require("plugins/nvim-web-devicons").configure()
    require("plugins/jellybeans").configure()
    require("plugins/lualine").configure()
    require("plugins/gitsigns").configure()
    require("plugins/nvim-notify").configure()

    -- Navigation:
    require("plugins/telescope").configure()
    -- require("plugins/nvim-tree").configure()
    require("plugins/neo-tree").configure()
    require("plugins/vim-rails").configure()
    require("plugins/bufdelete").configure()
    require("plugins/which-key").configure()

    -- Editing:
    require("plugins/nvim-autopairs").configure()
    require("plugins/nvim-ts-autotag").configure()
    require("plugins/vim-commentary").configure()
    require("plugins/nvim-surround").configure()
    require("plugins/neoformat").configure()

    require("key_mappings").configure()
end
