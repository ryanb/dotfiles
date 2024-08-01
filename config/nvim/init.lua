-- Highlights of this config are:
--
-- * Plugin management with lazy.nvim
-- * Automatic installation of language servers and formatters with mason.nvim
-- * Language server support with nvim-lspconfig
-- * Auto-formatting with null-ls
-- * Completion with nvim-cmp
-- * Syntax highlighting with nvim-treesitter
--
-- For a bit of IDE-like UI, I have:
--
-- * A file explorer in the sidebar with Neo-tree
-- * Fuzzy finding of all sorts of things with Telescope
--
-- I keep the UI much more minimal than a normal IDE. I'm easily distracted, so
-- I want my code front-and-centre with not too much other information.
--
-- See the lua/plugin-specs directory for more.

-- Don't load all our plugins and stuff in VSCode.
if vim.g.vscode then
    return
end

-- I use Nightfox's Nordfox variant, with some tweaks.
-- See lua/plugin-specs/ui/init.lua
local colorscheme = "nordfox"

-- Some plugins depend on particular options being set, so set options first.
require("options").configure()

local plugins = require("plugins")
plugins.install_lazy()
plugins.install_and_load_plugins(colorscheme)

-- And these depend on the plugins being loaded, so do them last.
vim.cmd.colorscheme(colorscheme)
require("key-mappings").configure()

require("format-on-save").configure()
