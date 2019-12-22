<!--
.jd_cntent
.jd_toc
.fn*
...
 -->

<!--
reviewed: 22/12/19
-->

@def hascode = true

# Classes

\blurb{Use JuDoc's classes or add your own.}

\lineskip

By now you know that you can add `@@divname ... @@` anywhere you want in your content in order to define an environment and style it.
Below we detail the default classes as well as some tricks that can be useful to style  your content.

## JuDoc's classes

@@lalignb
| Name | Function |
| ------ | ---- |
| `jd-content` | wraps around the content of a page, so when a `mypage.md` is converted to some html, it gets inserted in the scaffolding as `<div class="jd-content"> some html </div>`
| `jd-toc` | wraps around the inserted table of contents
| `fnref` | wraps around a footnote reference
| `fndef` | wraps around footnote definitions
| `fndef-content` | wraps around the content of footnote definitions
| `fndef-backref` | wraps around the back-reference of a footnote definition
@@

## Simple tricks

As soon as you're using a style more than once, it makes sense to create it as a command.
This makes it much easier to maintain and re-use.
For instance, consider the following simple examples:

\esch{c1}{
    \newcommand{\blurb}[1]{
        ~~~
        <span style="font-size:24px;font-weight:300;">!#1</span>
        ~~~
    }
}

\esch{c2}{
    \newcommand{\note}[1]{@@note @@title ⚠ Note@@ @@content #1 @@ @@}
}

Further, you can pass the style as an argument:

\newcommand{\spstyle}[2]{~~~<span style="#1">#2</span>~~~}

\esch{c3}{
    \newcommand{\spstyle}[2]{~~~<span style="#1">#2</span>~~~}
}

and for instance:

\esch{c4}{
    \spstyle{font-variant:small-caps;font-size:15px;color:cornflowerblue}{formatted text}
}

gives you: \spstyle{font-variant:small-caps;font-size:15px;color:cornflowerblue}{formatted text}.
