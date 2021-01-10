let g:mapleader = ' '

set number
set tabstop=4
set shiftwidth=4
set expandtab
set updatetime=100

let plug_path = stdpath('data') . '/site/autoload/plug.vim'
if empty(glob(plug_path))
    execute 'silent !curl -fLo ' . plug_path . ' --create-dirs '
        \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall -- sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
Plug 'joshdick/onedark.vim'
Plug 'rhysd/vim-clang-format'
Plug 'neovim/nvim-lspconfig'
call plug#end()

colorscheme onedark

inoremap jk <Esc>

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>d :Fern %:h<CR>
nnoremap <leader><S-d> :Fern .<CR>

lua require'lsp'
