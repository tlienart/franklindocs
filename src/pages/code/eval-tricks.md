<!-- TODO: figure out how to block the SVG code in the code block to be evaluated by the browser
this must be simple to  do but requires internet to check...-->

@def hascode=true

# Tricks with code evaluation

\blurb{JuDoc's recursive nature coupled with code evaluation allows for neat and useful tricks.}

\lineskip

\toc

## Examples

The basic idea is to exploit the fact that the output of a Julia code block evaluated by JuDoc can be re-processed as JuDoc Markdow when using the `\textoutput` command; this offers a wide range of possibilities best shown through a few examples.


### Generating a table

```julia:table
#hideall
names = (:Bob, :Alice, :Maria, :Arvind, :Jose, :Minjie)
numbers = (1525, 5134, 4214, 9019, 8918, 5757)
println("Name | Number")
println("--- | ---")
println.("$name | $number" for (name, number) in zip(names, numbers))
```

\textoutput{table}

That can be obtained with:

`````plaintext
```julia:table
#hideall
names = (:Bob, :Alice, :Maria, :Arvind, :Jose, :Minjie)
numbers = (1525, 5134, 4214, 9019, 8918, 5757)
println("Name | Number")
println("--- | ---")
println.("$name | $number" for (name, number) in zip(names, numbers))
```

\textoutput{table}
`````

The code block will be executed and not shown (`#hideall`) generating a table line by line.
In practice, the code generates the markdown

```markdown
Name | Number
--- | ---
Bob | 1525
...
Minjie | 5757
```

which is captured and reprocessed by the `\textoutput` command.

### Team cards

### Colourful circles

The trick can be used to generate SVG code too:

\newcommand{\circle}[1]{~~~<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 4"><circle cx="2" cy="2" r="1.5" fill="#1"/></svg>~~~}

```julia:circles
#hideall
colors=(:pink, :lightpink, :hotpink, :deeppink,
        :mediumvioletred, :palevioletred,
        :coral, :tomato, :orangered, :darkorange,
        :orange, :gold, :yellow)
print("@@colors ")
print.("\\circle{$c}" for c in colors)
println("@@")
```

\textoutput{circles}

That can obtained with (see detailed explanations further below)

\esc{\newcommand{\circle}[1]{
  ~~~
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 4">
  <circle cx="2" cy="2" r="1.5" fill="#1"/></svg>
  ~~~
  }
}

<!-- \esc{


```julia:snippet
#hideall
colors=(:pink, :lightpink, :hotpink, :deeppink,
        :mediumvioletred, :palevioletred,
        :coral, :tomato, :orangered, :darkorange,
        :orange, :gold, :yellow)
print("@@colors ")
print.("\\circle{$c}" for c in colors)
println("@@")
```

\textoutput{snippet}
} -->

The first part defines a command `\circle` which takes one argument for the fill colour and inserts SVG code for a circle with that colour.

The second part is a Julia code block which will be evaluated but not displayed on the page (since there is a `#hideall`).
The code loops over the each colour `c` and prints `\circle{c}` so that the code block effectively generates:

```plaintext
@@colors \circle{pink}...\circle{yellow}@@
```

this output is then captured and reprocessed with the `\textoutput{snippet}` command.

The last thing to do is to style the `colors` div appropriately:

```css
.colors {
  margin-top:1.5em;
  margin-bottom:1.5em;
  margin-left:auto;
  margin-right:auto;
  width: 60%;
  text-align: center;}
.colors svg {
  width:30px;}
```
