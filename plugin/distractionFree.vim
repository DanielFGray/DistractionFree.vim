let s:distractionSettings = {}
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

function! s:DoAllWindows(command) abort
	let currwin=winnr()
	let currBuff=bufnr("%")
	let currTab=tabpagenr()
	let curaltwin=winnr('#')
	execute 'bufdo ' . a:command
	execute 'buffer ' . currBuff
	execute 'windo ' . a:command
	execute curaltwin . 'wincmd w'
	execute currwin . 'wincmd w'
	execute 'tabdo ' . a:command
	execute 'tabn ' . currTab
endfunction

function! s:DistractionsOff() abort
	let s:distractionFree = 1
	let s:distractionSettings['gitgutter']  = get(g:, 'gitgutter_enabled', 0)
	let s:distractionSettings['signify']    = exists('b:sy') && b:sy.active
	let s:distractionSettings['limelight']  = exists(':Limelight') && get(g:, 'distraction_free#toggle_limelight', 0)
	let s:distractionSettings['tmux']       = exists('$TMUX') && get(g:, 'distraction_free#toggle_tmux', 0)
	let s:distractionSettings['fullscreen'] = has('fullscreen') && &fullscreen
	let [k, v, zero] = [[], [], []]
	for setting in g:distraction_free#toggle_options
		let k = add(k, printf('&%s', setting))
		let v = add(v, printf('s:distractionSettings[%s]', string(setting)))
		let zero = add(zero, 0)
	endfor
	execute 'let ['.join(v, ', ').'] = ['. join(k, ', ') .']'
	let dostr = 'let ['. join(k, ', ') .'] = ['. join(zero, ', ') .']'
	call s:DoAllWindows(dostr)
	unlet k v dostr
	if s:distractionSettings['gitgutter']
		silent! GitGutterDisable
	endif
	if s:distractionSettings['signify']
		silent! SignifyToggle
	endif
	if s:distractionSettings['limelight']
		silent! Limelight
	endif
	if s:distractionSettings['tmux']
		silent! !tmux set -q status off
	endif
	if has('gui_running')
		let s:distractionSettings['guioptions'] = &guioptions
		set guioptions-=T
		set guioptions-=r
		set guioptions-=L
		if has('fullscreen')
			set fullscreen
		endif
	endif
endfunction

function! s:DistractionsOn() abort
	let s:distractionFree = 0
	let [k, v] = [[], []]
	for setting in g:distraction_free#toggle_options
		let k = add(k, printf('&%s', setting))
		let v = add(v, printf('s:distractionSettings[%s]', string(setting)))
	endfor
	let dostr = 'let ['.join(k, ', ').'] = ['. join(v, ', ') .']'
	call s:DoAllWindows(dostr)
	unlet k v dostr
	if s:distractionSettings['gitgutter']
		silent! GitGutterEnable
	endif
	if s:distractionSettings['signify']
		silent! SignifyToggle
	endif
	if s:distractionSettings['limelight']
		silent! Limelight!
	endif
	if s:distractionSettings['tmux']
		silent! !tmux set -q status on
	endif
	if has('gui_running')
		let &guioptions = s:distractionSettings['guioptions']
		if s:distractionSettings['fullscreen']
			let &fullscreen = s:distractionSettings['fullscreen']
		endif
	endif
	if exists(':AirLineRefresh')
		silent! AirlineRefresh
	elseif exists('#Powerline')
		silent! PowerlineReloadColorscheme
		silent! doautocmd Powerline ColorScheme
	elseif exists('#LightLine')
		silent! call lightline#enable()
	endif
endfunction

function! s:ToggleDistractions() abort
	if !exists('s:distractionFree') || !s:distractionFree
		call s:DistractionsOff()
	else
		call s:DistractionsOn()
	endif
	silent! redraw!
endfunction

command! -nargs=0 DistractionsToggle call <SID>ToggleDistractions()
command! -nargs=0 DistractionsOn call <SID>DistractionsOn()
command! -nargs=0 DistractionsOff call <SID>DistractionsOff()
