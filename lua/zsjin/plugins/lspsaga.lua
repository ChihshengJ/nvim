return {
  "glepnir/lspsaga.nvim",
  branch = "main",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-treesitter/nvim-treesitter" },
  },
  config = function()
    -- import lspsaga safely
    local saga_status, saga = pcall(require, "lspsaga")
    if not saga_status then
      return
    end

    saga.setup({
      -- keybinds for navigation in lspsaga window
      scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
      -- use enter to open file with definition preview
      definition = {
        edit = "<CR>",
      },
      diagnostic = {
        show_code_action = true,
      },
      ui = {
        colors = {
          normal_bg = "#022746",
        },
        devicons = true,
        title = true,
        code_action = "💡",
      },
    })
end
} -- enhanced lsp uis

