-- Navigation and fuzzy finding plugins
return {
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e",  "<cmd>Neotree toggle<cr>",            desc = "Toggle file explorer" },
      { "<leader>ge", "<cmd>Neotree git_status toggle<cr>", desc = "Toggle git status" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          position = "float",
          popup = {
            size = {
              height = "60%",
              width = "60%",
            },
          },
          mappings = {
            ["/"] = "none",
          },
        },
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
        git_status = {
          window = {
            mappings = {
              ["s"] = "git_add_file",
              ["u"] = "git_unstage_file",
              ["-"] = "git_toggle_file_stage",
              ["c"] = "none",
              ["cc"] = "git_commit",
              ["gg"] = "none",
            },
          },
        },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Find help" },
      { "<leader>fc", "<cmd>Telescope commands<cr>",   desc = "Find commands" },
      { "<leader>ft", "<cmd>Telescope treesitter<cr>",   desc = "Find treesitters" },
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>",   desc = "Current buffer fuzzy find" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      telescope.setup({
        defaults = {
          preview = {
            treesitter = false,
          },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              width = 0.9,
              preview_cutoff = 120,
            },
          },
        },
        pickers = {
          find_files = {
            mappings = {
              i = {
                ["<C-d>"] = function(prompt_bufnr) -- Diffsplit in find_files
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  vim.cmd("vert diffsplit " .. selection.value)
                end,
              },
            },
          },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- Motion plugin
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        -- Use native `f`, `F`, `t`, `T` motions
        char = { enabled = false },
        search = { enabled = true },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search"
      },
    },
  },

  -- Code outline/symbols
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    keys = {
      { "<leader>t", "<cmd>AerialToggle!<CR>", desc = "Toggle aerial" },
    },
  },

  -- Seamless navigation between tmux panes and vim splits
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
    -- Fix for terminal navigation in nvim terminals (including claudecode/opencode)
    config = function()
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><cmd>TmuxNavigateLeft<cr>]], { silent = true })
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><cmd>TmuxNavigateDown<cr>]], { silent = true })
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><cmd>TmuxNavigateUp<cr>]], { silent = true })
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><cmd>TmuxNavigateRight<cr>]], { silent = true })
    end
  },

  -- Edit the filesystem like a buffer
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = false,
      float = {
        padding = 2,
        max_width = 0.6,
        max_height = 0.6,
        border = "single",
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      { "<leader>z", function() require("oil").toggle_float() end },
    },
  },
}
