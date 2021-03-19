-- aedile.lua
-- a plugin that open REPL in a split window according to current buffer filetype
if vim.version().minor < 5 then
  vim.api.nvim_err_write("Neovim version < 0.5.0: deactivate all Aedile's functions")
  return
end

local TRUE = 1

local ft_table = {
  --  ft      =  repl
      lua     = 'lua',
      lisp    = 'sbcl',
      python  = 'python',
}

local split_method = ''

local toggle = false
local term_win_id
local term_buf_id

local function toggle_repl()
  local repl = ft_table[vim.bo.filetype]

  if vim.fn.bufexists(term_buf_id) == TRUE then
    if toggle == false then
      vim.cmd(split_method..'sbuffer '..term_buf_id)
      term_win_id = vim.api.nvim_get_current_win()
      toggle = true
    else
      if vim.api.nvim_win_is_valid(term_win_id) == true then
        vim.api.nvim_win_close(term_win_id, false)
        toggle = false
      else
        vim.cmd(split_method..'sbuffer '..term_buf_id)
        term_win_id = vim.api.nvim_get_current_win()
      end
    end
  -- handle case that buffer doesn't exists
  -- (first time usage or buffer have closed)
  else
    vim.cmd(split_method..'split | terminal '..repl)
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

local function modify_method(option)
  split_method = option..' '
  if option ~= 'vertical' then
    vim.api.nvim_err_write("Fatal: current split method only support 'vertical'")
    split_method = ''
  end
end

return {
  toggle_repl = toggle_repl,
  modify_repl = modify_repl,
  split_method = modify_method,
}
