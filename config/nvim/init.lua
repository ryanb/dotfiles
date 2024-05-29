-- Don't load all our plugins and stuff in VSCode.
if vim.g.vscode then
    return
end

local colorscheme = "nordfox"

-- Plugins depend on some of the options, so set them first.
require("options").configure()
require("file_types").configure()

-- Now install and load plugins.
require("plugins").configure(colorscheme)

-- Once our colorscheme plugin is loaded, we can set the colorscheme.
vim.cmd.colorscheme(colorscheme)

-- And now Key mappings that depend on plugins can happen.
require("key_mappings").configure()
require("signs").configure()
