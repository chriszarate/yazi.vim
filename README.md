# yazi.vim

Integration for [`yazi`](https://github.com/sxyazi/yazi) in `vim`. Inspired by [ranger.vim](https://github.com/francoiscabrol/ranger.vim), but made for the way I use `vim`. This plugin is not `nvim`-compatible; if you use `nvim` try one of the [plugins linked in `yazi`'s documentation](https://yazi-rs.github.io/docs/resources#-neovim-plugins).

## Installation

With `vim-plug`:

```
Plug 'chriszarate/yazi.vim'
```

## Commands

- `Yazi` or `YaziCurrentFile` opens `yazi` with the current file highlighted
- `YaziCurrentDirectory` opens `yazi` with the current directory highlighted
- `YaziWorkingDirectory` opens `yazi` with the working directory highlighted

The chosen file(s) will be opened as new buffers (`edit`). By default, `Yazi` is called instead of `netrw` when opening a directory in `vim`.

## Maps

Maps I like:

```vim
nnoremap <silent> - :Yazi<cr>
nnoremap <silent> _ :YaziWorkingDirectory<cr>
```

## Configuration

```vim
const g:yazi_command = 'yazi --with-args' " default 'yazi'
const g:yazi_exec_on_open = 'tabnew'      " default 'edit'
```

## Splits

Either create your desired split before calling `Yazi` or create a map that splits _and_ calls `Yazi`:

```vim
nnoremap <silent> <C-v> :vsplit \| :Yazi<cr>
```
