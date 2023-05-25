local packadd = require("packadd")

packadd("plenary.nvim") -- Some other packages need this.

require("options").configure()
require("styling").configure()
require("navigation").configure()
require("plugins").configure()

require("whitespace").remove_trailing_whitespace_on_save()
