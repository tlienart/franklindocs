@def hascode = true
@def hasmath = true

# Markdown syntax

\blurb{JuDoc aims to support most of Common Mark with a few differences and some useful extensions.}

\lineskip

\toc

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

### Comments

You can add comments in your markdown using HTML-style  comments: `<!-- your comment -->` possibly on multiple lines. Note that comments are **not** allowed in a math environment.

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

## Maths

Inserting maths is done pretty much like in LaTeX:

```markdown
Inline: $x=5$ or display:

$$ \mathcal W_\psi[f] = \int_{\mathbb R} f(s)\psi(s)\mathrm{d}s $$
```

Inline: $x=5$ or display:

$$ \mathcal W_\psi[f] = \int_{\mathbb R} f(s)\psi(s)\mathrm{d}s $$

You can  also use `\[...\]` for display maths.

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

\note{In proper LaTeX, the use of `\eqnarray` is discouraged due to possible interference with array column spacing. In JuDoc this does not happen. The only practical difference is that `\eqnarray` will give you a bit more horizontal spacing around the `=` signs.}

One thing to keep in mind when adding maths on your page is that you should be generous in your use of whitespace, particularly  around inequality  operators to avoid ambiguity that could confuse KaTeX.
So for instance prefer: `$0 < C$` to `$0<C$` (which won't render properly).


## HTML

You can inject raw HTML by fencing it with `~~~...~~~` which can be useful.

A simple example is if you want to colour your text; for instance with a `<span style="color:magenta;">...</span>` you would get: some ~~~<span style="color:magenta;">coloured</span>~~~ text.

You could also use this to locally customise a layout etc.

\note{In a raw HTML block, you cannot use markdown, maths, etc. For this reason, it is often preferable to use nested `@@divname...@@` blocks instead of raw HTML since those _can_ have markdown, maths, etc. in them. (See [inserting divs](/pub/syntax/divs-commands.html))}
