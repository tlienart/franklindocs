@def hascode = true
@def hasmath = true
@def showall = true

<!--
reviewed: 23/11/19
-->

# Markdown syntax

\blurb{JuDoc aims to support most of Common Mark with a few differences and some useful extensions.}

\lineskip

\toc

## Experimenting

Beyond directly experimenting in a project folder, you  can also explore what HTML is generated with the `jd2html` function:

```julia-repl
julia> """Set `x` to 1, see [the docs](http://example.com).""" |> jd2html
"&lt;p&gt;Set &lt;code&gt;x&lt;/code&gt; to 1, see &lt;a href&#61;&quot;http://example.com&quot;&gt;the docs&lt;/a&gt;.&lt;/p&gt;\n"
```

## Basics

If you're already familiar with Markdown, you can skip this section, though it may serve as a useful reminder.

### Headers

```markdown
# Level 1
## Level 2
...
###### Level 6
```

will generate the various header levels.

\note{JuDoc makes headers into links to help with internal links and automatic table of contents (which you can include anywhere using `\toc`).}

### Text styling

```plaintext
**Bold text**, *italic* or _italic_, **_bold italic_**, `inline code`.
```

Inserting a horizontal rule can be done with

```markdown
---
```

For a blockquote, start the line with `>`:

```markdown
> This is a blockquote

```

### Links

```markdown
inline links: [plain link](https:://www.wikipedia.org)

reference links: ["reference" link][reflink] and ["reference" link][]

[reflink]: https://www.wikipedia.org
["reference" link]: https://www.wikipedia.org
```

Footnotes follow a similar syntax

```markdown
This has a footnote[^1]

[^1]: footnote definition
```

For images, just add an exclamation mark `!`:

```markdown
inline: ![alt text](https://juliacon.org/2018/assets/img/julia-logo-dots.png)

reference: ![alt text][ref]

[ref]: https://juliacon.org/2018/assets/img/julia-logo-dots.png
```

**Notes**:

@@tlist
* (**link reference**) when using "indirect links" i.e. in the text you use something like `[link name][link A]` and then somewhere else you define `[link A]: some/url/`, we recommend you use unambiguous link identifiers (here `[link A]`). We recommend you to not use numbers like `[link name][1]`, indeed if on the page you have some code where `[1]` appears, there is an ambiguity for the parser,
* (**link title**) are currently _not supported_ e.g. something like `[link A](some/url/ "link title")`,
* (**suppress links**) if, for some reason, you want to have something like `[...]: ...` somewhere on your page that does _not_ define a link, then you need to toggle ref-links off (`@def reflinks = false`) and only use inline links `[link name](some/url/)`.
@@

### Lists

Un-ordered list (you can  also use `-`, `+` or `.` instead  of `*`)

```markdown
* item 1
* item 2
  * sub-item 1
```

Ordered list (the proper numbering is done automatically)

```markdown
1. item 1
1. item 2
  1. subitem 1
```

