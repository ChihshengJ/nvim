local signs = require("zsjin.utils").signs

-- ---------------------------------------------------------------------------
-- Global LSP defaults (applied to every server via the "*" pseudo-config)
-- ---------------------------------------------------------------------------
local capabilities = {
	textDocument = {
		semanticTokens = {
			multilineTokenSupport = true,
		},
	},
}

-- Merge in blink.cmp's completion capabilities when available.
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

-- ---------------------------------------------------------------------------
-- Enable servers. Each name resolves to a config in after/lsp/<name>.lua
-- (merged with nvim-lspconfig's bundled defaults). mason.nvim handles install.
-- rust_analyzer is intentionally absent: rustaceanvim owns it.
-- ---------------------------------------------------------------------------
vim.lsp.enable({
	"lua_ls",
	"jsonls",
	"biome",
	"clangd",
	"harper_ls",
	"ltex_plus",
	"texlab",
	"ruff",
	"ty",
	"sourcekit",
})

-- ---------------------------------------------------------------------------
-- Diagnostics
-- ---------------------------------------------------------------------------
vim.diagnostic.config({
	underline = true,
	virtual_text = {
		spacing = 2,
		prefix = "●",
	},
	update_in_insert = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.HINT] = signs.Hint,
			[vim.diagnostic.severity.INFO] = signs.Info,
		},
	},
})

-- ---------------------------------------------------------------------------
-- Per-buffer setup on attach
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
		end

		-- 0.11 provides defaults: K (hover), grn (rename), gra (code action),
		-- grr (references), gri (implementation), gO (document symbol).
		-- Only add what isn't covered by those.
		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			map("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
			end, "Toggle inlay hints")
		end

		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
