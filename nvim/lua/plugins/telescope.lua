local packadd = require("helpers").packadd
local bind = require("helpers").bind

local function configure()
    packadd("telescope.nvim") -- https://github.com/nvim-telescope/telescope.nvim
    packadd("telescope-ui-select.nvim") -- https://github.com/nvim-telescope/telescope-ui-select.nvim

    local telescope = require("telescope")
    telescope.setup(
        {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_cursor()
                }
            }
        }
    )
    telescope.load_extension("ui-select")

    local telescope_builtin = require("telescope.builtin")
    local telescope_utils = require("telescope.utils")

    local function find_in_directory()
        telescope_builtin.find_files({cwd = telescope_utils.buffer_dir()})
    end

    bind("n", "<leader>fb", telescope_builtin.buffers, {desc = "find buffers"})
    bind("n", "<leader>ff", telescope_builtin.find_files, {desc = "find files"})
    bind("n", "<leader>fg", telescope_builtin.git_status, {desc = "find git status"})
    bind("n", "<leader>fd", find_in_directory, {desc = "find in current dir"})
end

return {configure = configure}
