return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  cmd = {
    "TSInstall",
    "TSUpdate",
    "TSInstallInfo",
    "TSUninstall",
  },
  config = function()
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
