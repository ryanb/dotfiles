local packadd = require("helpers/packadd")

local function configure_syntax_highlighting()
    packadd("nvim-treesitter") -- https://github.com/nvim-treesitter/nvim-treesitter
    packadd("nvim-treesitter-textobjects") -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup(
        {
            ensure_installed = {
                "lua",
                "javascript",
                "typescript",
                "tsx",
                "css",
                "scss",
                "ruby"
            },
            highlight = {enable = true},
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner"
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {["]m"] = "@function.outer"},
                    goto_next_end = {["]M"] = "@function.outer"},
                    goto_previous_start = {["[m"] = "@function.outer"},
                    goto_previous_end = {["[M"] = "@function.outer"}
                }
            }
        }
    )

    -- Treesitter ain't got suppot for slim, so:
    packadd("vim-slim")
end

local function configure_completion()
    packadd("nvim-cmp") -- https://github.com/hrsh7th/nvim-cmp
    packadd("vim-vsnip") -- https://github.com/hrsh7th/vim-vsnip

    local cmp = require("cmp")
    cmp.setup(
        {
            sources = {
                {name = "nvim_lsp"}
            },
            mapping = cmp.mapping.preset.insert(
                {
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({select = true})
                }
            ),
            -- I don't use snippets, but cmp doesn't work without a snippet plugin, so:
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end
            }
        }
    )
end

local function configure_language_server()
    packadd("cmp-nvim-lsp") -- https://github.com/sar/cmp-lsp.nvim
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Hook completion up to the language server.
    local lsp_opts = {
        capabilities = cmp_nvim_lsp.default_capabilities()
    }

    packadd("nvim-lspconfig") -- https://github.com/neovim/nvim-lspconfig
    local lsp = require("lspconfig")

    -- For other language servers see:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    lsp.lua_ls.setup(lsp_opts)
    lsp.sorbet.setup(lsp_opts)
    lsp.tsserver.setup(lsp_opts)
end

local function configure_testing()
    packadd("neotest")
    packadd("neotest-rspec")

    local neotest = require("neotest")
    neotest.setup(
        {
            adapters = {
                require("neotest-rspec")
            }
        }
    )
end

return {
    configure = function()
        configure_syntax_highlighting()
        configure_completion()
        configure_language_server()
        configure_testing()
    end
}
