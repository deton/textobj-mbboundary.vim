" vi:set ts=8 sts=2 sw=2 tw=0:
scriptencoding utf-8

" plugin/textobj/mbboundary.vim - ASCII文字と日本語文字の境界区切りでtext-object
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Last Change: 2013-04-30
"
" Description:
"   日本語文字中の英語のフレーズを扱いやすくするためのプラグイン。
"   ASCII文字とマルチバイト文字の境界を区切りとするtext-object。
"   ASCII文字とマルチバイト文字の境界まで移動。
"
"   例えば、「VIM は Vi IMproved の略です。」のpにカーソルがある際に、
"   "Vi IMproved"をtext-objectとして扱う用途を想定。

if exists('g:loaded_mbboundary')
  finish
endif

nnoremap <silent> <Plug>MBBoundaryMoveNF :<C-U>call <SID>MoveCount('<SID>move_n', v:count1)<CR>
nnoremap <silent> <Plug>MBBoundaryMoveNB :<C-U>call <SID>MoveCount('<SID>move_p', v:count1)<CR>
onoremap <silent> <Plug>MBBoundaryMoveOF :<C-U>call <SID>MoveCount('<SID>move_n', v:count1)<CR>
onoremap <silent> <Plug>MBBoundaryMoveOB :<C-U>call <SID>MoveCount('<SID>move_p', v:count1)<CR>
vnoremap <silent> <Plug>MBBoundaryMoveVF <Esc>:call <SID>MoveV('<SID>move_n')<CR>
vnoremap <silent> <Plug>MBBoundaryMoveVB <Esc>:call <SID>MoveV('<SID>move_p')<CR>

onoremap <silent> <Plug>MBBoundaryTextObjA :<C-U>call <SID>select_function_wrapper('<SID>select_a', v:count1)<CR>
onoremap <silent> <Plug>MBBoundaryTextObjI :<C-U>call <SID>select_function_wrapper('<SID>select_i', v:count1)<CR>
vnoremap <silent> <Plug>MBBoundaryTextObjVA <Esc>:call <SID>select_function_wrapperv('<SID>select_a', 0)<CR>
vnoremap <silent> <Plug>MBBoundaryTextObjVI <Esc>:call <SID>select_function_wrapperv('<SID>select_i', 1)<CR>

if !get(g:, 'mbboundary_no_default_key_mappings', 0)
  omap <silent> am <Plug>MBBoundaryTextObjA
  omap <silent> im <Plug>MBBoundaryTextObjI
  xmap <silent> am <Plug>MBBoundaryTextObjVA
  xmap <silent> im <Plug>MBBoundaryTextObjVI
  if get(g:, 'mbboundary_default_motion_key_mappings', 0)
    " "gm"を上書き
    nmap <silent> gm <Plug>MBBoundaryMoveNF
    nmap <silent> gM <Plug>MBBoundaryMoveNB
    omap <silent> gm <Plug>MBBoundaryMoveOF
    omap <silent> gM <Plug>MBBoundaryMoveOB
    xmap <silent> gm <Plug>MBBoundaryMoveVF
    xmap <silent> gM <Plug>MBBoundaryMoveVB
  endif
endif

" from vim-textobj-user
function! s:select_function_wrapper(function_name, count1)
  let ORIG_POS = getpos('.')
  let _ = function(a:function_name)(a:count1, 0)
  if _ is 0
    call setpos('.', ORIG_POS)
    return
  endif
  let [motion_type, start_position, end_position] = _
  execute 'normal!' motion_type
  call setpos('.', start_position)
  normal! o
  call setpos('.', end_position)
endfunction

function! s:select_function_wrapperv(function_name, inner)
  let cnt = v:prevcount
  if cnt == 0
    let cnt = 1
  endif
  " 何も選択されていない場合、textobj選択
  let pos = getpos('.')
  execute 'normal! gvo' . "\<Esc>"
  let otherpos = getpos('.')
  execute 'normal! gvo' . "\<Esc>"
  if pos == otherpos
    call s:select_function_wrapper(a:function_name, cnt)
    return
  endif

  " 選択済の場合、選択領域をextendする
  if s:pos_lt(pos, otherpos)
    " backward
    if a:inner
      let _ = s:select_b(cnt, 1)
    else
      let _ = s:select_b(cnt, 0)
    endif
  else
    if a:inner
      let _ = s:select_i(cnt, 1)
    else
      let _ = s:select_a(cnt, 1)
    endif
  endif
  let [motion_type, start_position, end_position] = _
  normal! gv
  call setpos('.', end_position)
endfunction

function! s:select_a(cnt, visual)
  return s:select(a:cnt, 0, a:visual)
endfunction

function! s:select_i(cnt, visual)
  return s:select(a:cnt, 1, a:visual)
endfunction

