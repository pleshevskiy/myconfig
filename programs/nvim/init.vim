" Basic settings {{{
let g:mapleader = ','
let g:maplocalleader = '-'

syntax enable
filetype plugin indent on
set encoding=utf-8
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set number
set signcolumn=yes
" TODO: use difference color column by filetypes
set colorcolumn=80,100,120
set hidden
set nobackup
set nowritebackup
set updatetime=100
set shortmess+=c
set nopaste
set foldcolumn=0
" }}}

" Mappings {{{
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}

cabbrev bsp belowright split
cabbrev rvsp belowright vsplit

" Markdown file settings {{{
aug filetype_md
  au!
  au FileType markdown iabbrev @@ dmitriy@ideascup.me
aug END
" }}}

" Plugins {{{
call plug#begin()
  Plug 'junegunn/seoul256.vim'                        " theme
  Plug 'Yggdroot/indentLine'                          " tab and space indentation
  Plug 'mg979/vim-visual-multi', {'branch': 'master'} " multi cursors
  Plug 'preservim/nerdtree'                           " file tree
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'airblade/vim-gitgutter'                       " git gutter

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
  Plug 'LnL7/vim-nix'                                 " nix lang
call plug#end()
" }}}

" Plugin: GitGutter {{{
let g:gitgutter_sign_priority = 1
let g:gitgutter_set_sign_backgrounds = 0

nnoremap <leader>ghl :GitGutterLineHighlightsToggle<CR>
" }}}

let g:sql_type_default = 'pgsql'

" Plugin: NeoFormat {{{
let g:neoformat_try_node_exe = 1
let g:neoformat_only_msg_on_error = 1
aug fmt
  au!
  au BufWritePre * undojoin | Neoformat
aug END
" }}}

" Plugin: NerdTree {{{
let g:NERDTreeDirArrowExpandable = '???'
let g:NERDTreeDirArrowCollapsible = '???'
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-g> :NERDTreeFind<CR>
" }}}

" Plugin: NerdTreeGit {{{
let g:NERDTreeGitStatusShowIgnored = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
      \ "Modified"  : "???",
      \ "Staged"    : "??",
      \ "Untracked" : "???",
      \ "Renamed"   : "??",
      \ "Unmerged"  : "???",
      \ "Deleted"   : "??",
      \ "Dirty"     : "??",
      \ "Clean"     : "???",
      \ "Unknown"   : "?"
      \ }
" }}}

" Plugin: LSP {{{
let g:lsp_preview_max_width = 60
let g:lsp_diagnostics_float_cursor = 1

" if (executable('haskell-language-server-wrapper'))
"   echom "Haskell lsp installed"
"   au User lsp_setup call lsp#register_server({
"       \ 'name': 'haskell-language-server-wrapper',
"       \ 'cmd': {server_info->['haskell-language-server-wrapper', 'lsp']},
"       \ 'whitelist': ['haskell'],
"       \ })
" endif

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

aug lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  au User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
aug END
" }}}

" Theme {{{
set background=light
colo seoul256-light
highlight ColorColumn ctermbg=254
" uses for fzf preview
let $BAT_THEME = 'Monokai Extended Light'
" }}}
