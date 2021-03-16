-- aedile.lua
-- a plugin that open REPL in a split window according to current buffer filetype
if vim.version().minor < 5 then
  vim.api.nvim_error_event(0, "Neovim version < 0.5.0: deactivate all Aedile's functions")
  return
end

local TRUE = 1

local ft_table = {
  --  ft      =  repl
      lua     = 'lua',
      lisp    = 'sbcl',
      python  = 'python',
}

local toggle = false
local term_win_id
local term_buf_id

local function toggle_repl()
  local repl = ft_table[vim.bo.filetype]

  if vim.fn.bufexists(term_buf_id) == TRUE then
    if toggle == false then
      vim.cmd('vertical sbuffer '..term_buf_id)
      term_win_id = vim.api.nvim_get_current_win()
      toggle = true
    else
      vim.api.nvim_win_close(term_win_id, false)
      toggle = false
    end
  -- handle case that buffer doesn't exists
  -- (first time usage or buffer have closed)
  else
    vim.cmd('vsplit | terminal '..repl)
    term_win_id = vim.api.nvim_get_current_win()
    term_buf_id = vim.api.nvim_win_get_buf(term_win_id)
    toggle = true
  end

end

local function modify_repl(table)
  for key, value in pairs(table) do
    ft_table[key] = value
  end
end

return {
  toggle_repl = toggle_repl,
  modify_repl = modify_repl,
}
