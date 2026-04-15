-- Floating window utilities
local M = {}

-- Generic floating window opener with hardcoded defaults
function M.open_floating(buf)
  return vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.6),
    height = math.floor(vim.o.lines * 0.6),
    row = math.floor(vim.o.lines * 0.2),
    col = math.floor(vim.o.columns * 0.2),
    style = "minimal",
    border = "single",
  })
end

-- Floating terminal with state management
local term_buf = nil

function M.toggle_terminal()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    local wins = vim.fn.win_findbuf(term_buf)
    if #wins > 0 then
      vim.api.nvim_win_close(wins[1], true)
    else
      M.open_floating(term_buf)
    end
  else
    term_buf = vim.api.nvim_create_buf(false, true)
    M.open_floating(term_buf)
    vim.cmd("term")
    vim.cmd("startinsert")
    -- Enter insert mode when focusing this terminal
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = term_buf,
      callback = function()
        vim.cmd("startinsert")
      end,
    })
  end
end

return M
