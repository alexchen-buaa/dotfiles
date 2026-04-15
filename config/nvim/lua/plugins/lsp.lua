-- LSP, Completion, and Treesitter plugins
return {
  -- Mason: Package manager for LSP servers, DAP, linters, formatters
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-lspconfig: Bridge between mason and nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      auto_install = true,
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "ruff",
          "bashls",
          "lua_ls",
          "texlab",
        },
        automatic_installation = true,
      })
    end,
  },

  -- nvim-lspconfig: LSP server configurations
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- LSP Keymaps (set up via autocmd when LSP attaches)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local opts = { noremap = true, silent = true, buffer = bufnr }

          -- Keymaps
          -- Overrides of Vim builtins (only active when LSP attaches):
          --   gD, gd: tag-based declaration/definition
          --   K:      keywordprg / man lookup
          --   gs:     :sleep (useless)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
          -- Neovim builtins (no need to set):
          --   grr: references
          --   grn: rename
          --   gra: code action
          --   gri: implementation
          -- No Neovim builtin for these:
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, opts)
        end,
      })

      -- Enable language servers (uses nvim-lspconfig configs automatically)
      vim.lsp.enable({ 'pyright', 'ruff', 'bashls', 'lua_ls', 'texlab' })

      vim.lsp.config('pyright', {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              ignore = { '*' }
            },
          },
        },
      })

      local on_attach_ruff = function(client, _)
        if client.name == "ruff" then
          -- Disable ruff hover in favor of pyright
          client.server_capabilities.hoverProvider = false
        end
      end

      vim.lsp.config('ruff', {
        on_attach = on_attach_ruff,
      })

      -- Customize lua_ls settings
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      vim.lsp.config('texlab', {
        settings = {
          texlab = {
            diagnostics = {
              ignoredPatterns = { "Overfull", "Underfull" },
            },
          },
        },
      })
    end,
  },
}