function! s:select(cnt, inner, visual)
  let origpos = getpos('.')
  if a:visual
    call search('.', 'W') " 繰り返しam/imした場合にextendするため
  else
    " 現在位置の文字種(ASCIIかマルチバイト)が続いている先頭位置まで戻る
    call s:move_head()
    if a:inner && s:onblank()
      " "im"で先頭が空白の場合、空白は含めない
      let st0 = getpos('.')
      if search('\s\+\S', 'ceW') > 0
	if s:pos_lt(origpos, getpos('.'))
	  call setpos('.', st0)
	endif
      endif
    endif
  endif
  let st = getpos('.')
  let cnt = a:cnt
  let trimendsp = 0
  if a:inner
    " innerの場合はASCII文字列とマルチバイト文字列間の空白もcountを消費する。
    " 間に空白が無い場合もあるが、あるとみなしてcountを消費。
    let cnt = (a:cnt + 1) / 2
    if a:cnt % 2 == 0
      let trimendsp = 0
    else
      let trimendsp = 1
    endif
  endif
  call s:MoveCount('<SID>move_n', cnt)

  let ed = s:PrevStrEndPos()
  " 対象文字列末尾の空白は含めない。
  if trimendsp && match(getline('.'), '\%' . col('.') . 'c\s') != -1
    call search('\S', 'bW')
    let edtmp = getpos('.')
    if s:pos_lt(st, edtmp)
      let ed = edtmp
    " else 末尾の空白を除くと開始位置以前になって何も選択されなくなる場合は、
    " 空白も対象にする
    endif
  endif
  return ['v', st, ed]
endfunction

" Visual modeでbackwardにextendする
function! s:select_b(cnt, inner)
  call s:move_left() " 繰り返しam/imした場合にextendするため
  let st = getpos('.')
  let cnt = a:cnt
  let trimbegsp = 0
  if a:inner
    let cnt = (a:cnt + 1) / 2
    if a:cnt % 2 == 0
      let trimbegsp = 0
    else
      let trimbegsp = 1
    endif
  endif
  call s:MoveCount('<SID>move_head', cnt)

  let ed = getpos('.')
  " 対象文字列先頭の空白は含めない
  if trimbegsp && match(getline('.'), '\%' . col('.') . 'c\s') != -1
    call search('\S', 'W')
    let edtmp = getpos('.')
    if s:pos_lt(edtmp, st)
      let ed = edtmp
    " else 先頭の空白を除くと開始位置以降になって何も選択されなくなる場合は、
    " 空白も対象にする
    endif
  endif
  return ['v', st, ed]
endfunction

" カーソルがASCII文字上かどうか
function! s:onascii()
  let line = getline('.')
  " 空行 || ASCII文字上かどうか
  if line == '' || match(line, '\%' . col('.') . 'c[[:print:]]') != -1
    return 1 " 空行 || ASCII文字上
  endif
  return 0 " ASCII文字上でない場合
endfunction

" カーソルがblank文字上かどうか
function! s:onblank()
  if match(getline('.'), '\%' . col('.') . 'c\s') != -1
    return 1
  else
    return 0
  endif
endfunction

" バッファ末尾かどうか
function! s:bufend()
  if line('.') != line('$')
    return 0
  endif
  let edtmp = getpos('.')
  call s:move_n()
  let pos = getpos('.')
  if s:pos_eq(pos, edtmp)
    return 1
  endif
  call setpos('.', edtmp)
  return 0
endfunction

" 直前のASCII/マルチバイト文字列の末尾位置を返す。
" 前提条件: ASCII/マルチバイト文字列の開始位置にカーソルがある
function! s:PrevStrEndPos()
  " バッファ末尾の場合に末尾の文字だけが残ったりしないように
  if s:bufend()
    return getpos('.')
  endif
  " 現在位置の直前まで
  call s:move_left()
  return getpos('.')
endfunction

function! s:move_left()
  if col('.') > 1
    call cursor(0, col('.') - 1)
  else
    call cursor(line('.') - 1, 0)
    call cursor(0, col('$'))
  endif
endfunction

function! s:MoveCount(func, cnt)
  for i in range(a:cnt)
    call call(a:func, [])
  endfor
endfunction

" move_{n,p}をVisual modeに対応させるためのラッパ
function! s:MoveV(func)
  let cnt = v:prevcount
  if cnt == 0
    let cnt = 1
  endif
  for i in range(cnt)
    call call(a:func, [])
  endfor
  let pos = getpos('.')
  normal! gv
  call cursor(pos[1], pos[2])
endfunction

function! s:pos_lt(pos1, pos2)  " less than
  return a:pos1[1] < a:pos2[1] || a:pos1[1] == a:pos2[1] && a:pos1[2] < a:pos2[2]
endfunction

function! s:pos_eq(pos1, pos2)  " equal
  return a:pos1[1] == a:pos2[1] && a:pos1[2] == a:pos2[2]
endfunction

function! s:move_n()
  if s:onascii()
    let pat = '[^[:print:]]'
  else
    let pat = '[[:print:]]'
  endif
  if search(pat, 'W') > 0
    return
  endif
  call cursor(line('$'), 0)
  call cursor(0, col('$'))
endfunction

function! s:move_p()
  if s:onascii()
    let pat = '[^[:print:]]\+'
  else
    let pat = '[[:print:]]\+'
  endif
  if search(pat, 'bW') > 0
    return
  endif
  call cursor(1, 1)
endfunction

" 現在位置の文字種(ASCIIかマルチバイト)が続いている先頭位置まで戻る
function! s:move_head()
  if s:onascii()
    " TODO: [:print:]でなく[0x00-0xff]にする。CTRL-L等をマルチバイトにしない
    let pat = '[[:print:]]\+'
  else
    let pat = '[^[:print:]]\+'
  endif
  if search(pat, 'bcW') > 0
    return
  endif
  call cursor(1, 1)
endfunction
