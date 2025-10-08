return {
  -- add gruvbox
  { "UtkarshVerma/molokai.nvim", lazy = true, priority = 1000, opts = ... },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
    },
  },
  { "ellisonleao/gruvbox.nvim", config = true, lazy = true, priority = 1000, opts = ... },
  {
    "polirritmico/monokai-nightasty.nvim",
    lazy = true,
    priority = 1000,
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "molokai",
    },
  },
}
