# Neovim Configuration

A personal Neovim setup with [lazy.nvim](https://github.com/folke/lazy.nvim) being the package manager.

## Requirements

- Neovim 0.12+.
- `git`, a C compiler, and `make` (for `telescope-fzf-native`).
- `node`/`npm` for `markdown-preview.nvim`.
- A Nerd Font for icons.

## Layout

```
init.lua              Bootstraps lazy.nvim, loads core modules and LSP
lua/config/           Core editor config
  options.lua         Options, leader keys (leader and localleader are Space)
  keymaps.lua         Global key mappings
  lazy.lua            lazy.nvim setup
  lsp.lua             Diagnostics, LspAttach keymaps, vim.lsp.enable list
  autocmds.lua        Autocommands
  colorscheme.lua     Colorscheme activation
lua/plugins/          One spec (or group) per file
lua/utils.lua         Shared helpers (icon/sign table)
after/lsp/<name>.lua  Per-server LSP settings, merged with lspconfig defaults
```

## Plugins

### Core and library

| Plugin                        | Purpose                                    |
| ----------------------------- | ------------------------------------------ |
| `nvim-lua/plenary.nvim`       | Lua utility functions used by many plugins |
| `nvim-tree/nvim-web-devicons` | File type icons                            |

### Appearance

| Plugin                                | Purpose                                     |
| ------------------------------------- | ------------------------------------------- |
| `catppuccin/nvim`                     | Colorscheme (lazy.nvim install colorscheme) |
| `goolord/alpha-nvim`                  | Start screen / dashboard (startify theme)   |
| `nvim-lualine/lualine.nvim`           | Statusline, with `lualine-lsp-progress`     |
| `lukas-reineke/indent-blankline.nvim` | Indentation guides                          |

### Navigation & Windows

| Plugin                               | Purpose                                                              |
| ------------------------------------ | -------------------------------------------------------------------- |
| `christoomey/vim-tmux-navigator`     | Seamless tmux and split navigation                                   |
| `szw/vim-maximizer`                  | Toggle maximization of the current split                             |
| `nvim-tree/nvim-tree.lua`            | File explorer                                                        |
| `nvim-telescope/telescope.nvim`      | Fuzzy finder, with `fzf-native` and `menufacture`                    |
| `chrisgrieser/nvim-early-retirement` | Auto-close stale buffers                                             |
| `stevearc/quicker.nvim`              | Improved quickfix list (`<leader>q` toggle, `>`/`<` expand/collapse) |

### Editing

| Plugin                      | Purpose                                              |
| --------------------------- | ---------------------------------------------------- |
| `windwp/nvim-autopairs`     | Auto-insert matching brackets and quotes             |
| `kylechui/nvim-surround`    | Add, change, and delete surrounding pairs            |
| `chrisgrieser/nvim-origami` | Folding, with auto-fold for comments/imports/regions |

### LSP & Completion

| Plugin                           | Purpose                                                  |
| -------------------------------- | -------------------------------------------------------- |
| `neovim/nvim-lspconfig`          | Server defaults consumed by the native LSP client        |
| `mason-org/mason.nvim`           | LSP/tool installer                                       |
| `mason-org/mason-lspconfig.nvim` | Install-only bridge between Mason and lspconfig          |
| `saghen/blink.cmp`               | Completion engine and signature help                     |
| `onsails/lspkind.nvim`           | Completion menu icons                                    |
| `rmagatti/goto-preview`          | Floating peek for definitions/references/implementations |

Servers are installed by Mason but enabled explicitly in `lua/config/lsp.lua` via `vim.lsp.enable`; per-server overrides live in `after/lsp/<name>.lua`.
`rust_analyzer` is intentionally not enabled there since `rustaceanvim` bundles it.

### Snippets

| Plugin                         | Purpose            |
| ------------------------------ | ------------------ |
| `L3MON4D3/LuaSnip`             | Snippet engine     |
| `rafamadriz/friendly-snippets` | Snippet collection |

### Syntax & Formatting

| Plugin                            | Purpose                                                          |
| --------------------------------- | ---------------------------------------------------------------- |
| `nvim-treesitter/nvim-treesitter` | Treesitter highlighting (`main` branch); parser list in the spec |
| `stevearc/conform.nvim`           | Format on save with per-filetype formatters                      |

### Git

| Plugin                    | Purpose                                 |
| ------------------------- | --------------------------------------- |
| `lewis6991/gitsigns.nvim` | Sign-column git status and hunk actions |
| `sindrets/diffview.nvim`  | Diff and merge review interface         |

### Language & Filetype Specific

| Plugin                         | Purpose                                              |
| ------------------------------ | ---------------------------------------------------- |
| `mrcjkb/rustaceanvim`          | Rust tooling (owns `rust_analyzer`)                  |
| `lervag/vimtex`                | LaTeX editing and compilation (Skim viewer, latexmk) |
| `darfink/vim-plist`            | Read/write binary and XML plist files                |
| `iamcco/markdown-preview.nvim` | Browser-based Markdown preview                       |
