-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.neovide_opacity = 1
vim.g.transparency = 1

vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h13"
-- vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h18"
vim.g.neovide_cursor_animation_length = 0.04
vim.g.neovide_cursor_trail_size = 0.25
vim.g.neovide_window_blurred = true
vim.env.PATH = vim.fn.expand("~/.asdf/shims") .. ":" .. vim.env.PATH
vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
