# PowerNuts

Currently under devloppment, do not expect anything to work.

A neovim plugin allowing users to use the full power of the Squirrel proof assistant.


## Installation

The plugin currently needs the ToggleTerm plugin to work.

### Using Lazy.nvim

```lua
{
    'benjamin-voisin/PowerNuts',
    dependencies = {akinsho/toggleterm.nvim},
}
```

## Configuration

You need to give the path to your compiled `squirrel prover` by placing the
line
```lua
require('powernuts').path = 'YourPathToSquirrel'
```

## Usage

Currently one function : `:Nuts`, which will pass the whole current file to the
squirrel prover by oppening a floating window and displaying the output of
squirrel.
