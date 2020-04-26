# vim-auto-light-dark

Makes vim track macOS's Appearance mode. When the mode changes this plugin will
call a user defined hook to change vim settings for light or dark color schemes.

When running on another OS falls back to changing the color mode to dark at 5 PM.


<img src="https://github.com/nburns/vim-auto-light-dark/wiki/images/change.gif" alt="Appearance Mode Changing"/>

## Installation

### Vundle
```vim
Plugin 'nburns/vim-auto-light-dark'
```

## Setup
In your `~/.vimrc` define 2 functions, one for light mode and one for dark mode.
On startup, and when a change is detected, the function corresponding to the
current color mode will be called.

```vim
function DarkMode()
    let g:solarized_contrast="high"
    colorscheme solarized8_high
    set background=dark
    let g:lightline = { 'colorscheme': 'solarized' }
    let g:interface_mode = "dark"
endfunction

function LightMode()
    colorscheme BBEdit
    set background=light
    let g:lightline = { 'colorscheme': 'PaperColor' }
    let g:interface_mode = "light"
endfunction
```
