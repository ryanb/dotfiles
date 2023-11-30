local neo_tree_command = require("neo-tree.command")

local function explore_buffers()
    neo_tree_command.execute({ action = "focus", source = "buffers" })
end

local function explore_files()
    neo_tree_command.execute({ action = "focus", source = "filesystem" })
end

local function explore_git_status()
    neo_tree_command.execute({ action = "focus", source = "git_status" })
end

local function open_quickfix_window()
    local window_id = vim.fn.win_getid()
    vim.api.nvim_cmd({ cmd = "copen", mods = { keepalt = true } }, {})
    vim.fn.win_gotoid(window_id)
end

local function restart_eslint()
    local function done()
        vim.notify("eslint_d restarted")
    end
    vim.loop.spawn("eslint_d", { args = { "restart" } }, done)
end

local function test_file()
    vim.cmd.TestFile()
    open_quickfix_window()
end

local function test_last()
    vim.cmd.TestLast()
    open_quickfix_window()
end

local function test_nearest()
    vim.cmd.TestNearest()
    open_quickfix_window()
end

local function write_all_and_quit()
    vim.cmd("confirm xall")
end

return {
    explore_buffers = explore_buffers,
    explore_files = explore_files,
    explore_git_status = explore_git_status,
    open_quickfix_window = open_quickfix_window,
    restart_eslint = restart_eslint,
    test_file = test_file,
    test_last = test_last,
    test_nearest = test_nearest,
    write_all_and_quit = write_all_and_quit,
}
