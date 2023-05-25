local function set_options()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
    vim.opt.expandtab = true
    vim.opt.breakindent = true
    vim.opt.linebreak = true
    vim.opt.scrolloff = 2
    vim.opt.tildeop = true   -- Make the ~ command behave like an operator.
    vim.opt.showmatch = true -- Show matching brackets when typing.
    vim.opt.mouse = "a"

    -- Use relative line numbering, but display the actual line
    -- number on the current line, and highlight it.
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.cursorline = true
    vim.opt.cursorlineopt = "number"
end

local function packadd(package)
    vim.cmd["packadd!"](package)
end

local function configure_colors()
    vim.opt.termguicolors = true
    packadd("jellybeans.vim")
    -- Use the terminal's background instead of black:
    vim.g.jellybeans_overrides = { background = { guibg = "none" } }
    vim.cmd.colorscheme("jellybeans")
end

local function configure_icons()
    -- Used for telescope, nvim-tree, and lualine
    packadd("nvim-web-devicons")
    local devicons = require("nvim-web-devicons")
    devicons.setup({ default = true })
end

local function configure_status_line()
    packadd("lualine.nvim")
    local lualine = require("lualine")
    lualine.setup({ options = { theme = "auto" } })
    vim.opt.showmode = false -- Lualine shows the mode for us.
end

local function configure_syntax_highlighting()
    packadd("nvim-treesitter")
    packadd("nvim-treesitter-textobjects")
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
            highlight = { enable = true },
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
                    goto_next_start = { ["]m"] = "@function.outer" },
                    goto_next_end = { ["]M"] = "@function.outer" },
                    goto_previous_start = { ["[m"] = "@function.outer" },
                    goto_previous_end = { ["[M"] = "@function.outer" }
                }
            }
        }
    )
end

local function configure_fuzzy_finder()
    packadd("telescope.nvim")
    packadd("telescope-ui-select.nvim")

    local telescope = require("telescope")
    telescope.setup {
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_cursor()
            }
        }
    }
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
end

local function configure_autoclosing()
    packadd("nvim-autopairs")
    local autopairs = require("nvim-autopairs")
    autopairs.setup({})

    packadd("nvim-ts-autotag")
    local autotag = require("nvim-ts-autotag")
    autotag.setup()
end

local function configure_autoformatting()
    packadd("neoformat")
    vim.g.neoformat_try_node_exe = true
end

local function configure_git_signs()
    packadd("gitsigns.nvim")
    local gitsigns = require("gitsigns")
    gitsigns.setup()
end

local function remove_trailing_whitespace_on_save()
    vim.api.nvim_create_augroup("removeTrailingWhitespace", { clear = true })
    vim.api.nvim_create_autocmd(
        "BufWritePre",
        {
            pattern = "*",
            group = "removeTrailingWhitespace",
            command = "%s/\\s\\+$//e"
        }
    )
end

set_options()

packadd("plenary.nvim") -- A couple of other packages need this.

-- Configure how everything looks.
configure_colors()
configure_icons()
configure_status_line()
configure_syntax_highlighting()

-- Set up navigation and key bindings.
local telescope_builtin = configure_fuzzy_finder()
local nvim_tree_api = configure_file_navigation()
local on_lsp_attach = configure_key_bindings(telescope_builtin, nvim_tree_api)
local cmp_capabilities = configure_completion()
configure_language_server(on_lsp_attach, cmp_capabilities)

-- Configure various other helpful plugins.
configure_autoclosing()
configure_autoformatting()
configure_git_signs()
packadd("vim-commentary")
packadd("vim-rails")

remove_trailing_whitespace_on_save()
