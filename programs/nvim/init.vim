" Basic settings {{{
let g:mapleader = ','
let g:maplocalleader = '-'

syntax enable
filetype plugin on
filetype plugin indent on
set encoding=utf-8
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set number
set signcolumn=number
" TODO: use difference color column by filetypes
set colorcolumn=80,100,120
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
set nopaste
" }}}

" Mappings {{{
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}

" Markdown file settings {{{
augroup filetype_md
  autocmd!
  autocmd FileType markdown iabbrev @@ dmitriy@ideascup.me
augroup END
" }}}

" Vimscript file settings {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Plugins {{{
call plug#begin()
  Plug 'junegunn/seoul256.vim'                        " theme
  Plug 'Yggdroot/indentLine'                          " tab and space indentation
	Plug 'mg979/vim-visual-multi', {'branch': 'master'} " multi cursors
	Plug 'preservim/nerdtree'                           " file tree
  Plug 'Xuyuanp/nerdtree-git-plugin'

  Plug 'prabirshrestha/vim-lsp'                       " lsp for many langs
  Plug 'prabirshrestha/asyncomplete.vim'              " autocomplete
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'mattn/vim-lsp-settings'                       " settings for lsp plugin

	Plug 'sbdchd/neoformat'                             " format langs via official tools
  Plug 'easymotion/vim-easymotion'                    " fast navigation
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fuzzy find files
  Plug 'junegunn/fzf.vim'                             " fzf integration
  Plug 'dyng/ctrlsf.vim'                              " async searching
	Plug 'christoomey/vim-tmux-navigator'               " navigation inside tmux
	Plug 'editorconfig/editorconfig-vim'								" editorconfig
  Plug 'cespare/vim-toml', { 'branch': 'main' }       " toml lang
	Plug 'rust-lang/rust.vim'                           " rust lang
  Plug 'jparise/vim-graphql'                          " graphql lang with gql tag
  Plug 'lifepillar/pgsql.vim'                         " postgresql lang support
call plug#end()
" }}}


let g:sql_type_default = 'pgsql'

" Plugin: NeoFormat {{{
let g:neoformat_try_node_exe = 1
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
" }}}

" Plugin: NerdTree {{{
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" }}}

" Plugin: NerdTreeGit {{{
let g:NERDTreeGitStatusShowIgnored = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "ᵐ",
    \ "Staged"    : "ˢ",
    \ "Untracked" : "ᵘ",
    \ "Renamed"   : "ʳ",
    \ "Unmerged"  : "ᶴ",
    \ "Deleted"   : "ˣ",
    \ "Dirty"     : "˜",
    \ "Clean"     : "ᵅ",
    \ "Unknown"   : "?"
    \ }
" }}}

" Plugin: LSP {{{
let g:lsp_preview_max_width = 60
let g:lsp_diagnostics_float_cursor = 1

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}

" Theme {{{
set background=light
colo seoul256-light
highlight ColorColumn ctermbg=254
" uses for fzf preview
let $BAT_THEME = 'Monokai Extended Light'
" }}}
