local function configure()
    vim.cmd.packadd({ "nui.nvim", bang = true }) -- https://github.com/MunifTanjim/nui.nvim
    vim.cmd.packadd({ "neo-tree.nvim", bang = true }) -- https://github.com/nvim-neo-tree/neo-tree.nvim
    local neotree = require("neo-tree")
    neotree.setup({
        sources = {
            "filesystem",
            "buffers",
            "git_status",
            "document_symbols",
        },
        bind_to_cwd = false,
        use_popups_for_input = false,
        filesystem = {
            use_libuv_file_watcher = true,
        },
    })

    local command = require("neo-tree.command")

    local function toggle()
        command.execute({ reveal_file = vim.fn.expand("%:p"), toggle = true })
    end

    local function open_root_directory()
        -- Passing -1, -1 gets us the global cwd, rather than the window local version.
        command.execute({ reveal_file = vim.fn.expand("%:p"), dir = vim.fn.getcwd(-1, -1) })
    end

    local function open_buffer_directory()
        command.execute({ reveal_file = vim.fn.expand("%:p"), dir = vim.fn.expand("%:p:h") })
    end

    local function open_buffers()
        command.execute({ source = "buffers" })
    end

    local function open_git_status()
        command.execute({ source = "git_status" })
    end

    local function open_document_symbols()
        command.execute({ source = "document_symbols" })
    end

    vim.keymap.set("n", "<leader>eb", open_buffers, { desc = "open file explorer with buffers" })
    vim.keymap.set("n", "<leader>ed", open_buffer_directory, { desc = "open file explorer in dir of current buffer" })
    vim.keymap.set("n", "<leader>ef", toggle, { desc = "toggle file explorer" })
    vim.keymap.set("n", "<leader>eg", open_git_status, { desc = "open file explorer with git status" })
    vim.keymap.set("n", "<leader>er", open_root_directory, { desc = "open file exporer with project root" })
    vim.keymap.set("n", "<leader>es", open_document_symbols, { desc = "open file exporer with document symbols" })
end

return { configure = configure }