-- Ensure VimTeX loads correctly with necessary settings
vim.cmd([[
  filetype plugin indent on
  syntax enable
]])

-- Configure VimTeX options
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_quick_fix_mode = 0
vim.g.vimtex_syntax_enabled = 0

vim.g.vimtex_log_ignore = {
	"Underfull",
	"Overfull",
	"specifier changed to",
	"Token not allowed in a PDF string",
}

vim.g.vimtex_context_pdf_viewer = "okular"

-- Set the compiler method (default is latexmk, this changes it to latexrun)
vim.g.vimtex_compiler_method = "latexmk"
vim.g.tex_flavor = "latex"

-- Set the local leader key for VimTeX mappings (default is '\')
vim.g.maplocalleader = ","
