return {
    -- add gruvbox
    -- {
    --     "UtkarshVerma/molokai.nvim",
    --     lazy = false,
    --     priority = 1000,
    -- },
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = {
            style = "storm",
        },
    },
    { "ellisonleao/gruvbox.nvim", lazy = true, priority = 1000, opts = ... },
    {
        "polirritmico/monokai-nightasty.nvim",
        lazy = false,
        priority = 1000,
    },

    {
        "khoido2003/monokai-v2.nvim",
        priority = 1000,
        opts = {
            transparent_background = true,
            filter = "classic"
        }
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "monokai-v2",
        },
    },
}
