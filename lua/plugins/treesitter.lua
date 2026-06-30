return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = "BufReadPost",
  cmd = {
    "TSInstall",
    "TSUpdate",
    "TSUninstall",
  },
  config = function()
    -- Parsers to keep installed (main branch has no auto-install; this
    -- replaces the old master-branch `ensure_installed`). install() is async
    -- and only fetches parsers that are missing or out of date.
    require("nvim-treesitter").install({
      "bash",
      "c",
      "cpp",
      "css",
      "html",
      "javascript",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline", -- required for LSP hover code blocks
      "python",
      "query",
      "rust",
      "swift",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    })

    -- enable highlighting for every filetype that has a parser
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    -- activate for already-open buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        pcall(vim.treesitter.start, buf)
      end
    end
  end,
}
