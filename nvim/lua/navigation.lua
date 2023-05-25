local packadd = require("packadd")

local function configure_fuzzy_finder()
    packadd("telescope.nvim")
    packadd("telescope-ui-select.nvim")

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
    packadd("nvim-tree.lua")
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

    -- These bindings are set when a language server attaches to a buffer.
    local function on_lsp_attach(client, buffer_number)
        bind("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer_number })
        bind("v", "<leader>ca", vim.lsp.buf.range_code_action, { buffer = buffer_number })
        bind("n", "<leader>cd", telescope_builtin.diagnostics, { buffer = buffer_number })
        bind("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer_number })
        bind("n", "<leader>cs", telescope_builtin.lsp_document_symbols, { buffer = buffer_number })

        bind("n", "K", vim.lsp.buf.hover, { buffer = buffer_number })
        bind("n", "gd", vim.lsp.buf.definition, { buffer = buffer_number })
        bind("n", "gr", vim.lsp.buf.references, { buffer = buffer_number })
    end

    return on_lsp_attach
end

local function configure_completion()
    packadd("nvim-cmp")
    packadd("cmp-nvim-lsp")
    packadd("vim-vsnip") -- cmp doesn't work without a snippet plugin

    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    local cmp = require("cmp")
    cmp.setup(
        {
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end
            },
            sources = {
                { name = "nvim_lsp" }
            }
        }
    )

    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    return cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

local function configure_language_server(on_lsp_attach, cmp_capabilities)
    packadd("nvim-lspconfig")
    local lsp = require("lspconfig")

    local lsp_opts = {
        on_attach = on_lsp_attach,
        capabilities = cmp_capabilities
    }

    lsp.tsserver.setup(lsp_opts)
    lsp.solargraph.setup(lsp_opts)
    lsp.lua_ls.setup(lsp_opts)
end

return {
    configure = function()
        local telescope_builtin = configure_fuzzy_finder()
        local nvim_tree_api = configure_file_navigation()
        local on_lsp_attach = configure_key_bindings(telescope_builtin, nvim_tree_api)
        local cmp_capabilities = configure_completion()
        configure_language_server(on_lsp_attach, cmp_capabilities)
    end
}
