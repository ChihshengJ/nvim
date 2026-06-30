return {
	"mason-org/mason-lspconfig.nvim",
	event = "BufReadPre",
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = {
		-- Install only. Enabling is owned by config.lsp (vim.lsp.enable).
		ensure_installed = {
			"lua_ls",
			"jsonls",
			"biome",
			"rust_analyzer",
			"clangd",
			"harper_ls",
			"ltex_plus",
			"texlab",
		},
		automatic_installation = true,
		automatic_enable = false,
	},
}
