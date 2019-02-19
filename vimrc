syntax on
set smartindent

set number
set tabstop=2
set shiftwidth=2
set expandtab

" install vim-plug if it is not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall -sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'
call plug#end()

" ALE settings
let g:ale_completion_enabled = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_rust_rls_toolchain = 'stable'
let g:ale_linters = {
\  'cpp': ['cquery'],
\  'python': ['pyls'],
\  'rust': ['rls']
\}
let g:ale_fixers = {
\ 'cpp': ['clang-format'],
\ 'rust': ['rustfmt']
\}

" Key mappings
let g:mapleader = ','
inoremap jk <esc>
map <leader>t :terminal<cr>
"" ALE key mappings
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>af :ALEFix<cr>
nnoremap <leader>ag :ALEGoToDefinitionInSplit<cr>
nnoremap <leader>at :ALEGoToTypeDefinitionInSplit<cr>
nnoremap <leader>ah :ALEHover<cr>
nnoremap <leader>ad :ALEDetail<cr>
nnoremap <leader>an :ALENext<cr>
"" Other plugin key mappings
let g:ctrlp_map = '<c-p>'
map <c-n> :NERDTreeToggle<cr>

set hlsearch

" show all trailing whitespaces
nnoremap <leader>kk /\s\+$<Esc>
nnoremap <leader>kh :noh<Esc>
