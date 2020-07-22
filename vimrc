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
Plug 'sbdchd/neoformat'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'lervag/vimtex' " TODO remove
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround' " TODO remove?
Plug 'vim-airline/vim-airline'
Plug 'rhysd/vim-clang-format'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'roxma/vim-hug-neovim-rpc' " TODO remove?
call plug#end()

" Navigate to plugin_directory
command! PluginDirectory execute "e " . plugin_directory
command! InitFile execute "e " . $MYVIMRC

" Key mappings
let g:mapleader = ','
nnoremap <leader>ev :tabedit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>s :source %
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

"==========================
"= Begin coc.nvim configs =
"==========================
" Some servers have issues with backup files
set nobackup
set nowritebackup

" Give more space for displaying messages
set cmdheight=2

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Always show the signcolumn so text is not shifted whenever a diagnostic
" appears
if has("patch-8.1.1564")
  set signcolumn=number " support vim
else
  set signcolumn=yes
endif

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

nnoremap <silent> <space>o :<C-u>CocList outline<cr>
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>

" neoformat
"augroup fmt
"  autocmd!
"  autocmd BufWritePre * undojoin | Neoformat
"augroup END

command! -nargs=0 Format :call CocAction('format')

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
"========================
"= End coc.nvim configs =
"========================

