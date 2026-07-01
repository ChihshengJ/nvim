return {
	"rmagatti/goto-preview",
	dependencies = { "rmagatti/logger.nvim" },
	keys = {
		{
			"<leader>pd",
			function()
				require("goto-preview").goto_preview_definition()
			end,
			desc = "Peek definition",
		},
		{
			"<leader>pr",
			function()
				require("goto-preview").goto_preview_references()
			end,
			desc = "Peek references",
		},
		{
			"<leader>pi",
			function()
				require("goto-preview").goto_preview_implementation()
			end,
			desc = "Peek implementation",
		},
		{
			"<leader>pq",
			function()
				require("goto-preview").close_all_win()
			end,
			desc = "Close all preview windows",
		},
	},
	opts = {
		height = 20,
		width = 100,
		dismiss_on_move = false,
		-- Promote the floating preview into a real split/tab, Telescope-style.
		post_open_hook = function(bufnr, winnr)
			local function open_in(cmd)
				local pos = vim.api.nvim_win_get_cursor(winnr)
				local name = vim.api.nvim_buf_get_name(bufnr)
				vim.api.nvim_win_close(winnr, true)
				vim.cmd(cmd .. " " .. vim.fn.fnameescape(name))
				vim.api.nvim_win_set_cursor(0, pos)
			end
			local map = function(lhs, cmd)
				vim.keymap.set("n", lhs, function()
					open_in(cmd)
				end, { buffer = bufnr, desc = "Open preview in " .. cmd })
			end
			map("<C-v>", "vsplit")
			map("<C-x>", "split")
			map("<C-t>", "tabedit")

			-- Esc closes this preview float
			vim.keymap.set("n", "<Esc>", function()
				if vim.api.nvim_win_is_valid(winnr) then
					vim.api.nvim_win_close(winnr, true)
				end
			end, { buffer = bufnr, desc = "Close preview" })
		end,
	},
}
