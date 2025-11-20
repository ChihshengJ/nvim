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
			"pyright",
			"rust_analyzer",
			"clangd",
		},
		automatic_installation = true,
		automatic_enable = {
			exclude = {
				"rust_analyzer",
			},
		},
	},
}
