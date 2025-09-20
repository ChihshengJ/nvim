-- import lspconfig plugin
vim.lsp.config()

-- import cmd-nvim-lsp for autocompletion
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_nvim_lsp then
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end

-- Shared function for LSP attachments
local on_attach = function(client, bufnr)
	-- Keymaps for LSP
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local keymap = vim.keymap

	-- set keybinds
	keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "<leader>fd", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- show diagnostics in float windows
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

	-- if client.supports_method("textDocument/formatting") then
	--   local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	--   vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	--   vim.api.nvim_create_autocmd("BufWritePre", {
	--     group = augroup,
	--     buffer = bufnr,
	--     callback = function()
	--       vim.lsp.buf.format({
	--         filter = function(c) return c.name == "null-ls" end,
	--         bufnr = bufnr,
	--       })
	--     end,
	--   })
	-- end
end

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
		},
		-- linehl = {
		--   [vim.diagnostic.severity.ERROR] = "Error",
		--   [vim.diagnostic.severity.WARN] = "Warn",
		--   [vim.diagnostic.severity.INFO] = "Info",
		--   [vim.diagnostic.severity.HINT] = "Hint",
		-- },
	},
	underline = true, -- only underline the word/region
	virtual_text = true, -- show inline messages (optional)
	update_in_insert = false, -- don’t update while typing
})

-- Python
lspconfig.pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
			},
		},
	},
})

-- Lua
lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

-- Ltex
lspconfig.ltex.setup({
	filetypes = { "tex", "latex", "bib" },
	on_attach = on_attach,
	settings = {
		ltex = {
			language = "en-US",
		},
	},
})
