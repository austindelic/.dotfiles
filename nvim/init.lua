-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.neovide_opacity = 1
vim.g.transparency = 1

vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h13"
vim.g.neovide_cursor_animation_length = 0.04
vim.g.neovide_cursor_trail_size = 0.25
vim.g.neovide_window_blurred = true
vim.env.PATH = vim.fn.expand("~/.asdf/shims") .. ":" .. vim.env.PATH
