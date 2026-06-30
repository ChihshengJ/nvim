return {

	"nvim-lua/plenary.nvim", -- lua functions that many plugins use

	{ "catppuccin/nvim", name = "catppuccin", lazy = false },

	"christoomey/vim-tmux-navigator", -- tmux & split window navigation

	"szw/vim-maximizer", -- maximizes and restores current window

	{
		"windwp/nvim-autopairs",
		config = true,
	},
	{
		"kylechui/nvim-surround",
		keys = { "ys", "ds", "cs" },
		config = true,
	},
	"inkarkat/vim-ReplaceWithRegister", -- replace with register contents using motion

	-- vs-code like icons
	"nvim-tree/nvim-web-devicons",

	-- snippets
	"L3MON4D3/LuaSnip", -- snippet engine
	"rafamadriz/friendly-snippets", -- useful snippets

	-- icons for autocompletion menus
	"onsails/lspkind.nvim", -- vs-code like icons for autocompletion

	-- git integration
	"lewis6991/gitsigns.nvim",

	-- git diff
	"sindrets/diffview.nvim",

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install && git restore .",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_open_to_the_world = 1
			vim.g.mkdp_port = "11454"
		end,
		ft = { "markdown" },
	},

	-- plist manipulation
	"darfink/vim-plist",

	--rust development
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
}
