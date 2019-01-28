syntax on
set smartindent

" install vim-plug if it is not already present
if has('nvim')
	if empty(glob('~/.config/nvim/autoload/plug.vim'))
		silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall -sync | source $MYVIMRC
	endif
else
	if empty(glob('~/.vim/autoload/plug.vim'))
		silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall -sync | source $MYVIMRC
	endif
endif


let g:deoplete#enable_at_startup = 1

call plug#begin('~/.vim/plugged')
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
call plug#end()

let g:ctrlp_map = '<c-p>'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
map <C-n> :NERDTreeToggle<CR>
