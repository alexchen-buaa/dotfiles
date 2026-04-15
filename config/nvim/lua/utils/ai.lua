-- AI workflow utilities
local M = {}

-- Copy an @file mention to the system clipboard.
-- In visual mode, appends :L1-L2 (or :L1 for a single line). In normal mode, filename only.
function M.mention()
  local path = vim.fn.expand('%:.')
  if path == '' then
    vim.notify('No file in current buffer', vim.log.levels.WARN)
    return
  end
  local result
  if vim.fn.mode():match('[vV\22]') then
    local s = math.min(vim.fn.getpos('v')[2], vim.fn.getpos('.')[2])
    local e = math.max(vim.fn.getpos('v')[2], vim.fn.getpos('.')[2])
    local range = s == e and ('L' .. s) or ('L' .. s .. '-L' .. e)
    result = '@' .. path .. ':' .. range
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
  else
    result = '@' .. path
  end
  vim.fn.setreg('+', result)
  vim.notify('Copied: ' .. result)
end

return M
