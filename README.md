#DistractionFree.vim

Distraction-free editing in vim

![screenshot](https://raw.githubusercontent.com/DanielFGray/DistractionFree.vim/master/screencast.gif)

Drawing inspiration from [Goyo.vim](https://github.com/junegunn/goyo.vim) and [litedfm](https://github.com/bilalq/lite-dfm), I decided to try my hand at making my own but with a user defineable list of settings to toggle, and without any of the margins or padding around buffers.

#Installation

Installation is done as usual, with your plugin manager of choice.

If you don't have one already, I suggest [vim-plug](https://github.com/junegunn/vim-plug).

#Customization

This plugin exposes a couple of commands to switch between modes: `:DistractionsOn`, `:DistractionsOff`, and `:DistractionsToggle`. There aren't any mappings defined, you must add your own. I use the following:

    nnoremap <Leader>df <Esc>:DistractionsToggle<CR>

You can define the list of settings you want toggled (shown is the default):

    let g:distraction_free#toggle_options = [
    	\ 'cursorline',
    	\ 'colorcolumn',
    	\ 'cursorcolumn',
    	\ 'number',
    	\ 'relativenumber',
    	\ 'list',
    	\ 'ruler',
    	\ 'showtabline',
    	\ 'laststatus',
    \]

You can enable toggling of Limelight (show in screencast above):

    let g:distraction_free#toggle_limelight = 1

You can also toggle the tmux status bar:

    let g:distraction_free#toggle_tmux = 1
