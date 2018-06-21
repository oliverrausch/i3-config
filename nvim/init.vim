call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'danilo-augusto/vim-afterglow'
Plug 'bfrg/vim-cpp-modern'
Plug 'vim-scripts/wombat256.vim'
Plug 'vim-scripts/cSyntaxAfter'
Plug 'majutsushi/tagbar'
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

autocmd! FileType h,c,cpp,java,php call CSyntaxAfter() 

set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

colorscheme afterglow
set number
if has("autocmd")
	filetype indent plugin on
endif
nmap <F8> :TagbarToggle<CR>
map <c-p> :Files<CR>
map <c-l> :Tags<CR>

