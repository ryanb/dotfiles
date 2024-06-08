local gitsigns = require("gitsigns")
local neo_tree = require("neo-tree.command")
local neo_tree_command = require("neo-tree.command")
local telescope = require("telescope.builtin")

-- Open the quickfix window without focussing on it.
local function open_quickfix_window()
    local window_id = vim.fn.win_getid()
    vim.api.nvim_cmd({ cmd = "copen", mods = { keepalt = true } }, {})
    vim.fn.win_gotoid(window_id)
end

return {
    explore_buffers = function()
        neo_tree.execute({ action = "focus", position = "right", source = "buffers" })
    end,

    explore_files = function()
        neo_tree.execute({ action = "focus", position = "right", source = "filesystem" })
    end,

    explore_current_file = function()
        neo_tree.execute({ action = "focus", position = "right", source = "filesystem", reveal = true })
    end,

    explore_git_status = function()
        neo_tree.execute({ action = "focus", position = "right", source = "git_status" })
    end,

    find_word_under_cursor = function()
        telescope.grep_string({ search = vim.fn.expand("<cword>") })
    end,

    write_all = function()
        vim.cmd.wall()
        vim.notify("Saved.")
    end,

    write_all_and_quit = function()
        vim.cmd("confirm xall")
    end,

    choose_git_base = function()
        vim.ui.select({ "HEAD", "main", "HEAD~1" }, { prompt = "Show git differences from:" }, function(git_base)
            gitsigns.change_base(git_base, true)
            neo_tree_command.execute({
                action = "focus",
                source = "git_status",
                git_base = git_base,
            })
            vim.notify("Showing git differences from " .. git_base)
        end)
    end,
}