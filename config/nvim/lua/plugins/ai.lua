-- AI Assistant plugins
return {
  -- Snacks.nvim (dependency for AI plugins)
  {
    "folke/snacks.nvim",
    opts = {
      input = {},
      picker = {},
      terminal = {},
    },
  },

  -- Claude Code Neovim IDE Extension
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal_cmd = "~/.claude/local/claude", -- Point to local installation
      terminal = {
        provider = "auto",
        split_width_percentage = 0.45,
      },
      focus_after_send = true,
      diff_opts = {
        vertical_split = false,
        keep_terminal_focus = true,
        open_in_current_tab = false,
      },
    },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "+ai" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  -- OpenCode AI Assistant
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {},  -- Configuration if needed
    keys = {
      { "<leader>o", nil, desc = "+opencode" },
      { "<leader>oo", function() require("opencode").ask("@this: ", { submit = true }) end, mode = { "n", "x" }, desc = "Ask opencode" },
      { "<leader>os", function() require("opencode").select() end, mode = { "n", "x" }, desc = "Select opencode action" },
      { "<leader>ot", function() require("opencode").toggle() end, mode = { "n", "t" }, desc = "Toggle opencode" },
      { "go", function() return require("opencode").operator("@this ") end, mode = { "n", "x" }, expr = true, desc = "Add range to opencode" },
      { "goo", function() return require("opencode").operator("@this ") .. "_" end, expr = true, desc = "Add line to opencode" },
      { "<S-C-u>", function() require("opencode").command("session.half.page.up") end, desc = "opencode half page up" },
      { "<S-C-d>", function() require("opencode").command("session.half.page.down") end, desc = "opencode half page down" },
    },
    config = function()
      -- Required for opts.events.reload
      vim.o.autoread = true
    end,
  },
}
