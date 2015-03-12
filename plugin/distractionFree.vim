let s:distractionSettings = {}
if empty(get(g:, 'distraction_free#toggle_options', {}))
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
endif

function! s:DistractionsOff() abort
	let s:distractionFree = 1
	let s:distractionSettings['gitgutter']  = get(g:, 'gitgutter_enabled', 0)
	let s:distractionSettings['signify']    = exists('b:sy') && b:sy.active
	let s:distractionSettings['limelight']  = exists(':Limelight') && get(g:, 'distraction_free#toggle_limelight', 0)
	let s:distractionSettings['tmux']       = exists('$TMUX') && get(g:, 'distraction_free#toggle_tmux', 0)
	let s:distractionSettings['fullscreen'] = has('fullscreen') && &fullscreen
	for setting in g:distraction_free#toggle_options
		execute printf('let s:distractionSettings[%s] = &%s | windo bufdo let &%s=0', string(setting), setting, setting)
	endfor
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
	for setting in g:distraction_free#toggle_options
		execute printf("let &%s = s:distractionSettings[%s]", setting, string(setting))
	endfor
	if exists(':AirLineRefresh')
		silent! AirlineRefresh
	elseif exists('#Powerline')
		silent! PowerlineReloadColorscheme
		silent! doautocmd Powerline ColorScheme
	elseif exists('#LightLine')
		silent! call lightline#enable()
	endif
	let s:distractionFree = 0
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
