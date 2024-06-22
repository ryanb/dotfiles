-- This file wraps up a bunch of useful things that we want to use for key
-- mappings into convenient functions.

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
                local gitsigns = require("gitsigns")
                gitsigns.change_base(git_base, true)

                local neo_tree = require("neo-tree.command")
                neo_tree.execute({ action = "focus", source = "git_status", git_base = git_base })

                vim.notify("Showing git differences from " .. git_base)
            end
        end
        vim.ui.select({ "main", "HEAD", "HEAD~1" }, { prompt = "Show git differences from:" }, callback)
    end,

    -- Use treesj to join blocks of code.
    join_code = function()
        require("treesj").join()
    end,

    -- Restore open windows and buffers that were previously saved with
    -- save_session_and_quit.
    restore_session = function()
        vim.cmd.source("Session.vim")
    end,

    -- Save open windows and buffers to a Session.vim file and quit.
    save_session_and_quit = function()
        -- Neo-tree buffers don't restore correctly, so close it first.
        local neo_tree = require("neo-tree.command")
        neo_tree.execute({ action = "close" })
        vim.cmd.wall()
        vim.cmd.mksession({ bang = true })
        vim.cmd.quit()
    end,

    -- Lazy load refactoring and select a refactor.
    select_refactor = function()
        require("refactoring").select_refactor()
    end,

    -- Switch to the Files tab in Neo-tree, and focus on the file currently
    -- being edited, expanding any necessary directories.
    show_current_file_in_neo_tree = function()
        local neo_tree = require("neo-tree.command")
        neo_tree.execute({ action = "focus", source = "filesystem", reveal = true })
    end,

    -- Use treesj to split blocks of code.
    split_code = function()
        require("treesj").split()
    end,

    -- Search notifications in Telescope.
    telescope_notify = function()
        require("telescope").extensions.notify.notify()
    end,

    -- Open Neo-tree if it's closed, or close it if it's open.
    toggle_neo_tree = function()
        local neo_tree = require("neo-tree.command")
        neo_tree.execute({ action = "focus", toggle = true })
    end,

    -- Save every open buffer.
    write_all = function()
        vim.cmd.wall()
        vim.notify("Saved.", vim.log.levels.INFO, { hide_from_history = true })
    end,

    -- Save every open buffer and quit Neovim.
    write_all_and_quit = function()
        vim.cmd("confirm xall")
    end,
}
