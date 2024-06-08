local gitsigns = require("gitsigns")
local neo_tree = require("neo-tree.command")
local telescope = require("telescope.builtin")

return {
    toggle_neo_tree = function()
        neo_tree.execute({ action = "focus", position = "right", toggle = true })
    end,

    show_current_file_in_neo_tree = function()
        neo_tree.execute({ action = "focus", position = "right", source = "filesystem", reveal = true })
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
        local callback = function(git_base)
            gitsigns.change_base(git_base, true)
            neo_tree.execute({ action = "focus", position = "right", source = "git_status", git_base = git_base })
            vim.notify("Showing git differences from " .. git_base)
        end
        vim.ui.select({ "HEAD", "main", "HEAD~1" }, { prompt = "Show git differences from:" }, callback)
    end,
}
