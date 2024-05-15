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

By default, `Yazi` is called instead of `netrw` when opening a directory in `vim`.

## Maps

Maps I like:

```
nnoremap <silent> - :Yazi<cr>
nnoremap <silent> _ :YaziWorkingDirectory<cr>
```

## Configuration

```
const g:yazi_command = 'yazi --with-args'
const g:yazi_exec_on_open = 'tabnew'
```

## Splits

Either split before calling `Yazi` or create a map that splits before calling `Yazi`:

```
nnoremap <silent> <C-v> :vsplit \| :Yazi<cr>
```
