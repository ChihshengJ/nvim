-- Open the quickfix entry under the cursor in a split.
-- quicker renders one buffer line per quickfix item (context lines included),
-- so the cursor's line number indexes directly into getqflist().
local function open_in_split(split_cmd)
	return function()
		local item = vim.fn.getqflist()[vim.fn.line(".")]
		if not item or item.bufnr == 0 then
			return
		end

		-- Land the split in the window the list was opened from, so we split
		-- the main editing area instead of the quickfix window itself.
		local prev = vim.fn.win_getid(vim.fn.winnr("#"))
		if prev ~= 0 and prev ~= vim.api.nvim_get_current_win() then
			vim.api.nvim_set_current_win(prev)
		end

		vim.cmd(split_cmd)
		vim.api.nvim_win_set_buf(0, item.bufnr)
		pcall(vim.api.nvim_win_set_cursor, 0, { item.lnum, math.max(item.col - 1, 0) })
		vim.cmd("normal! zz")
	end
end

return {
	"stevearc/quicker.nvim",
	event = "FileType qf",
	keys = {
		{
			"<leader>q",
			function()
				require("quicker").toggle()
			end,
			desc = "Toggle quickfix list",
		},
	},
	opts = {
		-- Buffer-local mappings, active inside the quickfix window.
		keys = {
			{
				">",
				function()
					require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
				end,
				desc = "Expand quickfix context",
			},
			{
				"<",
				function()
					require("quicker").collapse()
				end,
				desc = "Collapse quickfix context",
			},
			{
				"<C-v>",
				open_in_split("vsplit"),
				desc = "Open entry in vertical split",
			},
			{
				"<C-x>",
				open_in_split("split"),
				desc = "Open entry in horizontal split",
			},
		},
	},
}
