local filetype_table = {
-- filetype = repl
  lua       = 'lua',
  lisp      = 'sbcl',
  python    = 'python',
}
local split_method = ''
local scrollup     = '<M-u>'
local scrolldown   = '<M-d>'

local function get_repl(filetype)
  return filetype_table[filetype]
end

local function get_split_method()
  return split_method
end

local function get_scrollup()
  return scrollup
end

local function get_scrolldown()
  return scrolldown
end

local function modify_repl(ft_tbl)
  for key, value in pairs(ft_tbl) do
    filetype_table[key] = value
  end
end

local function modify_method(option)
  split_method = option..' '
  if option ~= 'vertical' then
    vim.api.nvim_err_writeln("Fatal: current split method only support 'vertical'")
    split_method = ''
  end
end

local function modify_mappings(custom_scrollup, custom_scrolldown)
  if custom_scrollup == '' or custom_scrollup == nil or custom_scrolldown == '' or custom_scrolldown == nil then
    vim.api.nvim_echo({{'Disable mapping for Aedile', 'Normal'}},  false, {})
    return
  end

  scrollup = custom_scrollup
  scrolldown = custom_scrolldown
end

return {
  get_repl = get_repl,
  get_split_method = get_split_method,
  get_scrollup = get_scrollup,
  get_scrolldown = get_scrolldown,
  modify_repl = modify_repl,
  modify_method = modify_method,
  modify_mappings = modify_mappings,
}
