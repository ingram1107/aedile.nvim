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
  vim.api.nvim_err_writeln("fatal: Neovim version < 0.5.0: deactivate all Aedile's functions")
  return
end

local config = require('aedile.config')

local toggle = false
local term_win_id
local term_buf_id
local term_job_id
local working_buf_id
local repl
local dir = (function()
  if vim.g.splitbelow == true or vim.g.splitright == true then
    return "botright "
  else
    return "topleft "
  end
end)()

local function mapping_update()
  if term_win_id == nil and vim.api.nvim_win_is_valid(term_win_id) == false or 
     term_buf_id == nil and vim.api.nvim_buf_is_valid(term_buf_id) == false then

    vim.api.nvim_buf_del_keymap(working_buf_id, 'n', config.get_scrollup())
    vim.api.nvim_buf_del_keymap(working_buf_id, 'n', config.get_scrolldown())
    return
  end

  vim.api.nvim_buf_set_keymap(working_buf_id, 'n', config.get_scrollup(), '<cmd>call win_execute('..term_win_id..',"normal! \\<c-u>")<cr>', {})
  vim.api.nvim_buf_set_keymap(working_buf_id, 'n', config.get_scrolldown(), '<cmd>call win_execute('..term_win_id..',"normal! \\<c-d>")<cr>', {})
end

local function toggle_repl()
  local filetype = vim.bo.filetype
  repl = config.get_repl(filetype)

  if repl == nil and toggle == false then
    vim.api.nvim_err_writeln("fatal: REPL doesn't set for `"..filetype.."` files")
    return
  elseif repl == '' then
    vim.api.nvim_err_writeln("fatal: no REPL have been specified for `"..filetype.."`, check for empty string")
    return
  end

  if term_buf_id ~= nil and vim.api.nvim_buf_is_valid(term_buf_id) == true then
    if toggle == false then
      vim.api.nvim_exec(dir..config.get_split_method()..'sbuffer '..term_buf_id, false)
      term_win_id = vim.api.nvim_get_current_win()
      mapping_update()
      toggle = true
    else
      if vim.api.nvim_win_is_valid(term_win_id) == true then
        vim.api.nvim_win_close(term_win_id, false)
        mapping_update()
        toggle = false
      else
        vim.api.nvim_exec(config.get_split_method()..'sbuffer '..term_buf_id, false)
        term_win_id = vim.api.nvim_get_current_win()
        mapping_update()
      end
    end
  -- handle case that buffer doesn't exists
  -- (first time usage or buffer have closed)
  else
    working_buf_id = vim.api.nvim_win_get_buf(0)
    vim.api.nvim_exec(dir..config.get_split_method()..'split | terminal '..repl, false)
    term_win_id = vim.api.nvim_get_current_win()
    term_buf_id = vim.api.nvim_win_get_buf(term_win_id)
    term_job_id = vim.api.nvim_buf_get_var(term_buf_id, 'terminal_job_id')
    mapping_update()
    vim.api.nvim_echo({{"terminal jobid: "..term_job_id}}, false, {})
    toggle = true
  end

end

local function terminate_repl()
  vim.fn.jobstop(term_job_id)
  vim.api.nvim_buf_delete(term_buf_id, { force = true })
  vim.api.nvim_echo({{'REPL `'..repl..'` (jobpid: '..term_job_id..') has been terminated', 'Normal'}}, false, {})
end

local function setup(conf_tbl)
  if conf_tbl['repl'] ~= nil then
    config.modify_repl(conf_tbl['repl'])
  end
  if conf_tbl['split_method'] ~= nil then
    config.modify_method(conf_tbl['split_method'])
  end

  config.modify_mappings(conf_tbl['scrollup_map'], conf_tbl['scrolldown_map'])
end

return {
  toggle_repl = toggle_repl,
  terminate_repl = terminate_repl,
  setup = setup,
}
