@def hascode=false

<!--
reviewed: 20/12/19
-->

# FAQ

## Why bother with yet another SSG?

There is a [multitude of static site generators](https://www.staticgen.com/) out there... is this one worth your time?

I didn't start working on JuDoc hoping to "beat" mature and sophisticated generators like Hugo or Jekyll.
Rather, I had been using Jacob Mattingley's much simpler [Jemdoc](http://jemdoc.jaboc.net/using.html) package in Python with Wonseok Shin's [neat extension](https://github.com/wsshin/jemdoc_mathjax) for MathJax support.

I liked that Jemdoc+Mathjax was simple to use and didn't require a lot of web-dev skills to get going.
That's how I got the idea of doing something similar in Julia, hopefully improving on the few things I didn't like such as the lack of support for live-rendering preview or the speed of page generation.

That being said, if you just want a blogging generator mostly for text and pictures, then JuDoc may not be the tool for you.
If you want to host a technical blog with maths, code blocks, and would like some easy and reproducible control over elements, then JuDoc could help you (feel free to [open an issue](https://github.com/tlienart/JuDoc.jl/issues/new) to see if JuDoc is right for you).

### Why not Pandoc?

[Pandoc](https://pandoc.org/) is a very different beast.
JuDoc's aim was never to provide a full-fledged LaTeX to HTML conversion (which Pandoc does).
Rather, JuDoc supports standard markdown **and** the definition of commands following a LaTeX-like syntax.
These commands can make the use of repeated elements in your website significantly easier to use and maintain.

Further, Pandoc does not deal with the generation of a full website with things like live-previews, code evaluation etc.

### Why write a markdown parser?

I suspect many computer scientists or similar types will agree that _parsing_ is an interesting topic.
JuDoc provided an incentive to think hard about how to parse extended markdown efficiently and while I'd definitely not dare to say that the parser is very good, it does a decent job and I learned a lot coding it.

In particular, processing LaTeX-like commands which can be re-defined and should be resolved recursively, proved pretty interesting (and sometimes a bit tricky).  

Initially JuDoc was heavily reliant upon the Julia `Markdown` package (part of the `stdlib`) which can convert markdown to HTML but, over time, this changed as JuDoc gained the capacity to parse a broader set of Markdown as well as extensions.

### Did you know?

Judoc is a [fairly obscure saint](https://en.wikipedia.org/wiki/Judoc). (I definitely did not know that before registering the package, but it did inspire me for the logo.)
