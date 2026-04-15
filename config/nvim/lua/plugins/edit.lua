-- Editing plugins
return {
  -- Comment plugin
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Surround plugin
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },

  -- Vim repeat (for repeating plugin commands)
  "tpope/vim-repeat",

  -- LaTeX support
  {
    "lervag/vimtex",
    ft = { "tex", "latex" },
    -- vimtex uses VimScript globals, not require() setup
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_log_ignore = { "Underfull", "Overfull", "specifier changed" }
      -- Quickfix list off by default (toggle with copen/cclose)
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_quickfix_ignore_filters = { "Underfull", "Overfull", "specifier changed" }
      -- Disable delimiter matching for better performance
      vim.g.vimtex_matchparen_enabled = 0
    end,
  },

  -- Multi cursor plugin
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end)
      set({ "n", "x" }, "<leader>m", function() mc.matchSkipCursor(1) end)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end
  },

  -- Autopairing
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local cond = require("nvim-autopairs.conds")
      local npairs = require("nvim-autopairs")
      npairs.setup()

      local function is_tex_filetype()
        local ft = vim.bo.filetype
        return ft == "tex" or ft == "plaintex" or ft == "latex"
      end

      local function in_tex_math()
        return is_tex_filetype()
          and vim.fn.exists("*vimtex#syntax#in_mathzone") == 1
          and vim.fn["vimtex#syntax#in_mathzone"]() == 1
      end

      -- Keep quote pairing in TeX text, but let LuaSnip own `"` inside math.
      local rules = npairs.get_rules('"')
      if rules then
        for _, rule in ipairs(rules) do
          rule:with_pair(function()
            if in_tex_math() then
              return false
            end
          end, 1)
        end
      end

      -- Keep default bracket pairing, except after `lr` so TeX snippets like
      -- `lr(`, `lr[` and `lr{` can still expand naturally.
      for _, char in ipairs({ "(", "[", "{" }) do
        local bracket_rules = npairs.get_rules(char)
        if bracket_rules then
          for _, rule in ipairs(bracket_rules) do
            rule:with_pair(function(opts)
              if is_tex_filetype() then
                return cond.not_before_regex("lr$", -1)(opts)
              end
            end, 1)
          end
        end
      end
    end,
  },

  -- Completion engine
  {
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false,
    opts = {
      keymap = {
        preset = "default",
      },
      snippets = {
        preset = "luasnip",
      },
      appearance = {
        nerd_font_variant = "mono",
      },
    },
  },

  -- Improve lua completion
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {},
    },
  },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")

      ls.config.set_config({
        enable_autosnippets = true,
        updateevents = "TextChanged,TextChangedI",
      })

      require("luasnip.loaders.from_vscode").lazy_load()

      local tex_snippets = require("snippets.tex")
      ls.add_snippets("tex", tex_snippets.regular, { key = "local_tex_regular" })
      ls.add_snippets("tex", tex_snippets.auto, { type = "autosnippets", key = "local_tex_auto" })
      ls.filetype_extend("plaintex", { "tex" })

      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { desc = "LuaSnip next choice", silent = true })
    end,
  },
}
