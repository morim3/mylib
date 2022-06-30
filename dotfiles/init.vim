" dein.vim settings {{{
" install dir {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" dein installation check {{{
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}

" begin settings {{{
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " .toml file
  let s:rc_dir = expand('~/.config/nvim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'

  " read toml and cache
  call dein#load_toml(s:toml, {'lazy': 0})

  " end settings
  call dein#end()
  call dein#save_state()
endif
" }}}

" plugin installation check {{{
if dein#check_install()
  call dein#install()
endif
" }}}

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}


"End dein Scripts-------------------------

set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd

set number
set cursorline
set virtualedit=all
set smartindent
set showmatch
set wildmode=list:longest
set splitright
set splitbelow

" Tab系
set expandtab
set tabstop=2
set shiftwidth=2


" 検索系
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set backspace=3

" シンタックスハイライトの有効化
syntax enable
colorscheme duskfox


inoremap <silent> jj <ESC>
tnoremap <Esc> <C-\><C-n>
autocmd TermOpen * startinsert

nmap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap tm :vsp <ENTER> :terminal <ENTER>
nnoremap mp :MarkdownPreview <ENTER>
nnoremap <C-n> :NERDTreeToggle <ENTER>
nnoremap O :<C-u>call append(expand('.'), '')<Cr>j
nnoremap <Space>/ <S-i># <ESC>
vnoremap <Space>/ <S-i># <ESC>
nnoremap <Space>f <C-f>
nnoremap <Space>b <C-b>
nnoremap <Space>rc :vsp ~/.config/nvim/init.vim <Enter>
nmap <Space>d <Plug>(coc-definition)
nmap <Space>r <Plug>(coc-references)


"" coc.nvim
""" <Tab>で候補をナビゲート
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
""" <Tab>で次、<S+Tab>で前
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
