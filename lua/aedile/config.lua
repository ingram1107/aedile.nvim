--[[
    aedile.lua   Nvim plugin that open REPL in a split window according to buf ft
    Copyright (C) 2021  Little Clover 
    This program is free software: you can redistribute it and/or modify 
    it under the terms of the GNU General Public License as published by 
    the Free Software Foundation, either version 3 of the License, or 
    (at your option) any later version. 

    This program is distributed in the hope that it will be useful, 
    but WITHOUT ANY WARRANTY; without even the implied warranty of 
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
    GNU General Public License for more details. 

    You should have received a copy of the GNU General Public License 
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]
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
