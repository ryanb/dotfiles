-- Don't load all our plugins and stuff in VSCode.
if vim.g.vscode then
    return
end

local colorscheme = "nordfox"

-- These need to happen before plugins have loaded:
require("options").configure()
require("file_types").configure()
require("signs").configure()

-- Then we install and load the plugins:
require("plugins").configure(colorscheme)

-- And these need to happen after the plugins have loaded:
vim.cmd.colorscheme(colorscheme)
require("key_mappings").configure()
