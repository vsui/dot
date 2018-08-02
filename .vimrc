syntax on
set smartindent

" install vim-plug if it is not already present
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall -sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
call plug#end()

let g:ctrlp_map = '<c-p>'
map <C-n> :NERDTreeToggle<CR>
