-- bootstrap from github
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"git@github.com:folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("zsjin.core.options") -- vim options
require("zsjin.configs.plugin_manager")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("zsjin.core.listeners")
		require("zsjin.core.keymaps")
		require("zsjin.core.diagnostics")
		require("zsjin.core.capabilities")
		require("zsjin.core.colorscheme")
	end,
})
