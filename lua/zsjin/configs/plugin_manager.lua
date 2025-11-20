local signs = require("zsjin.utils").signs

-- load lazy
require("lazy").setup("zsjin.plugin", {
	install = { colorscheme = { "catppuccin" } },
	defaults = { lazy = false },
	checker = { enabled = true },
	performance = {
		cache = { enabled = true },
	},
	debug = false,
	ui = {
		size = { width = 0.8, height = 0.8 },
		icons = {
			loaded = signs.PassCheck,
			not_loaded = signs.QuestionMark,
			cmd = signs.Cmd,
			config = signs.Config,
			event = signs.Event,
			ft = signs.File,
			init = signs.Config,
			keys = signs.Keyboard,
			plugin = signs.Package,
			runtime = signs.Vim,
			source = signs.Code,
			start = signs.Init,
			task = signs.CheckAlt,
			lazy = signs.Loading,
			list = {
				"●",
				"➜",
				"★",
				"‒",
			},
		},
	},
})
