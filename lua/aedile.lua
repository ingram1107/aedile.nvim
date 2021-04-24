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
if vim.version().minor < 5 then
  vim.api.nvim_err_writeln("Neovim version < 0.5.0: deactivate all Aedile's functions")
  return
end

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
local term_job_id
local repl

local dir

if vim.g.splitbelow == true or vim.g.splitright == true then
  dir = "botright "
else
  dir = "topleft "
end

local function toggle_repl()
  repl = ft_table[vim.bo.filetype]

  if term_buf_id ~= nil and vim.api.nvim_buf_is_valid(term_buf_id) == true then
    if toggle == false then
      vim.cmd(dir..split_method..'sbuffer '..term_buf_id)
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
    vim.cmd(dir..split_method..'split | terminal '..repl)
    term_win_id = vim.api.nvim_get_current_win()
    term_buf_id = vim.api.nvim_win_get_buf(term_win_id)
    term_job_id = vim.api.nvim_buf_get_var(term_buf_id, 'terminal_job_id')
    print("terminal jobid: "..term_job_id)
    toggle = true
  end

end

local function terminate_repl()
  vim.fn.jobstop(term_job_id)
  vim.api.nvim_buf_delete(term_buf_id, { force = true })
  vim.api.nvim_echo({{'REPL `'..repl..'` (jobpid: '..term_job_id..') has been terminated', 'Normal'}}, false, {})
end

local function modify_repl(table)
  for key, value in pairs(table) do
    ft_table[key] = value
  end
end

local function modify_method(option)
  split_method = option..' '
  if option ~= 'vertical' then
    vim.api.nvim_err_writeln("Fatal: current split method only support 'vertical'")
    split_method = ''
  end
end

return {
  toggle_repl = toggle_repl,
  terminate_repl = terminate_repl,
  modify_repl = modify_repl,
  split_method = modify_method,
}
