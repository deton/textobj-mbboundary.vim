mbboundary.vim - ASCII文字とマルチバイト文字の境界を区切りとするtext-object
===========================================================================

mbboundary.vimは、
ASCII文字とマルチバイト文字の境界を区切りとするtext-objectを
扱えるようにするVimプラグインです。

日本語文章中の英語のフレーズを扱いやすくする目的で作成しました。

例えば、「VIM は Vi IMproved の略です。」のpにカーソルがある際に、
"Vi IMproved"をtext-objectとして扱えるようになります。

また、ASCII文字とマルチバイト文字の境界まで移動するキーもmapします。

デフォルトのマッピング
----------------------

* `am` a text-object. カーソル位置の文字の境界までを選択
* `im` inner text-object. カーソル位置の文字の境界までを選択
  (ASCII文字の場合はスペースは除く)
* `gn` 次のASCII文字とマルチバイト文字の境界まで移動
* `gN` 前のASCII文字とマルチバイト文字の境界まで移動

`let g:mbboundary_no_default_key_mappings=1`
と設定すると上記マッピングは行わず、
`<Plug>MBBoundaryTextObjA`等の`<Plug>`のみ登録します。

SEE ALSO
========

その他の、日本語編集関係のtext-objectプラグイン等。

Vimでは、どのtext-objectを使うかをユーザが簡単に選べるので、
様々なtext-objectを用意して選択肢を増やしておくと利便性が高まると思います。

* Vim組み込みの、[`i"`](http://vim-jp.org/vimdoc-ja/motion.html#iquote),
  `i)`, `it`等

    ""や()や`<tag></tag>`にはさまれた文字列を対象とするtext object。

* [textobj-jabraces](http://kana.github.io/config/vim/textobj-jabraces.html)

    日本語のかっこ「」【】等の中の文字列を対象とするtext object。

* [textobj-between](https://github.com/thinca/vim-textobj-between)
  ([記事](http://d.hatena.ne.jp/thinca/20100614/1276448745))

    指定した文字ではさまれた文字列を対象とするtext object。

* [jasegment.vim](https://github.com/deton/jasegment.vim)

    日本語文字上でのWORDを文節単位にして、`iW`を日本語向けにするプラグイン。

    日本語文字上でも、英文のWORDと同様に、
    [空白文字で区切られた文字列を選択するtext objectを定義](https://github.com/deton/jasegment.vim#1-nonblankvim)
    して、`iE`等に登録可能。

* [jasentence.vim](https://github.com/deton/jasentence.vim)

    日本語句読点"、。"をsentenceの終わりとみなして、
    `is`を日本語向けにするプラグイン。
