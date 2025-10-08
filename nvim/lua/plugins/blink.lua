return {
  "saghen/blink.cmp",
  lazy = true,
  opts = {
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        treesitter_highlighting = true,
        window = { border = "rounded" },
      },
      list = {
        selection = {
          auto_insert = false,
        },
      },
      menu = {
        border = "rounded",
      },
    },
    keymap = {
      preset = "super-tab",
    },
  },
}
