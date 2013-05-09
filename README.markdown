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
と設定すると上記マッピングは行いません。

関連
====

* [textobj-nonblankchars.vim](https://github.com/deton/textobj-nonblankchars.vim)

    日本語文字上でも、英文のWORDと同様に、
    空白文字で区切られた文字列を選択するtext-object

* [jasegment.vim](https://github.com/deton/jasegment.vim)

    日本語文章でのWORD移動(W,E,B)を文節単位にするスクリプト

* [jasentence.vim](https://github.com/deton/jasentence.vim)

    `)`,`(`キーによるsentence移動時に日本語句読点"、。"も
    文の終わりとみなすスクリプト
