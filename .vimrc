set nocompatible
filetype off

syntax enable
set background=dark
colorscheme badwolf

set number
set relativenumber
set ruler
set hlsearch
set incsearch
set ignorecase
set cursorline
set expandtab
set shiftwidth=2
set softtabstop=2
set hidden
set nowrap
set ttimeoutlen=0
set noshowmode
set nomodeline

call plug#begin('~/.vim/plugged')
"Plug 'pearofducks/ansible-vim'
Plug 'airblade/vim-gitgutter'
Plug 'b4b4r07/vim-ansible-vault'
Plug 'editorconfig/editorconfig-vim'
Plug 'flazz/vim-colorschemes'
Plug 'jreybert/vimagit'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'hashivim/vim-terraform'
Plug 'kshenoy/vim-signature'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'w0rp/ale'
Plug 'tpope/vim-surround'
Plug 'michaeljsmith/vim-indent-object'
"Plug 'ludovicchabant/vim-gutentags'
call plug#end()

let g:airline_theme = 'badwolf'
let g:airline#extensions#tabline#enabled = 1
let g:ansible_vault_password_file = $ANSIBLE_VAULT_PASSWORD_FILE

autocmd VimEnter * command! -nargs=* AgWithoutIgnore
      \ call fzf#vim#ag(<q-args>, '-U', 0)

:nnoremap <C-n> :bnext!<CR>
:nnoremap <C-p> :bprevious!<CR>

map <leader>g :AgWithoutIgnore<CR>
map <leader>G :Ag<CR>
map <Leader>f :FZF<CR>
nmap <Leader>b :Buffers<CR>
nmap <leader>y :call system('pbcopy', @@)<CR>
nmap <leader>p :let @@=system('pbpaste')<CR>p<CR>
map <Leader>d :AnsibleVaultDecrypt<CR>
map <Leader>e :norm Go<ESC>:AnsibleVaultEncrypt<CR>


"This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
  silent exe "normal! `[v`]\"_c"
  silent exe "normal! p"
endfunction

" Helpers
function! FindConfig(prefix, what, where)
  let cfg = findfile(a:what, escape(a:where, ' ') . ';')
  return cfg !=# '' ? ' ' . a:prefix . ' ' . shellescape(cfg) : ''
endfunction

" ALE
let g:ale_sign_column_always = 1
let g:ale_open_list = 1
let g:airline#extensions#ale#enabled = 1
autocmd FileType yaml let b:ale_yaml_yamllint_options =
      \ get(g:, 'ale_yaml_yamllint_options', '') .
      \ FindConfig('-c', '.yamllint', expand('<afile>:p:h', 1))

nmap <leader>i :call InlineEncrypt()<CR>
nmap <leader>u :call InlineDecrypt()<CR>
function! InlineDecrypt()
  silent exe 'normal viiy'
  silent exe 'e tmp'
  silent exe 'normal P=G'
  silent exe 'AnsibleVaultDecrypt'
  silent exe 'normal ggyG'
  silent exe 'bd!'
  silent exe 'normal viipkJd3bx'
endfunction
function! InlineEncrypt()
  silent exe 'e tmp'
  silent exe 'normal P=G'
  silent exe 'AnsibleVaultEncrypt'
  silent exe 'normal ggyG'
  silent exe 'bd!'
  silent exe 'normal o'
  silent exe 'normal kA!vault |'
  silent exe 'normal p=}v}>'
endfunction

filetype plugin indent on
