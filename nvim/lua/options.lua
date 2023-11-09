local function configure_options()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
    vim.opt.expandtab = true
    vim.opt.breakindent = true
    vim.opt.linebreak = true
    vim.opt.scrolloff = 2
    vim.opt.tildeop = true
    vim.opt.showmatch = true
    vim.opt.mouse = "a"

    -- Use relative line numbering, but display the actual line
    -- number on the current line, and highlight it.
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.cursorline = true
    vim.opt.cursorlineopt = "number"

    -- Stop checkhealth complaining about missing language providers.
    -- I never use the language-specific interfaces anyway.
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
end

local function configure_key_bindings()
    vim.g.mapleader = ","

    local telescope_builtin = require("telescope.builtin")
    local nvim_tree_api = require("nvim-tree.api")

    local bind = vim.keymap.set

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

    vim.api.nvim_create_autocmd(
        "LspAttach",
        {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(args)
                local opts = {buffer = args.buf}

                bind("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                bind("n", "<leader>cd", telescope_builtin.diagnostics, opts)
                bind("n", "<leader>cr", vim.lsp.buf.rename, opts)
                bind("n", "<leader>cs", telescope_builtin.lsp_document_symbols, opts)

                bind("n", "K", vim.lsp.buf.hover, opts)
                bind("n", "gd", vim.lsp.buf.definition, opts)
                bind("n", "gr", vim.lsp.buf.references, opts)
            end
        }
    )
end

local function remove_trailing_whitespace_on_save()
    vim.api.nvim_create_augroup("removeTrailingWhitespace", {clear = true})
    vim.api.nvim_create_autocmd(
        "BufWritePre",
        {
            pattern = "*",
            group = "removeTrailingWhitespace",
            command = "%s/\\s\\+$//e"
        }
    )
end

return {
    configure = function()
        configure_options()
        configure_key_bindings()
        remove_trailing_whitespace_on_save()
    end
}
