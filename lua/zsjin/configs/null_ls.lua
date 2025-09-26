-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	sources = {
		-- Python linter & formatter
		null_ls.builtins.code_actions.gitsigns,
		require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
		require("none-ls.diagnostics.ruff"),

		-- other formatters/linters
		formatting.prettier,
		formatting.stylua,
		formatting.shfmt.with({ args = { "-i", "4" } }),
		require("none-ls.diagnostics.eslint").with({
			condition = function(utils)
				return utils.root_has_file(".eslintrc.js")
			end,
		}),
	},

	-- format on save
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(c)
							return c.name == "null-ls" -- only use null-ls for formatting
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
