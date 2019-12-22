@def hascode=true
@def maxtoclevel=3

# FAQ - Technical

If you have a question that you couldn't find an answer to easily, don't hesitate to [open an issue](https://github.com/tlienart/JuDoc.jl/issues/new) on GitHub, it will help me make this section more complete!

\toc

## Styling

### Can you style footnote text?

**Reference**: [issue 243](https://github.com/tlienart/JuDoc.jl/issues/243), **more on this**: [styling](/pub/styling/classes.html).

For the reference basically a footnote is inserted as

\esch{footnote_1}{<sup id="fnref:1"><a href="/pub/menu1.html#fndef:1" class="fnref">[1]</a></sup>}

So you can style that with the class `.jd_content sup a.fnref`.

For definitions, it's inserted as a table like:

\esch{footnote_2}{
<table class="fndef" id="fndef:blah">
    <tr>
        <td class="fndef-backref"><a href="/pub/menu1.html#fnref:blah">[2]</a></td>
        <td class="fndef-content">this is another footnote</td>
    </tr>
</table>
}

so you can style the back-reference via the `.jd-content fndef td.fndef-backref` and the text of the definition via `.jd-content fndef td.fndef-content`; for instance, consider the following base styling:

```css
.jd-content table.fndef  {
    margin: 0;
    margin-bottom: 10px;}
.jd-content .fndef tr, td {
    padding: 0;
    border: 0;
    text-align: left;}
.jd-content .fndef tr {
    border-left: 2px solid lightgray;
    }
.jd-content .fndef td.fndef-backref {
    vertical-align: top;
    font-size: 70%;
    padding-left: 5px;}
.jd-content .fndef td.fndef-content {
    font-size: 80%;
    padding-left: 10px;}
```

## Code

### How to use loops for templating?

**Reference**: [issue 251](https://github.com/tlienart/JuDoc.jl/issues/251), **more on this**: [styling](/pub/code/eval-tricks.html).

Since you can show the output of any Julia code block (and interpret that output as JuDoc markdown), you can use this to help with templating.
For instance:

`````md
```julia:./ex
#hideall
for name in ("Shinzo", "Donald", "Angela", "Christine")
    println("""
    @@card
    ### $name
    ![]("$(lowercase(name)).jpg")
    @@
    """)
end
```
\textoutput{./ex}
`````

Generates

\esch{for_1}{
<div class="card"><h3 id="shinzo"><a href="/index.html#shinzo">Shinzo</a></h3>  <img src="shinzo.jpg" alt="" /></div>
<div class="card"><h3 id="donald"><a href="/index.html#donald">Donald</a></h3>  <img src="donald.jpg" alt="" /></div>
<div class="card"><h3 id="angela"><a href="/index.html#angela">Angela</a></h3>  <img src="angela.jpg" alt="" /></div>
<div class="card"><h3 id="christine"><a href="/index.html#christine">Christine</a></h3>  <img src="christine.jpg" alt="" /></div>
}

### How to show HTML code?

In order to show HTML code like:

\esch{html_1}{
    <div class="hello">example</div>
}

you will need to _escape_ it, otherwise the HTML will be interpreted (even though it's in a `<pre><code>` block).
One way to do this is to use Julia's Markdown `htmlesc` function on the HTML string and show the output of that function.
The command below does all that for you:

`````julia
\newcommand{\esch}[2]{
    ```julia:esc__!#1
    #hideall
    using Markdown
    println("\`\`\`\`\`html $(Markdown.htmlesc(raw"""#2""")) \`\`\`\`\`")
    ```
    \textoutput{esc__!#1}
}
`````

What it does is: create a small Julia code block which is hidden, run a `htmlesc` on the string, and show the output.
Note that you **must** give a name to the block so that it doesn't clash with other such blocks on the page.
So, for instance, the code earlier was written:

\esc{html_1b}{
    \esch{html_1}{
        <div class="hello">example</div>
    }
}

and what's effectively put in the page HTML is

\esc{html_1c}{
    <pre><code class="language-html">&lt;div class&#61;&quot;hello&quot;&gt;example&lt;/div&gt;</code></pre>
}
