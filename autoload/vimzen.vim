" vimzen - a minimal plugin manager for vim 

let s:installation_path = ''
let s:zen_win = 1

" set install dir
if has('nvim')
	if !isdirectory($HOME . '/.local/share/nvim/plugged')
		call mkdir($HOME . '/.local/share/nvim/plugged')
	endif
	let s:installation_path = $HOME . '/.local/share/nvim/plugged'

" TODO: make dir for vim and windows
else
	if !isdirectory($HOME . '.vim/plugged')
		call mkdir($HOME . '.vim/plugged')
	endif
	let s:installation_path = $HOME . '.vim/plugged'
endif


" function! vimzen#add(remote, ...)

" 	if a:0 == 0 || a:0 > 1
" 		echo "Incomplete arguments"
" 		stop
" 	endif

" 	" create path for remote
" 	if a:remote =~ '^https:\/\/.\+'
" 		let l:remote = a:remote
" 	elseif a:remote =~ '^http:\/\/.\+'
" 		let l:remote = a:remote
" 		let l:remote = substitute(l:remote, '^http:\/\/.\+', 'https://', '')
" 	elseif a:remote =~ '^.\+/.\+'
" 		l:remote = 'https://github.com/' . a:remote . '.git'
" 	else
" 		echom "Failed to create remote repository path"
" 		stop
" 	endfunction


function! vimzen#start_window() abort
    execute s:zen_win . 'wincmd w'
    if !exists('b:plug')
        rightbelow belowright new
        nnoremap <silent> <buffer> q :q<cr>
        let b:plug = 1
        let s:zen_win = winnr()
    endif
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap cursorline
endfunction 



" Check if plugin is already installed
" git clone if not and add path to rtp
function! vimzen#install() abort
    let l:argument = ['junegunn/goyo.vim', 'arcticicestudio/nord-vim']

    call vimzen#start_window()
    call append(0, "VimZen - Installing plugins...")

    normal! 2G
    redraw

    for l:plugin in l:argument 
        let l:install_path = s:installation_path . "/" . split(l:plugin, "/")[-1]
        if !isdirectory(l:install_path)
            let l:cmd = "git clone " . "https://github.com/" . l:plugin . " " . l:install_path 
            let l:cmd_result =  system(l:cmd)
            call append(line('$'), '- ' . l:plugin . ': ' . l:cmd_result)
        else
            call append(line('$'), '- ' . l:plugin . ': ' . 'Skipped')
        endif
        execute "set rtp+=" . l:install_path 
        redraw 
    endfor
    call setline(1, "VimZen - Installation finished")
    redraw 
endfunction

" command! -nargs=* -bar -bang -complete=customlist,s:names ZenInstall call vimzen#install(<bang>0, [<f-args>])
" command -nargs=* -bar -complete=customlist,vimzen#complete ZenInstall
"                 \ call vimzen#install()
