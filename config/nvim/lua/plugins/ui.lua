-- UI and Appearance plugins
return {
  -- Treesitter for highlighting, folding and indentation
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- Does NOT support lazy-loading
    build = ":TSUpdate",
    config = function()
      -- Autocmds for reliable setting (over ftplugins)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python" },
        callback = function()
          -- vim.treesitter.start()
          vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "lua" },
        callback = function()
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sh", "bash" },
        callback = function()
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex" },
        callback = function()
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
          vim.opt_local.wrap = true
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "json", "jsonc" },
        callback = function()
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
        end,
      })
    end
  },

  -- Gruvbox colorscheme - Default contrast (medium)
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        -- Using default contrast (no contrast setting)
        -- Options are: "hard" (very dark), "soft" (lighter), or default (medium)
        transparent_mode = false,
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          section_separators = { left = "", right = "" },
          component_separators = { left = "|", right = "|" },
        },
      })
    end,
  },

  -- Show current code context (function/class) at top of screen
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      max_lines = 1,
      trim_scope = "inner",
    },
  },

  -- Notifications and LSP progress messages
  {
    "j-hui/fidget.nvim",
    opts = {
      --options
    },
  },
}
