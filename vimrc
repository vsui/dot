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
Plug 'the-lambda-church/merlin'
Plug 'vim-syntastic/syntastic'
Plug 'sbdchd/neoformat'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'lervag/vimtex'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'rhysd/vim-clang-format'
Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install() } }
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

"" Other plugin key mappings
let g:ctrlp_map = '<c-p>'
map <c-n> :NERDTreeToggle<cr>
"" Git key mappings
nnoremap <leader>gn :GitGutterNextHunk<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gu :Gpush<cr>
nnoremap <leader>gp :GitGutterPrevHunk<cr>
nnoremap <leader>gd :GitGutterUndoHunk<cr>
nnoremap <leader>gs :Gstatus<cr>

" Ignore .gitignore for CtrlP
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" coc key mappings
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

set hidden "buffers can be closed

let g:clang_format#auto_format = 1
let g:clang_format#code_style = 'llvm'

let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_ocaml_checkers = ['merlin']

" neoformat
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

let g:neoformat_ocaml_ocaml_format = {
      \ 'exe': 'ocamlformat',
      \ 'args': ['--disable-outside-detected-project']
      \ }

let g:neoformat_enabled_ocaml = ['ocamlformat']

" deoplete
let g:deoplete#enable_at_startup = 1
"" blindly copied from `:h merlin.txt`
if !exists('g:deoplete#omni_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.ocaml = '[^. *\t]\.\w*|\s\w*|#'
