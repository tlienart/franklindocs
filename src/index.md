@def hascode = true

# Building static websites in Julia

\blurb{JuDoc is a simple and fast static site generator oriented towards technical blogging and light, fast-loading pages.}

## Key features

@@flist
* Augmented markdown allowing definition of LaTeX-like commands,
* Easy inclusion of user-defined div-blocks,
* Maths rendered via [KaTeX](https://katex.org/), code via [highlight.js](https://highlightjs.org) both can be pre-rendered,
* Can live-evaluate Julia code blocks,
* Simple HTML templating,
* Live preview of modifications,
* Easy optimisation step to compress and optionally pre-render the website,
* Easy publication step to deploy the website,
* Straightforward integration with [Literate.jl](https://github.com/fredrikekre/Literate.jl).
@@

## Quick start

To install JuDoc with Julia **≥ 1.1**,

```julia-repl
(v1.3) pkg> add JuDoc
```

You can then just try JuDoc out:

```julia-repl
julia> using JuDoc
julia> newsite("mySite", template="pure-sm")
✓ Website folder generated at "mySite" (now the current directory).
→ Use serve() from JuDoc to see the website in your browser.

julia> serve()
→ Initial full pass...
→ Starting the server...
✓ LiveServer listening on http://localhost:8000/ ...
  (use CTRL+C to shut down)
```

If you navigate to the given URL in your browser, you will be the website being live-rendered.

Now open `src/index.md` in an  editor and follow the examples, modifying at will, the changes will be live rendered in your browser.
You can then also inspect the file `src/pages/menu1.md` which offers more examples of what JuDoc can do.

## Installing optional extras

JuDoc allows a post-processing step to compress HTML and CSS and pre-render code blocks and math environments.
This requires a couple of dependencies:

* [`python3`](https://www.python.org/downloads/) for the minification of the site,
* [`node.js`](https://nodejs.org/en/) for the pre-rendering of KaTeX and code highlighting.

You will then need to install `highlight.js`, which you should do from Julia using the [NodeJS.jl](https://github.com/davidanthoff/NodeJS.jl) package:

```julia-repl
julia> using NodeJS
julia> run(`sudo $(npm_cmd()) install highlight.js`)
```

Assuming you have `python3`, JuDoc will try to install the python package [`css_html_js_minify`](https://github.com/juancarlospaco/css-html-js-minify) via `pip3`.
