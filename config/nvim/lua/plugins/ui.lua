-- UI and Appearance plugins
return {
  -- Treesitter for highlighting, folding and indentation
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- Does NOT support lazy-loading
    build = ":TSUpdate",
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
