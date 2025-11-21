return {
	"mason-org/mason-lspconfig.nvim",
	event = "BufReadPre",
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = {
		ensure_installed = {
			"lua_ls",
			"ts_ls",
			"jsonls",
			"eslint",
			"basedpyright",
			"rust_analyzer",
			"clangd",
			"harper_ls",
			"ltex_plus",
			"texlab",
		},
		automatic_installation = true,
		automatic_enable = {
			exclude = {
				-- rustacean will load it
				"rust_analyzer",
			},
		},
	},
}
