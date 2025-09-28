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
			"clangd",
			"rust_analyzer",
			"ltex",
		},
		automatic_installation = true,
	},
}
