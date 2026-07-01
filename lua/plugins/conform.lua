return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			python = { "ruff_organize_imports", "ruff_format" },
			javascript = { "biome" },
			javascriptreact = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			json = { "biome" },
			jsonc = { "biome" },
			css = { "biome" },
			html = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},
		formatters = {
			shfmt = {
				prepend_args = { "-i", "4" },
			},
		},
		-- Format on save; fall back to LSP formatting when no formatter is set.
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
