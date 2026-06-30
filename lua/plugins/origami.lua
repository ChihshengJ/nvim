return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	opts = {
		autoFold = {
			enabled = true,
			kinds = { "comments", "imports", "region" },
		},
	},

	init = function()
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
	end,
}
