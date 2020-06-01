syntax on
set smartindent

if has('nvim') && !has('nvim-0.4.3')
  echom "This script may not work for nvim version < 0.4.3"
endif

set number
set tabstop=2
set shiftwidth=2
set expandtab
" this controls how long it takes for the current buffer to be flushed to disk
" the default is 4000 (4 seconds) but the git-gutter updates are dictated by
" this so I've set it lower
set updatetime=100

" Stops vim from calling stdpath, which is only defined for nvim
function StdpathCompat(in)
  if has('nvim')
    return stdpath(in)
  else
    echoerr '`stdpath_compat` should not be called in vim'
    return ''
  endif
endfunction

" Make this a function so vim can avoid calling this
function VimPlugPathNvim()
  if !has('nvim')
    echoerr 'This function should only be called in nvim'
  endif
  return stdpath('data') . "/site/autoload/plug.vim"
endfunction

" install vim-plug if it is not already installed
let vimplug_path_vim = "~/.vim/autoload/plug.vim"
let vimplug_path = has('nvim') ? VimPlugPathNvim() : "~/.vim/autoload/plug.vim"
if empty(glob(vimplug_path))
  execute 'silent !curl -fLo ' . vimplug_path . ' --create-dirs '
      \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let plugin_directory = has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged'
call plug#begin(plugin_directory)
Plug 'airblade/vim-gitgutter'
Plug 'easymotion/vim-easymotion'
Plug 'kien/ctrlp.vim'
Plug 'the-lambda-church/merlin'
Plug 'sbdchd/neoformat'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'lervag/vimtex'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'rhysd/vim-clang-format'
Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install() } }
Plug 'roxma/vim-hug-neovim-rpc'
call plug#end()

" Key mappings
let g:mapleader = ','
inoremap jk <esc>
"" Other plugin key mappings
let g:ctrlp_map = '<c-p>'
map <c-n> :NERDTreeToggle<cr>
"" Git key mappings
nnoremap <leader>gx :GitGutterUndoHunk<cr>
nnoremap <leader>g[ :GitGutterPrevHunk<cr>
nnoremap <leader>g] :GitGutterNextHunk<cr>

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

"buffers can be closed. Supposedly necessary for coc.nvim as well
set hidden

" coc.nvim: Some servers have issues with backup files
set nobackup
set nowritebackup


" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Use <c-space to trigger completion"
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
"execute "set rtp+=" . g:opamshare . "/merlin/vim"

" syntastic settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"
"let g:syntastic_ocaml_checkers = ['merlin']

" neoformat
"augroup fmt
"  autocmd!
"  autocmd BufWritePre * undojoin | Neoformat
"augroup END

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

"let g:neoformat_ocaml_ocamlformat = {
"      \ 'exe': 'ocamlformat',
"      \ }
"let g:neoformat_enabled_ocaml = ['ocamlformat']

" deoplete
" let g:deoplete#enable_at_startup = 1
" "" blindly copied from `:h merlin.txt`
" if !exists('g:deoplete#omni_patterns')
"   let g:deoplete#omni#input_patterns = {}
" endif
" let g:deoplete#omni#input_patterns.ocaml = '[^. *\t]\.\w*|\s\w*|#'
" call deoplete#custom#option('auto_complete_delay', 1000)

"augroup file_type_ocaml
"  autocmd Filetype ocaml nnoremap go :MerlinOccurrences<cr>
"  autocmd Filetype ocaml nnoremap gt :MerlinTypeOf<cr>
"  autocmd Filetype ocaml nnoremap g? :MerlinDocument<cr>
"  autocmd Filetype ocaml nnoremap gd :MerlinLocate<cr>
"  autocmd Filetype ocaml map <leader>m :make<cr>
"  autocmd Filetype ocaml nnoremap gj :lnext<cr>
"  autocmd Filetype ocaml nnoremap gk :lprevious<cr>
"  autocmd Filetype ocaml nnoremap g- :MerlinOutline<cr>
"  autocmd Filetype ocaml let g:syntastic_ignore_files = ['\m\c\.ml[ly]$']
"augroup END
