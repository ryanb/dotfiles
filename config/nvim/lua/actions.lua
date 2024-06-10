-- This file wraps up a bunch of useful things that we want to use for key
-- mappings into convenient functions.

local gitsigns = require("gitsigns")
local neo_tree = require("neo-tree.command")
local telescope = require("telescope.builtin")

return {
    -- Open the current project on GitHub in a browsers.
    browse_on_github = function()
        vim.cmd("silent !gh browse")
    end,

    -- Set the commit against which git differences are shown in both the
    -- gutter (using Gitsigns) and the explorer (Neo-tree).
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

    -- Restore open windows and buffers that were previously saved with
    -- save_session_and_quit.
    restore_session = function()
        vim.cmd.source("Session.vim")
    end,

    -- Save open windows and buffers to a Session.vim file and quit.
    save_session_and_quit = function()
        -- Neo-tree buffers don't restore correctly, so close it first.
        neo_tree.execute({ action = "close" })
        vim.cmd.wall()
        vim.cmd.mksession({ bang = true })
        vim.cmd.quit()
    end,

    -- Switch to the Files tab in Neo-tree, and focus on the file currently
    -- being edited, expanding any necessary directories.
    show_current_file_in_neo_tree = function()
        neo_tree.execute({ action = "focus", source = "filesystem", reveal = true })
    end,

    -- Open Neo-tree if it's closed, or close it if it's open.
    toggle_neo_tree = function()
        neo_tree.execute({ action = "focus", toggle = true })
    end,

    -- Save every open buffer.
    write_all = function()
        vim.cmd.wall()
        vim.notify("Saved all files.")
    end,

    -- Save every open buffer and quit Neovim.
    write_all_and_quit = function()
        vim.cmd("confirm xall")
    end,
}
