if not vim.g.vscode then
    require("options").configure()
    require("key_mappings").configure()

    local function configure_plugin(name)
        require("plugins/" .. name).configure()
    end

    -- Some other packages need this:
    configure_plugin("plenary")

    -- Language support:
    configure_plugin("treesitter")
    configure_plugin("cmp")
    configure_plugin("lspconfig")
    configure_plugin("neotest")

    -- Appearance:
    configure_plugin("web-devicons")
    configure_plugin("jellybeans")
    configure_plugin("lualine")
    configure_plugin("gitsigns")

    -- Navigation:
    configure_plugin("telescope")
    configure_plugin("nvim-tree")
    configure_plugin("rails")
    configure_plugin("which-key")

    -- Editing:
    configure_plugin("autopairs")
    configure_plugin("autotag")
    configure_plugin("commentary")
    configure_plugin("nvim-surround")
    configure_plugin("neoformat")
end
