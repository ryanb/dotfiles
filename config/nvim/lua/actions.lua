local neo_tree_command = require("neo-tree.command")

local function open_quickfix_window()
    local window_id = vim.fn.win_getid()
    vim.api.nvim_cmd({ cmd = "copen", mods = { keepalt = true } }, {})
    vim.fn.win_gotoid(window_id)
end

return {
    explore_buffers = function()
        neo_tree_command.execute({ action = "focus", source = "buffers" })
    end,

    explore_files = function()
        neo_tree_command.execute({ action = "focus", source = "filesystem" })
    end,

    explore_git_status = function()
        neo_tree_command.execute({ action = "focus", source = "git_status" })
    end,

    restart_eslint = function()
        local function done()
            vim.notify("eslint_d restarted")
        end
        vim.loop.spawn("eslint_d", { args = { "restart" } }, done)
    end,

    test_file = function()
        vim.cmd.TestFile()
        open_quickfix_window()
    end,

    test_last = function()
        vim.cmd.TestLast()
        open_quickfix_window()
    end,

    test_nearest = function()
        vim.cmd.TestNearest()
        open_quickfix_window()
    end,

    write_all_and_quit = function()
        vim.cmd("confirm xall")
    end,
}