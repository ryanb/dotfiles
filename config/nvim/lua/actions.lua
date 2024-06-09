local gitsigns = require("gitsigns")
local neo_tree = require("neo-tree.command")
local telescope = require("telescope.builtin")

return {
    choose_git_base = function()
        local callback = function(git_base)
            if git_base ~= nil then
                gitsigns.change_base(git_base, true)
                neo_tree.execute({ action = "focus", source = "git_status", git_base = git_base })
                vim.notify("Showing git differences from " .. git_base)
            end
        end
        vim.ui.select({ "main", "HEAD", "HEAD~1" }, { prompt = "Show git differences from:" }, callback)
    end,

    -- TODO: This isn't called from anywhere. The key bindings currently call
    -- `telescope.grep_string` without arguments, which does pretty much the
    -- same thing. If that doesn't turn out to annoy me, I can delete this.
    find_word_under_cursor = function()
        telescope.grep_string({ search = vim.fn.expand("<cword>") })
    end,

    save_session_and_quit = function()
        -- Neo-tree buffers don't restore correctly, so close it first.
        neo_tree.execute({ action = "close" })
        vim.cmd.wall()
        vim.cmd("mksession!")
        vim.cmd.quit()
    end,

    show_current_file_in_neo_tree = function()
        neo_tree.execute({ action = "focus", source = "filesystem", reveal = true })
    end,

    toggle_neo_tree = function()
        neo_tree.execute({ action = "focus", toggle = true })
    end,

    write_all = function()
        vim.cmd.wall()
        vim.notify("Saved all files.")
    end,

    write_all_and_quit = function()
        vim.cmd("confirm xall")
    end,
}
