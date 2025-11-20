local opt = vim.opt -- for conciseness
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

-- line numbers
opt.relativenumber = false
opt.number = true

-- tabs & indentations
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

--search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- spelling
opt.spell = true
opt.spelllang = "en_us"
opt.spelloptions = "camel"

-- split windows
opt.splitright = true
opt.splitbelow = true

-- folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 1
opt.foldnestmax = 10

opt.iskeyword:append("-")

-- set maximum amount of completion items to 10
opt.pumheight = 10

-- complete even if there's only one item; do not autoselect item
opt.completeopt = "menu,menuone,noselect"

-- set minimal number of screen lines above and below cursor
opt.scrolloff = 1000

-- disable providers
g.python_host_skip_check = 0
g.loaded_python3_provider = 0
g.loaded_node_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

-- disable built-in plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	-- "matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

-- override filetype
-- vim.filetype.add({
-- 	-- extension = {
-- 	--     foo = "fooscript",
-- 	-- },
-- 	filename = {
-- 		["Podfile"] = "ruby",
-- 	},
-- 	pattern = {
-- 		[".*git/config"] = "gitconfig",
-- 		[".*env.*"] = "sh",
-- 	},
-- })

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:,diff:/]]
