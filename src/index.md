@def hascode = true

# Building static websites in Julia

~~~
<span style="font-size:24px;font-weight:300;">JuDoc is a simple and fast static site generator oriented towards technical blogging and light, fast-loading pages.</span>
~~~

## Key features

@@flist
* Augmented markdown allowing definition of LaTeX-like commands,
* Easy inclusion of user-defined div-blocks,
* Maths rendered via [KaTeX](https://katex.org/), code via [highlight.js](https://highlightjs.org) both can be pre-rendered,
* Simple HTML templating,
* Live preview and fast page (re)generation,
* Easy optimisation step to compress and optionally pre-render the website,
* Easy publication step to deploy the website,
* Straightforward integration with [Literate.jl](https://github.com/fredrikekre/Literate.jl).
@@

## Installation

With Julia **≥ 1.1**,

```julia-repl
(v1.3) pkg> add JuDoc
```

### Extras

JuDoc allows a post-processing step to compress HTML and CSS and pre-render code blocks and math environments.
This requires a couple of dependencies:

* [`python3`](https://www.python.org/downloads/) for the minification of the site,
* [`node.js`](https://nodejs.org/en/) for the pre-rendering of KaTeX and code highlighting.

You will then need to install `highlight.js`, which you should do from Julia using the [NodeJS.jl](https://github.com/davidanthoff/NodeJS.jl) package:

```julia-repl
julia> using NodeJS
julia> run(`sudo $(npm_cmd()) install highlight.js`)
```

Assuming you have `python3`, JuDoc will also try to install the python package [`css_html_js_minify`](https://github.com/juancarlospaco/css-html-js-minify) via `pip3`.

If you want to check your installation, do:

```julia-repl
(v1.3) pkg> build JuDoc
julia> using JuDoc
julia> JuDoc.JD_CAN_PRERENDER
true
julia> JuDoc.JD_CAN_HIGHLIGHT
true
julia> JuDoc.JD_CAN_MINIFY
true
```
