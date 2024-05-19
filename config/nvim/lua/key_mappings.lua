local bufdelete = require("bufdelete")
local gitsigns = require("gitsigns")
local refactoring = require("refactoring")
local telescope = require("telescope.builtin")
local telescope_extensions = require("telescope").extensions
local treesj = require("treesj")
local actions = require("helpers.actions")

local map = vim.keymap.set

-- Set up mappings available in all buffers.
local function map_global_keys()
    -- Things I do often enough that they get a top-level mapping
    map("n", "<leader>/", vim.cmd.nohlsearch, { desc = "clear search" })
    map("n", "<leader><leader>", telescope.find_files, { desc = "find files" })
    map("n", "<leader>d", vim.diagnostic.open_float, { desc = "show diagnostics under cursor" })
    map("n", "<leader>q", actions.write_all_and_quit, { desc = "write all files and quit" })
    map("n", "<leader>w", vim.cmd.close, { desc = "close window" })
    map("n", "<leader>x", bufdelete.bufdelete, { desc = "close buffer" })

    -- Code actions
    map("n", "<leader>cj", treesj.join, { desc = "join lines" })
    map({ "n", "x" }, "<leader>cf", refactoring.select_refactor, { desc = "refactor" })
    map("n", "<leader>cs", treesj.split, { desc = "split lines" })

    -- Explore with Neo-tree
    map("n", "<leader>eb", actions.explore_buffers, { desc = "explore buffers" })
    map("n", "<leader>ec", actions.explore_current_file, { desc = "explore current file" })
    map("n", "<leader>ef", actions.explore_files, { desc = "explore files" })
    map("n", "<leader>eg", actions.explore_git_status, { desc = "explore git status" })

    -- Find with Telescope
    map("n", "<leader>f.", telescope.resume, { desc = "repeat last find" })
    map("n", "<leader>fb", telescope.buffers, { desc = "find buffers" })
    map("n", "<leader>fg", telescope.live_grep, { desc = "live grep" })
    map("n", "<leader>fj", telescope.jumplist, { desc = "find in jumplist" })
    map("n", "<leader>fn", telescope_extensions.notify.notify, { desc = "find in notifications" })
    map("n", "<leader>fw", actions.find_word_under_cursor, { desc = "live grep word under cursor" })

    -- Do git things with gitsigns
    map("n", "<leader>gb", gitsigns.blame_line, { desc = "git blame" })
    map("n", "<leader>gp", gitsigns.preview_hunk_inline, { desc = "preview hunk" })
    map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "stage hunk" })
    map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "undo stage hunk" })

    -- Run tests
    map("n", "<leader>t.", actions.test_last, { desc = "repeat the last test run" })
    map("n", "<leader>tf", actions.test_file, { desc = "run tests in current file" })
    map("n", "<leader>tn", actions.test_nearest, { desc = "run nearest test" })

    -- Restart things (coz they break sometimes)
    map("n", "<leader>ze", actions.restart_eslint, { desc = "restart eslint" })
    map("n", "<leader>zl", vim.cmd.LspRestart, { desc = "restart LSP" })

    -- Move around in the buffer
    map("n", "[g", gitsigns.prev_hunk, { desc = "previous git hunk in buffer" })
    map("n", "]g", gitsigns.next_hunk, { desc = "next git hunk in buffer" })
    map("n", "[q", vim.cmd.cbefore, { desc = "previous quickfix error in buffer" })
    map("n", "]q", vim.cmd.cafter, { desc = "next quickfix error in buffer" })

    -- Navigate between windows
    map("n", "<c-h>", "<c-w>h")
    map("n", "<c-j>", "<c-w>j")
    map("n", "<c-k>", "<c-w>k")
    map("n", "<c-l>", "<c-w>l")

    -- Reselect the visual area when changing indenting in visual mode
    map("v", "<", "<gv")
    map("v", ">", ">gv")
end

-- Set up mappings for buffers with a language server attached.
local function map_lsp_keys(args)
    local buffer = args.buf

    map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code actions" })
    map("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "rename symbol under cursor" })

    map("n", "<leader>fd", telescope.diagnostics, { buffer = buffer, desc = "find diagnostics" })
    map("n", "<leader>fs", telescope.lsp_document_symbols, { buffer = buffer, desc = "find document symbols" })

    map("n", "gd", telescope.lsp_definitions, { buffer = buffer, desc = "Go to defintion" })
    map("n", "gr", telescope.lsp_references, { buffer = buffer, desc = "Go to references" })
end

-- Configure all the key mappings to my liking.
local function configure()
    map_global_keys()

    local group = vim.api.nvim_create_augroup("lspKeyBindings", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", { group = group, callback = map_lsp_keys })
end

return { configure = configure }
