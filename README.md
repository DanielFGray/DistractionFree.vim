#DistractionFree.vim

Distraction-free editing in vim

![screenshot](https://raw.githubusercontent.com/DanielFGray/DistractionFree.vim/master/screencast.gif)

Drawing inspiration from [Goyo.vim](https://github.com/junegunn/goyo.vim) and [litedfm](https://github.com/bilalq/lite-dfm), I decided to try my hand at making my own but without any of the margins or padding around buffers.

#Installation

Installation is done as usual, with your plugin manager of choice.

If you don't have one already, I suggest [vim-plug](https://github.com/junegunn/vim-plug).

#Customization

This plugin exposes a single command to toggle between modes `:ToggleDistractions`, but doesn't provide any mappings by default to allow you to add your own. I use the following:

    nnoremap <Leader>df <Esc>:ToggleDistractions<CR>

I've included an option to toggle your tmux status bar when running in a tmux session:

    let g:distraction_free#toggle_tmux = 1
