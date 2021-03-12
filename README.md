# [WIP] aedile.nvim

A plugin that help you to open REPL according to the current buffer filetype

# Requirement

Neovim nightly

# Installation

Vim-plug

```vimscript
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
  --  ft  = repl
      lua = 'luajit',
})

-- open repl by pressing <leader>r in normal mode
vim.api.nvim_set_keymap('n', '<leader>r', '<cmd>lua require("aedile").open_repl()<cr>')
```

# Check out these awesome plugins too
- [vim-slime](https://github.com/jpalardy/vim-slime)
- [vim-sexp](https://github.com/guns/vim-sexp)

# Todo
- [ ] documentation
