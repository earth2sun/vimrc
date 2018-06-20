set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/snipMate'
Plugin 'vim-scripts/minibufexpl.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
Plugin 'taglist.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'nerdtree-ack'
Plugin 'mileszs/ack.vim'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
syntax on
set nu
set expandtab
set tabstop=4
set shiftwidth=4

let mapleader=","

"" Tlist
nmap <Leader>lt :Tlist<CR>
let Tlist_Use_Right_Window = 1

"" nerdtree
nmap <Leader>lf :NERDTreeToggle<CR>

" MiniBufExplorer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1

""""
set laststatus=2
set statusline=%r%f\ (CWD:\ %{getcwd()})%h\ \ \ Line:\ %l\ \ Column:\ %c

" for ack.vim
let s:marks = [".git", ".svn"]
fu s:SetProjDir()
    if exists('g:proj_dir') && (g:proj_dir != '.') | return | endif
    let dir_path = expand("%:p")
    while 1
        let dir_path = matchstr(dir_path, '.*/')
        for mark in s:marks
            let mark_path = dir_path . mark
            if isdirectory(mark_path)
                let g:proj_dir = dir_path | break |
            endif
        endfor
        if exists('g:proj_dir') | break | endif
        let dir_path = dir_path[0:-2] "remove the ending '/'
        if !strlen(dir_path) | break | endif
    endwhile
    if !exists('g:proj_dir') | let g:proj_dir = "." | endif
endf

fu! g:FindKey(key, all)
    let @/ = a:key
    exec printf("Ack! -m1 %s %s %s", a:all?'':'--lua', a:key, g:proj_dir)
endf
nmap <Leader>s :call g:FindKey('<C-R><C-W>', 0)<CR>
nmap <Leader>S :call g:FindKey('<C-R><C-W>', 1)<CR>
vmap <Leader>vs y:call g:FindKey('<C-R>"', 0)
vmap <Leader>vS y:call g:FindKey('<C-R>"', 0)
"set tags
fu s:SetTags()
    if exists('s:tags_setted') | return | endif
    let dir_path = expand("%:p")
    while 1
        let dir_path = matchstr(dir_path, '.*/')
        let tags_path = dir_path . 'tags'
        if filereadable(tags_path)
            let &tags=tags_path
            let s:tags_setted = 1
        endif
        let dir_path = dir_path[0:-2] "remove the ending '/'
        if !strlen(dir_path) | break | endif
    endwhile
endf

augroup vimrc
    au!
    au BufRead * call s:SetProjDir()
    au BufRead * call s:SetTags()
augroup END

nn <Leader>i :tj /\C^\(\i\+[.:]\)\?<C-R><C-W>\s*$<CR>

" search .lua
fu! s:FindFile(lib)
    let lib_pt = printf('/%s.lua', tr(a:lib, '.', '/'))
    let lib_files = systemlist('locate '.lib_pt)
    if !len(lib_files)
        let lib_pt = 'luaopen_'.tr(a:lib, '.', '_')
        let lib_files = systemlist(printf("ack -l -1 --cc %s %s", lib_pt, g:proj_dir))
    endif
    if len(lib_files) == 1
        exec 'edit'.lib_files[0]
        return
    endif
    let i = 0
    for line in lib_files
        let lib_files[i] = {'filename':line}
        let i = i + 1
    endfor
    call setqflist(lib_files, 'r')
    botright copen 3
    exec "redraw!"
endf

fu! s:FindFileByKey()
    let pt = printf('^local\s\+%s\s\+=\s\+require', expand("<cword>"))
    let ptnr = search(pt, 'bn')
    if !ptnr | retu | en
    let lib = matchstr(getline(ptnr), '"[^"]\+"')
    call s:FindFile(lib[1:-2])
endf
command! -nargs=0 FFBK call s:FindFileByKey()
command! -nargs=1 FindFile call s:FindFile(<f-args>)
nmap <Leader>f :FFBK<CR>
vnoremap <Leader>vf y:FindFile <C-R>"<CR>
"close the quickfix window
map <Leader>x :ccl<CR>
