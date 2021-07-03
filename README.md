# aedile.nvim

A Neovim plugin that open REPL in a split window according to the current buffer filetype

# Requirement

Neovim 0.5+

# Installation

Vim-plug

```viml
Plug 'ingram1107/aedile.nvim'
```

packer

```lua
use 'ingram1107/aedile.nvim'
```

# Usage

```lua
-- CONFIGURATION
require('aedile').setup {
  -- assign repl to a filetype
  repl           = {
    -- filetype = repl
    'lua'       = 'luajit',
    'python'    = 'ipython',
  },

  -- use 'vertical' split
  split_method   = 'vertical',

  -- mapping for repl buf
  scrollup_map   = '<c-[>',
  scrolldown_map = '<c-]>',
}

-- KEYMAP
vim.api.nvim_set_keymap('n', '<leader>rr', '<cmd>lua require("aedile").toggle_repl()<cr>')
vim.api.nvim_set_keymap('n', '<leader>rc', '<cmd>lua require("aedile").terminate_repl()<cr>')
```

# Check out these awesome plugins too
- [vim-slime](https://github.com/jpalardy/vim-slime)
- [vim-sexp](https://github.com/guns/vim-sexp)

# Todo
- [X] documentation
- [X] toggle REPL instead of open and close it
- [ ] create split window without moving the cursor
- [X] able to specify the window split method