\note{List items _must_ be on the same line (_this is due to [a limitation](https://github.com/JuliaLang/julia/issues/30198) of the Julia Markdown parser_).}

### Comments

You can add comments in your markdown using HTML-style  comments: `<!-- your comment -->` possibly on multiple lines. Note that comments are **not** allowed in a math environment.

### Symbols and HTML entities

Outside code environments, there are a few quirks in dealing with symbols:

@@tlist
* (**dollar sign**) to introduce a dollar sign, you _must_ escape it with a backslash: `\$` as it is otherwise used to open and close inline math blocks,
* (**HTML entity**) you can use HTML entities without issues like `&rarr;` for "→" or `&#36;` for "\$",
* (**backslash**) to introduce a backslash, you can just use ~~~<code>\</code>~~~, while a _double backslash_ ~~~<code>\\</code>~~~ can be used to specify a _line break_ in text.
@@

## Table of contents

JuDoc can insert an automatically generated table of contents simply by using `\toc` or `\tableofcontents` somewhere appropriate in your markdown.
The table of contents will be generated in a `jd-toc` div block, so if you would like to modify the styling, you should modify `.jd-toc ol`, `.jd-toc li` etc in your CSS.

You can specify the minimum and maximum header level to control the table of contents nesting using `@def mintoclevel=2` and `@def maxtoclevel=3` where, here, it would build a table of contents with the `h2` and `h3` headers only (this is the setting used here for instance).

## Code

Inline code with single and double back-ticks

```markdown
Single back-ticks: `var = 5`, and
double back-ticks if the code includes ticks: ``var = "`"``.
```

Blocks of code with triple back-ticks and the language specifier

`````markdown
```julia
a = 5
println(a)
```
`````

You're not obliged to specify the language, if you don't it will assume the language corresponds to the page variable `lang` (set to `julia` by default).
If you want the block to be considered as plaintext, use  `plaintext` as the language specifier.

Finally you can also use indented code blocks (which will also take its highlighting hint from `lang`):

```markdown
Code block:

    a = 5
    println(a)

```

### Highlighting

Syntax highlighting is done via [highlight.js](https://highlightjs.org/) and you can find the relevant script in the  `libs/highlight/` folder.
The default one supports highlighting for Bash, CSS, Ini, Julia, Julia-repl, Markdown, plaintext, Python, R, Ruby, Xml and Yaml.
Note that if you use pre-rendering, then the full `highlight.js` is used with support for over 100 languages.

By default unfenced code blocks (e.g. indented code blocks) will be highlighted as Julia code blocks; to change this, set `@def lang = "python"`.
If you want a code block to _not_ be highlighted, we recommend you use `plaintext` to guarantee this:

`````markdown
```plaintext
this will not be highlighted
```
`````

If you wish to have higlighting for more languages outside of the pre-rendering mode, head to [highlight.js](https://highlightjs.org/), make a selection of languages and place the resulting `higlight.pack.js` in the `/libs/highlight/` folder.
If you do this, you might want to slightly modify it to ensure that the Julia-repl mode is properly highlighted (e.g. `shell>`):

@@tlist
* open the  `highlight.pack.js` in an editor of your choice
* look for `hljs.registerLanguage("julia-repl"` and modify the entry to:
@@

```plaintext
hljs.registerLanguage("julia-repl",function(a){return{c:[{cN:"meta",b:/^julia>/,r:10,starts:{e:/^(?![ ]{6})/,sL:"julia"}},{cN:"metas",b:/^shell>/,r:10,starts:{e:/^(?![ ]{6})/,sL:"bash"}},{cN:"metap",b:/^\(.*\)\spkg>/,r:10,starts:{e:/^(?![ ]{6})/,sL:"julia"}}]}});
```

### Evaluated code blocks

Julia code blocks can be evaluated and the result of the code either shown or rendered.
To declare a code block for evaluation, use the fenced code block syntax with a name for the code block:

`````markdown
```julia:snippet1
using LinearAlgebra, Random
Random.seed!(555)
a = randn(5)
round(norm(a), sigdigits=4)
```

\output{snippet1}
`````

This will look like

```julia:snippet1
using LinearAlgebra, Random
Random.seed!(555)
a = randn(5)
round(norm(a), sigdigits=4)
```

\output{snippet1}

For more information on using evaluated code blocks, please head to the [code section](/pub/code/inserting-code.html) of the manual.

## Maths

### Inline and display maths

Inserting maths is done pretty much like in LaTeX:

```markdown
Inline: $x=5$ or display:

$$ \mathcal W_\psi[f] = \int_{\mathbb R} f(s)\psi(s)\mathrm{d}s $$
```

Inline: $x=5$ or display:

$$ \mathcal W_\psi[f] = \int_{\mathbb R} f(s)\psi(s)\mathrm{d}s $$

You can  also use `\[...\]` for display maths.

One thing to keep in mind when adding maths on your page is that you should be generous in your use of whitespace, particularly  around inequality  operators to avoid ambiguity that could confuse KaTeX.
So for instance prefer: `$0 < C$` to `$0<C$` (the latter will not render properly).


### Aligned maths

For aligned environment you can use `\begin{eqnarray}...\end{eqnarray}` or `\begin{align}...\end{align}`

```markdown
\begin{eqnarray}
  \exp(i\pi)+1 &=& 0\\
  1+1 &=& 2
\end{eqnarray}

\begin{align}
  \exp(i\pi)+1 &= 0\\
  1+1 &= 2
\end{align}
```

\begin{eqnarray}
  \exp(i\pi)+1 &=& 0\\
  1+1 &=& 2
\end{eqnarray}

\begin{align}
  \exp(i\pi)+1 &= 0\\
  1+1 &= 2
\end{align}

\note{In proper LaTeX, the use of `\eqnarray` is discouraged due to possible interference with array column spacing. In JuDoc this does not happen and so the only practical difference is that `\eqnarray` will give you a bit more horizontal spacing around the `=` signs.}

## Raw HTML

You can inject raw HTML by fencing it with `~~~...~~~` which can be useful for custom formatting.

A simple example is if you want to colour your text; for instance with a `<span style="color:magenta;">...</span>` you would get: some ~~~<span style="color:magenta;">coloured</span>~~~ text.

You could also use this to locally customise a layout etc.

\note{Inside a raw HTML block, you cannot use markdown, maths, etc. For this reason, it is often preferable to use nested `@@divname...@@` blocks instead of raw HTML since those _can_ have markdown, maths, etc. in them. (See [inserting divs](/pub/syntax/divs-commands.html).)}
