-- aedile.lua
--
--    a plugin that open REPL in a split window according to current buffer filetype

local ft_table = {
  --  ft      =  repl
      lua     = 'lua',
      lisp    = 'sbcl',
      python  = 'python',
}

local function open_repl()
  local repl = ft_table[vim.bo.filetype]
  vim.cmd('vs | term '..repl)
end

local function modify_repl(table)
  for key, value in pairs(table) do
    ft_table[key] = value
  end
end

return {
  open_repl = open_repl,
  modify_repl = modify_repl,
}
