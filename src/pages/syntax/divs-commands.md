@def hascode = true
@def hasmath = true

# Divs and Commands

\blurb{Style your content quickly and easily with custom divs, make everything reproducible and maintainable with commands.}

\lineskip

\toc

## Divs

## LaTeX-like commands

JuDoc allows the definition of commands using a LaTeX-like syntax.
This can be particularly useful for repeating elements inside or outside of maths environment.

To define a command, you **must** use the following syntax:

```markdown
\newcommand{\name}[...]{...}
             -1-   -2-  -3-
```

where

@@flist
1. the first bracket is the command name, starting with a backslash,
1. the second (optional) bracket indicates the number of arguments,
1. the third bracket indicates the definition of the command calling `#k` to insert the $k$-th argument.
@@

As in LaTeX, command definitions can be anywhere as long as they appear before they are used.
If you want a command to be available on all your pages, put the definition in the `config.md` file.

### Math examples

If you end up writing a lot of equations on your site, defining commands quickly becomes very useful:

```plaintext
\newcommand{\R}{\mathbb R}
Let $f:\R\to\R$ a function...
```

\newcommand{\R}{\mathbb R}
Let $f:\R\to\R$ a function...

```plaintext
\newcommand{\scal}[1]{\left\langle #1 \right\rangle}
$$ \mathcal W_\psi[f] = \int_\R f(s)\psi(s)\mathrm{d}s = \scal{f,\psi} $$
```

\newcommand{\scal}[1]{\left\langle #1 \right\rangle}
$$ \mathcal W_\psi[f] = \int_\R f(s)\psi(s)\mathrm{d}s = \scal{f,\psi} $$

### Text examples

Commands can also be very useful outside of maths environment.
For instance, you could define a command to quickly set the style of some text:

```plaintext
\newcommand{\styletext}[2]{~~~<span style="#1">#2</span>~~~}
\styletext{color:tomato;font-size:14px;}{some text}
```
\newcommand{\styletext}[2]{~~~<span style="#1">#2</span>~~~}
\styletext{color:tomato;font-size:14px;font-variant:small-caps;}{some text}

### Nesting examples

Commands are resolved recursively which means that they can be nested and their definition can contain further JuDoc markdown.

Let's start with a simple example:

```plaintext
\newcommand{\norm}[2]{\left\|#1\right\|_{#2}}
\newcommand{\anorm}[1]{\norm{#1}{1}}
\newcommand{\bnorm}[1]{\norm{#1}{2}}

Let $x\in\R^n$, there exists $0 < C_1 \le C_2$ such that

$$ C_1 \anorm{x} \le \bnorm{x} \le C_2\anorm{x}. $$
```

\newcommand{\norm}[2]{\left\|#1\right\|_{#2}} <!--_-->
\newcommand{\anorm}[1]{\norm{#1}{1}}
\newcommand{\bnorm}[1]{\norm{#1}{2}}

Let $x\in\R^n$, there exists $0 < C_1 \le C_2$ such that

$$ C_1 \anorm{x} \le \bnorm{x} \le C_2\anorm{x}. $$

As indicated earlier, commands can contain further JuDoc markdown that is processed recursively.
Consider for instance this slightly more sophisticated example of a "definition" command such that this:

```plaintext
\definition{angle between vectors}{
Let $x, y \in \R^n$ and let $\scal{\cdot, \cdot}$ denote
the usual inner product. Then, the angle $\theta$ between $x$ and $y$ is
given by $$ \cos(\theta) = {\scal{x,y}\over \scal{x,x} \scal{y,y}}. $$}
```

leads to this:

\newcommand{\definition}[2]{@@definition **Definition**: (_!#1_) #2 @@}

\definition{angle between vectors}{
Let $x, y \in \R^n$ and let $\scal{\cdot, \cdot}$ denote
the usual inner product. Then, the angle $\theta$ between $x$ and $y$ is
given by $$ \cos(\theta) = {\scal{x,y}\over \scal{x,x} \scal{y,y}}. $$}

To do this, you need to define the command:

```plaintext
\newcommand{\definition}[2]{@@definition **Definition**: (_!#1_) #2 @@}
```

and specify the styling of the `definition` div in your CSS:

```css
.definition {
  background-color: aliceblue;
  border-left: 5px solid cornflowerblue;
  border-radius: 10px;
  padding: 10px;
  margin-bottom: 1em;
}
```

### Whitespaces

In a JuDoc `newcommand`, to refer to an argument you can use `#k` or `!#k`.
There is a subtle difference:

- the first one introduces a space left of the argument,
- the second one does not.

In general whitespaces are irrelevant and will not show up so that the usual `#k` is the recommended default setting.
This avoids some ambiguities when solving a chain of nested commands.

There are however cases where you do not want this because the whitespace does, in fact, show up.
In such cases use `!#k`.

For instance:

```plaintext
\newcommand{\pathwith}[1]{`/usr/local/bin/#1`}
\newcommand{\pathwithout}[1]{`/usr/local/bin/!#1`}

Here \pathwith{hello} is no good whereas \pathwithout{hello} is.
```

\newcommand{\pathwith}[1]{`/usr/local/bin/#1`}
\newcommand{\pathwithout}[1]{`/usr/local/bin/!#1`}

Here \pathwith{hello} is no good whereas \pathwithout{hello} is.

## Hyper-references

Three types of hyper-references are supported in JuDoc:

@@flist
* for equations in display mode,
* for bibliography entries,
* for specific anchor points in the page.
@@

The syntax for all three is close to that of standard LaTeX.

### Labelling and referencing equations



### Labelling and referencing bib entries

### Labelling and referencing anchors
