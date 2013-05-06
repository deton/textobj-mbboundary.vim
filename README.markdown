mbboundary.vim - ASCII文字とマルチバイト文字の境界を区切りとするtext-object
===========================================================================

mbboundary.vimは、
ASCII文字とマルチバイト文字の境界を区切りとしたtext-objectを
扱えるようにするプラグインです。

日本語文字中の英語のフレーズを扱いやすくする目的で作成しました。

例えば、「VIM は Vi IMproved の略です。」のpにカーソルがある際に、
"Vi IMproved"をtext-objectとして扱う用途を想定。

また、ASCII文字とマルチバイト文字の境界まで移動する`<Plug>`も提供します。

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

* [句読点に移動するmap](https://gist.github.com/deton/5138905#ftr-1)

    f,tを使った「。、」への移動を、`f<C-J>`等にmapしておく設定例
