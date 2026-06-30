-- bootstrap from github
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

-- Make mason-installed tools (stylua, shfmt, prettier, biome, ...) resolvable
-- even before mason.nvim is lazily loaded, so conform/formatters find them.
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- core (cheap, load eagerly so keymaps/options are live from the first frame)
require("zsjin.core.options")
require("zsjin.core.keymaps")

-- plugins
require("zsjin.configs.plugin_manager")

-- LSP setup; runs after lazy so blink.cmp is resolvable for capabilities
require("zsjin.core.lsp")

-- anything that depends on plugins being available
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("zsjin.core.listeners")
		require("zsjin.core.colorscheme")
	end,
})
