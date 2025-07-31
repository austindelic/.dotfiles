return {
  -- add gruvbox
  { "UtkarshVerma/molokai.nvim" },
  { "folke/tokyonight.nvim" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "molokai",
    },
  },
}
