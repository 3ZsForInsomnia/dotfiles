let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/code/fe
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +78 ~/code/fe/apps/platform/src/app/features/prospects/pages/prospect-page-v2/prospect-page-v2.component.ts
badd +266 ~/code/fe/apps/platform/src/app/features/prospects/prospects.routing.ts
badd +12 ~/code/fe/apps/platform/src/app/features/prospects/pages/prospect-state-debug-v2/prospect-state-debug-v2.component.ts
badd +1 ~/code/fe/apps/platform/src/app/features/prospects/pages/prospect-state-debug-v2/prospect-state-debug-v2.component.html
argglobal
%argdel
$argadd ~/code/fe
edit ~/code/fe/apps/platform/src/app/features/prospects/pages/prospect-page-v2/prospect-page-v2.component.ts
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt ~/code/fe/apps/platform/src/app/features/prospects/prospects.routing.ts
setlocal fdm=expr
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=6
setlocal fml=1
setlocal fdn=20
setlocal fen
25
normal! zo
77
normal! zo
let s:l = 78 - ((32 * winheight(0) + 20) / 40)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 78
normal! 04|
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
