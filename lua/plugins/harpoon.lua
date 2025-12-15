return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup()
        
        -- Keymaps (The V2 way)
        
        -- 1. ADD FILE (Mark it)
        -- Press Space + a to add the current file to the list
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

        -- 2. OPEN MENU (The Quick Menu)
        -- Press Ctrl + e to see your marked files
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        -- 3. NAVIGATE (Jump to file 1, 2, 3, 4)
        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

        -- 4. CYCLE (Next/Prev)
        vim.keymap.set("n", "<leader>p", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<leader>n", function() harpoon:list():next() end)
    end,
}
