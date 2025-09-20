vim.cmd("colorscheme nightfly")

local status, _ = pcall(vim.cmd, "colorscheme nightfly")
if not status then
  print("Colorscheme not found!")
  return
end

-- Diagnostics highlights
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "Red", fg = "#ff0000" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = "Yellow", fg = "#ffaa00" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { undercurl = true, sp = "Blue", fg = "#00aaff" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { undercurl = true, sp = "Cyan", fg = "#00ffff" })
