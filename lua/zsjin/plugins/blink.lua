return {
	"saghen/blink.cmp",
	build = "cargo build --release",
	event = "InsertEnter",
	dependencies = {
		{
			"rafamadriz/friendly-snippets",
		},
	},
	opts = {
		keymap = {
			["<CR>"] = { "accept", "fallback" },
		},
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
				treesitter_highlighting = true,
			},
			list = {
				selection = { preselect = false, auto_insert = true },
			},
		},
		signature = { enabled = true },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
	},
	opts_extend = { "sources.default" },
}
