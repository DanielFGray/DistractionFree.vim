function! s:DistractionsOff()
	let g:distractionFree = 1
	let s:distractionSettings = {
		\ 'cursorline':     &cursorline,
		\ 'cursorcolumn':   &cursorcolumn,
		\ 'colorcolumn':    &colorcolumn,
		\ 'number':         &number,
		\ 'relativenumber': &relativenumber,
		\ 'list':           &list,
		\ 'ruler':          &ruler,
		\ 'showtabline':    &showtabline,
		\ 'laststatus':     &laststatus,
		\ 'gitgutter':      get(g:, 'gitgutter_enabled', 0),
		\ 'limelight':      exists(':Limelight'),
		\ 'signify':        exists('b:sy') && b:sy.active,
		\ 'fullscreen':     has('fullscreen') && &fullscreen,
		\ 'tmux':           exists('$TMUX') && get(g:, 'distraction_free#toggle_tmux', 0)
		\ }
	if has('gui_running')
		let s:distractionSettings['fullscreen'] = has('fullscreen') && &fullscreen
	endif
	bufdo set nocursorline
		\ nocursorcolumn
		\ colorcolumn=
		\ nonumber
		\ norelativenumber
		\ nolist
	windo set nocursorline
		\ nocursorcolumn
		\ colorcolumn=
		\ nonumber
		\ norelativenumber
		\ nolist
	set noruler showtabline=0 laststatus=0
	if s:distractionSettings['limelight']
		silent! Limelight
	endif
	if s:distractionSettings['signify']
		silent! SignifyToggle
	endif
	if s:distractionSettings['gitgutter']
		silent! GitGutterDisable
	endif
	if s:distractionSettings['tmux']
		silent! !tmux set -q status off
	endif
	if has('fullscreen')
		set fullscreen
	endif
endfunction

function! s:DistractionsOn()
	let g:distractionFree = 0
	bufdo let [&cursorline,
		\ &cursorcolumn,
		\ &colorcolumn,
		\ &number,
		\ &relativenumber,
		\ &list]
		\ = [s:distractionSettings['cursorline'],
		\ s:distractionSettings['cursorcolumn'],
		\ s:distractionSettings['colorcolumn'],
		\ s:distractionSettings['number'],
		\ s:distractionSettings['relativenumber'],
		\ s:distractionSettings['list']]
	windo let [&cursorline,
		\ &cursorcolumn,
		\ &colorcolumn,
		\ &number,
		\ &relativenumber,
		\ &list]
		\ = [s:distractionSettings['cursorline'],
		\ s:distractionSettings['cursorcolumn'],
		\ s:distractionSettings['colorcolumn'],
		\ s:distractionSettings['number'],
		\ s:distractionSettings['relativenumber'],
		\ s:distractionSettings['list']]
	let [&ruler,
		\ &showtabline,
		\ &laststatus]
		\ = [s:distractionSettings['ruler'],
		\ s:distractionSettings['showtabline'],
		\ s:distractionSettings['laststatus']]
	if s:distractionSettings['limelight']
		silent! Limelight!
	endif
	if s:distractionSettings['gitgutter']
		silent! GitGutterEnable
	endif
	if s:distractionSettings['signify']
		silent! SignifyToggle
	endif
	if exists(':AirLineRefresh')
		silent! AirlineRefresh
	elseif exists('#Powerline')
		silent! PowerlineReloadColorscheme
		silent! doautocmd Powerline ColorScheme
	elseif exists('#LightLine')
		silent! call lightline#enable()
	endif
	if s:distractionSettings['tmux']
		silent! !tmux set -q status on
	endif
	if has('gui_running') && has('fullscreen')
		let &fullscreen = s:distractionSettings['fullscreen']
	endif
endfunction

function! s:ToggleDistractions()
	let currBuff = bufnr("%")
	if !exists('g:distractionFree') || !g:distractionFree
		call s:DistractionsOff()
	else
		call s:DistractionsOn()
	endif
	execute 'buffer ' . currBuff
	silent! redraw!
endfunction

command! -nargs=0 ToggleDistractions call <SID>ToggleDistractions()
