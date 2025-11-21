local utils = require("zsjin.utils")
local signs = utils.signs

local M = {}

M.capabilities = require("blink.cmp").get_lsp_capabilities()

function M.on_attach(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	M.set_keys(client, bufnr)
end

function M.format()
	vim.lsp.buf.format()
end

M.diagnostics_active = true

function M.toggle_diagnostics()
	M.diagnostics_active = not M.diagnostics_active
	if M.diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

function M.toggle_hints()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end

function M.format_sync()
	vim.lsp.buf.format({ async = true })
end

function M.set_keys(client, buffer)
	-- Keymaps for LSP
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local keymap = vim.keymap

	-- set keybinds
	keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	keymap.set("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition in a floating window
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right-hand side
end

return M
