# aedile.nvim

A Neovim plugin that open REPL in a split window according to the current buffer filetype

# Requirement

Neovim nightly

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
local aedile = require('aedile')

-- assign repl to a filetype
aedile.modify_repl({
  --  ft  =  repl
      lua = 'luajit',
})

-- use 'vertical' split
aedile.split_method('vertical')

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
