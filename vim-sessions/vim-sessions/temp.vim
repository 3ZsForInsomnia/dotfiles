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
badd +431 apps/platform/src/app/features/prospects/pages/prospect-workflow-page/prospect-workflow-page.component.ts
badd +49 apps/platform/src/app/features/prospects/pages/prospect-workflow-page/prospect-workflow-page.component.html
argglobal
%argdel
$argadd .
set stal=2
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit apps/platform/src/app/features/prospects/pages/prospect-workflow-page/prospect-workflow-page.component.ts
argglobal
balt apps/platform/src/app/features/prospects/pages/prospect-workflow-page/prospect-workflow-page.component.html
setlocal fdm=expr
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=6
setlocal fml=1
setlocal fdn=20
setlocal fen
53
normal! zo
65
normal! zo
74
normal! zo
83
normal! zo
125
normal! zo
127
normal! zo
135
normal! zo
144
normal! zo
147
normal! zo
156
normal! zo
165
normal! zo
179
normal! zo
180
normal! zo
181
normal! zo
191
normal! zo
203
normal! zo
206
normal! zo
206
normal! zo
210
normal! zo
219
normal! zo
226
normal! zo
264
normal! zo
285
normal! zo
304
normal! zo
313
normal! zo
319
normal! zo
335
normal! zo
351
normal! zo
352
normal! zo
372
normal! zo
386
normal! zo
399
normal! zo
412
normal! zo
let s:l = 205 - ((8 * winheight(0) + 9) / 18)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 205
normal! 0
tabnext
edit apps/platform/src/app/features/prospects/pages/prospect-workflow-page/prospect-workflow-page.component.ts
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt apps/platform/src/app/features/prospects/pages/prospect-workflow-page/prospect-workflow-page.component.html
setlocal fdm=diff
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=6
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 431 - ((1 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 431
normal! 06|
tabnext 2
set stal=1
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
