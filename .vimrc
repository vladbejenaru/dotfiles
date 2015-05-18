

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'Lokaltog/vim-powerline'			" Powerline
"Plugin 'bling/vim-airline'					" Airline
Plugin 'scrooloose/nerdtree'				" theNERDtree
Plugin 'eagletmt/ghcmod-vim'				" ghcMod
Plugin 'shougo/vimproc.vim'					" Requirement for ghcMod
Plugin 'Twinside/vim-hoogle'				" Query the Haskell search engine Hoogle
Plugin 'altercation/vim-colors-solarized'	" Solarized color scheme

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Airline, Powerline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup

syntax on   
set laststatus=2
set t_Co=256
set number
hi LineNr ctermfg=245 ctermbg=234
hi Statement ctermfg=3
"let g:airline_powerline_fonts=1
"let g:airline_theme='powerlineish'
"let g:airline_left_sep=''
"let g:airline_right_sep=''


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
