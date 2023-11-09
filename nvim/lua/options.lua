local packadd = require("helpers/packadd")
local bind = vim.keymap.set

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

local function configure_navigation_bindings()
    local telescope_builtin = require("telescope.builtin")
    local telescope_utils = require("telescope.utils")
    local nvim_tree_api = require("nvim-tree.api")

    local function find_in_directory()
        telescope_builtin.find_files({cwd = telescope_utils.buffer_dir()})
    end

    bind("n", "<leader>fb", telescope_builtin.buffers, {desc = "find buffers"})
    bind("n", "<leader>ff", telescope_builtin.find_files, {desc = "find files"})
    bind("n", "<leader>fg", telescope_builtin.git_status, {desc = "find git status"})
    bind("n", "<leader>fd", find_in_directory, {desc = "find in current dir"})
    bind("n", "<leader>fe", nvim_tree_api.tree.toggle, {desc = "file explorer"})
end

local function configure_testing_bindings()
    local neotest = require("neotest")

    local function run_file()
        neotest.run.run(vim.fn.expand("%"))
    end

    bind("n", "<leader>tf", run_file, {desc = "run tests in file"})
    bind("n", "<leader>tl", neotest.run.run_last, {desc = "run last test"})
    bind("n", "<leader>tn", neotest.run.run, {desc = "run nearest test"})
    bind("n", "<leader>ts", neotest.summary.toggle, {desc = "toggle test summary"})
end

local function configure_lsp_bindings(args)
    local telescope_builtin = require("telescope.builtin")

    local buffer = args.buf

    bind("n", "<leader>ca", vim.lsp.buf.code_action, {buffer = buffer, desc = "code actions"})
    bind("n", "<leader>cd", telescope_builtin.diagnostics, {buffer = buffer, desc = "diagnostics"})
    bind("n", "<leader>cr", vim.lsp.buf.rename, {buffer = buffer, desc = "rename"})
    bind("n", "<leader>cs", telescope_builtin.lsp_document_symbols, {buffer = buffer, desc = "document symbols"})

    bind("n", "K", vim.lsp.buf.hover, {buffer = buffer})
    bind("n", "gd", vim.lsp.buf.definition, {buffer = buffer})
    bind("n", "gr", vim.lsp.buf.references, {buffer = buffer})
end

local function configure_which_key()
    packadd("which-key.nvim")
    local which_key = require("which-key")

    vim.o.timeout = true
    vim.o.timeoutlen = 500

    which_key.setup({})
    which_key.register(
        {
            c = "code",
            f = "find",
            t = "tests"
        },
        {
            prefix = "<leader>"
        }
    )
end

local function configure_key_bindings()
    vim.g.mapleader = ","

    -- Shortcuts for navigation between windows
    bind("n", "<c-h>", "<c-w>h")
    bind("n", "<c-j>", "<c-w>j")
    bind("n", "<c-k>", "<c-w>k")
    bind("n", "<c-l>", "<c-w>l")

    -- Reselect the visual area when changing indenting in visual mode.
    bind("v", "<", "<gv")
    bind("v", ">", ">gv")

    configure_navigation_bindings()
    configure_testing_bindings()

    vim.api.nvim_create_augroup("lspKeyBindings", {clear = true})
    vim.api.nvim_create_autocmd("LspAttach", {group = "lspKeyBindings", callback = configure_lsp_bindings})

    configure_which_key()
end

return {
    configure = function()
        configure_options()
        configure_key_bindings()
    end
}
