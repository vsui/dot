syntax on
set smartindent

set number
set tabstop=2
set shiftwidth=2
set expandtab
" this controls how long it takes for the current buffer to be flushed to disk
" the default is 4000 (4 seconds) but the git-gutter updates are dictated by
" this so I've set it lower
set updatetime=100

" install vim-plug if it is not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
autocmd	autocmd VimEnter * PlugInstall -sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'easymotion/vim-easymotion'
Plug 'kien/ctrlp.vim'
Plug 'lervag/vimtex'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
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
let g:ale_c_build_dir = './build'

" Key mappings
let g:mapleader = ','
inoremap jk <esc>
map <leader>t :terminal<cr>
map <leader>m :term make -C ./build<cr>
"" ALE key mappings
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>af :ALEFix<cr>
nnoremap <leader>ag :ALEGoToDefinition<cr>
nnoremap <leader>at :ALEGoToTypeDefinition<cr>
nnoremap <leader>ah :ALEHover<cr>
nnoremap <leader>ad :ALEDetail<cr>
nnoremap <leader>an :ALENext<cr>
"" Other plugin key mappings
let g:ctrlp_map = '<c-p>'
map <c-n> :NERDTreeToggle<cr>

nnoremap <leader>gn :GitGutterNextHunk<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gu :Gpush<cr>
nnoremap <leader>gp :GitGutterPrevHunk<cr>
nnoremap <leader>gd :GitGutterUndoHunk<cr>
nnoremap <leader>gs :Gstatus<cr>

