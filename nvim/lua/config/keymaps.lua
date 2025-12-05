-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap_set = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap_set("n", "<leader>h", Snacks.dashboard.open, { desc = "Open mini starter" })

-- -------------------------------------
--  SYSTEM CLIPBOARD for yanking/pasting
-- -------------------------------------
keymap_set({ "n", "v" }, "y", '"+y', opts)
keymap_set("n", "p", '"+p', opts)
keymap_set("n", "P", '"+P', opts)

-- -------------------------------------
--  DELETE / CHANGE go to register a
--  (instead of overwriting system clipboard)
-- -------------------------------------
keymap_set({ "n", "v" }, "d", '"ad', opts)
keymap_set({ "n", "v" }, "c", '"ac', opts)
keymap_set({ "n", "v" }, "x", '"ax', opts)
keymap_set({ "n", "v" }, "s", '"as', opts)

-- Optional: capital versions too
keymap_set("n", "D", '"aD', opts)
keymap_set("n", "C", '"aC', opts)
keymap_set("n", "S", '"aS', opts)
