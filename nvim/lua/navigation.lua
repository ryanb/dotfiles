local packadd = require("packadd")

local function configure_fuzzy_finder()
    packadd("telescope.nvim")           -- https://github.com/nvim-telescope/telescope.nvim
    packadd("telescope-ui-select.nvim") -- https://github.com/nvim-telescope/telescope-ui-select.nvim

    local telescope = require("telescope")
    telescope.setup(
        {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_cursor()
                }
            }
        }
    )
    telescope.load_extension("ui-select")

    return require("telescope.builtin")
end

local function configure_file_navigation()
    packadd("nvim-tree.lua") -- https://github.com/nvim-tree/nvim-tree.lua
    local nvim_tree = require("nvim-tree")
    nvim_tree.setup(
        {
            filters = { dotfiles = true },
            update_focused_file = { enable = true }
        }
    )
    return require("nvim-tree.api")
end

local function configure_key_bindings(telescope_builtin, nvim_tree_api)
    local bind = vim.keymap.set

    vim.g.mapleader = ","

    -- Shortcuts for navigation between windows
    bind("n", "<c-h>", "<c-w>h")
    bind("n", "<c-j>", "<c-w>j")
    bind("n", "<c-k>", "<c-w>k")
    bind("n", "<c-l>", "<c-w>l")

    -- Reselect the visual area when changing indenting in visual mode.
    bind("v", "<", "<gv")
    bind("v", ">", ">gv")

    -- Leader mappings
    bind("n", "<leader>b", telescope_builtin.buffers)
    bind("n", "<leader>f", telescope_builtin.find_files)
    bind("n", "<leader>p", "<cmd>Neoformat<cr>")
    bind("n", "<leader>t", nvim_tree_api.tree.toggle)

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
            local buffer_number = args.buf

            bind("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer_number })
            -- bind("v", "<leader>ca", vim.lsp.buf.range_code_action, { buffer = buffer_number })
            bind("n", "<leader>cd", telescope_builtin.diagnostics, { buffer = buffer_number })
            bind("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer_number })
            bind("n", "<leader>cs", telescope_builtin.lsp_document_symbols, { buffer = buffer_number })

            bind("n", "K", vim.lsp.buf.hover, { buffer = buffer_number })
            bind("n", "gd", vim.lsp.buf.definition, { buffer = buffer_number })
            bind("n", "gr", vim.lsp.buf.references, { buffer = buffer_number })
        end
    })
end

local function configure_completion()
    packadd("nvim-cmp")     -- https://github.com/hrsh7th/nvim-cmp
    packadd("vim-vsnip")    -- https://github.com/hrsh7th/vim-vsnip

    local cmp = require("cmp")
    cmp.setup(
        {
            sources = {
              { name = "nvim_lsp" }
            },
            mapping = cmp.mapping.preset.insert({
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab'] = cmp.mapping.select_prev_item(),
                ['<CR>'] = cmp.mapping.confirm({ select = true })
            }),
            -- I don't use snippets, but cmp doesn't work without a snippet plugin, so:
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end
            },
        }
    )
end

local function configure_language_server()
    packadd("cmp-nvim-lsp") -- https://github.com/sar/cmp-lsp.nvim
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    packadd("nvim-lspconfig") -- https://github.com/neovim/nvim-lspconfig
    local lsp = require("lspconfig")

    local lsp_opts = {
        capabilities = cmp_nvim_lsp.default_capabilities()
    }

    -- For other language servers see:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    lsp.lua_ls.setup(lsp_opts)
    lsp.sorbet.setup(lsp_opts)
    -- lsp.tsserver.setup(lsp_opts)
end

return {
    configure = function()
        local telescope_builtin = configure_fuzzy_finder()
        local nvim_tree_api = configure_file_navigation()
        configure_key_bindings(telescope_builtin, nvim_tree_api)

        configure_completion()
        configure_language_server()
    end
}
