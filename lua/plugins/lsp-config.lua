return {
  {
    "williamboman/mason.nvim",
    -- Make sure mason is set up before the other plugins
    -- by giving it a lower priority.
    lazy = false,
    priority = 1000,
    config = function()
      require("mason").setup()
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "mfussenegger/nvim-jdtls",
    },
    lazy = false,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local servers = {
        "lua_ls",
        "gopls",
        "ts_ls",
        "html",
        "cssls",
        "clangd",
      }
      -- This setup is for all language servers EXCEPT jdtls
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
      end

      -- Loop through all servers and attach them
      for _, server_name in ipairs(servers) do
        lspconfig[server_name].setup({ on_attach = on_attach })
      end
    end,
  },

  -- THIS IS THE NEW, CORRECTED JAVA CONFIGURATION
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      -- This function will find the root of your Java project
      local root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})
      if root_dir == nil then
        return
      end

      -- This is the crucial part that sets the workspace directory
      local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

      -- Find the location of the jdtls installation
      local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

      -- The command to start the server
      local cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', jdtls_path .. '/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar',
        '-configuration', jdtls_path .. '/config_linux',
        '-data', workspace_dir -- Use the unique workspace directory
      }

      require('jdtls').start_or_attach({
        cmd = cmd,
        root_dir = root_dir,
      })
    end,
  },
}
