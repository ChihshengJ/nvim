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

	-- commenting with gc
	"numToStr/Comment.nvim",

	-- vs-code like icons
	"nvim-tree/nvim-web-devicons",

	-- snippets
	"L3MON4D3/LuaSnip", -- snippet engine
	"rafamadriz/friendly-snippets", -- useful snippets

	--LSP related
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"lukas-reineke/lsp-format.nvim",
			"nvimtools/none-ls-extras.nvim",
			"jayp0521/mason-null-ls.nvim",
		},
		config = function()
			require("zsjin.configs.null_ls")
		end,
	},

	-- configuring lsp servers
	"jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports,
	"onsails/lspkind.nvim", -- vs-code like icons for autocompletion

	-- git integration
	"lewis6991/gitsigns.nvim",

	-- markdown preview
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
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
