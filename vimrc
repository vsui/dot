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


" Key mappings
let g:mapleader = ','
nnoremap <leader>w :w<cr>
inoremap jk <esc>
map <leader>t :terminal<cr>

"" Other plugin key mappings
let g:ctrlp_map = '<c-p>'
nnoremap <C-b> :CtrlPBuffer<cr>
map <c-n> :NERDTreeToggle<cr>
"" Git key mappings
nnoremap <leader>gu :GitGutterUndoHunk<cr>
nnoremap <leader>gk :GitGutterPrevHunk<cr>
nnoremap <leader>gj :GitGutterNextHunk<cr>
nnoremap <leader>gd :Gvdiff<cr>
nnoremap <leader>gs :Gstatus<cr>

" Ignore .gitignore for CtrlP
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

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

augroup file_type_cpp
  autocmd!
  autocmd Filetype c++ nmap <silent> gd <Plug>(coc-definition)
  autocmd Filetype c++ nmap <silent> gt <Plug>(coc-type-definition)
  autocmd Filetype c++ nmap <silent> gi <Plug>(coc-implementation)
  autocmd Filetype c++ nmap <silent> gr <Plug>(coc-references)
  autocmd Filetype c++ nmap <silent> [c <Plug>(coc-diagnostic-prev)
  autocmd Filetype c++ nmap <silent> ]c <Plug>(coc-diagnostic-next)
  autocmd Filetype c++ map <leader>m :term make -C ./build<cr>
augroup END

let g:neoformat_ocaml_ocamlformat = {
      \ 'exe': 'ocamlformat',
      \ }
 let g:neoformat_enabled_ocaml = ['ocamlformat']

" deoplete
let g:deoplete#enable_at_startup = 1
"" blindly copied from `:h merlin.txt`
if !exists('g:deoplete#omni_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.ocaml = '[^. *\t]\.\w*|\s\w*|#'
call deoplete#custom#option('auto_complete_delay', 1000)

augroup file_type_ocaml
  autocmd Filetype ocaml nnoremap go :MerlinOccurrences<cr>
  autocmd Filetype ocaml nnoremap gt :MerlinTypeOf<cr>
  autocmd Filetype ocaml nnoremap g? :MerlinDocument<cr>
  autocmd Filetype ocaml nnoremap gd :MerlinLocate<cr>
  autocmd Filetype ocaml map <leader>m :make<cr>
  autocmd Filetype ocaml nnoremap gj :lnext<cr>
  autocmd Filetype ocaml nnoremap gk :lprevious<cr>
  autocmd Filetype ocaml nnoremap g- :MerlinOutline<cr>
augroup END

"" ignore .mly and .mll
let g:syntastic_ignore_files = ['\m\c\.ml[ly]$']

tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l
