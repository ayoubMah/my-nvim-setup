return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        lang = "golang",

        storage = {
            home = vim.fn.expand("~/leetcode_problems"),
            cache = vim.fn.stdpath("cache") .. "/leetcode",
        },

        -- ⬇️ ADD THIS BLOCK ⬇️
        plugins = {
            non_standalone = true,
        },
        -- ⬆️ END ADDITION ⬆️

        description = {
            position = "left",
            width = "40%",
            show_stats = true,
        },
        
        logging = true,
    },
}
