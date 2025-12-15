return {
  -- 1. MASON (The Installer)
  {
    "williamboman/mason.nvim",
    priority = 1000,
    config = function()
      require("mason").setup()
    end,
  },

  -- 2. MASON LSP CONFIG (The Bridge)
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        -- We define the list here to ensure they are installed
        ensure_installed = {
          "lua_ls", "gopls", "ts_ls", "html", "cssls", "clangd", "jdtls",
        },
        automatic_installation = true,
      })
    end,
  },

  -- 3. LSP CONFIG (The Setup)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Common Keymaps
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      end

      -- THE FIX: We define the list manually and loop through it.
      -- This bypasses 'setup_handlers' entirely so it CANNOT crash.
      local servers = { "lua_ls", "gopls", "ts_ls", "html", "cssls", "clangd" }

      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end
    end,
  },

  -- 4. JAVA CONFIG (Keep this! It is working in your screenshots)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
      local path_to_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
      local lombok_path = jdtls_path .. "/lombok.jar"

      if vim.fn.empty(path_to_jar) == 1 then return end

      local config_dir = "config_linux"
      if vim.fn.has('mac') == 1 then config_dir = "config_mac" end
      if vim.fn.has('win32') == 1 then config_dir = "config_win" end

      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if root_dir == "" then return end
      
      local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
      local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

      require("jdtls").start_or_attach({
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-javaagent:" .. lombok_path,
          "-jar", path_to_jar,
          "-configuration", jdtls_path .. "/" .. config_dir,
          "-data", workspace_dir,
        },
        root_dir = root_dir,
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = { updateBuildConfiguration = "interactive" },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
          },
        },
        on_attach = function(client, bufnr)
           local opts = { buffer = bufnr, noremap = true, silent = true }
           vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
           vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
           vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        end
      })
    end,
  },
}
