@def hascode=true

# Page variables

<!--
reviewed: 🔺
-->

\blurb{Page variables offer a straightforward way to interact with the HTML templating from the markdown.}

\lineskip

\toc

## Overview

The general syntax to define a page variable is to write `@def varname = value` on a new line e.g.:

```
@def author = "Septimia Zenobia"
```

where you could set the variable to a string, a number, a date, ... as long as it's on a single line.
These variables can serve multiple purposes but, primarily, they can be accessed from the HTML template via things like

\esch{footex}{
  <footer>
    This is the footer. &copy; {{fill author}}.
  </footer>
}

where `{{ ... }}` indicates a HTML _function_, `fill` is the function name and the rest of the bracket elements are the arguments of the function (here `author`) which are page variables.

_Local_ page variables the variables that are defined on a single page and accessible on that page only by contrast to _global_ page variables which are set globally (in the `config.md` file) and accessible on all pages.

In both cases there are _default_ page variables with default values which you can change and use.
You can also define your own variables.

### Using page variables

Both local and global page variables are meant for essentially two purposes:

@@flist
1. allow the HTML template to be controlled from the markdown,
1. modify how JuDoc generates HTML.
@@

The second one is a bit less prevalent but, for instance, you can specify the default programming language for all code blocks so that code blocks that don't specify a language would use the default language for highlighting:

```
@def lang = "julia"
```

In the first case, you can access variables in your HTML template via one of the HTML functions such as the `fill` function shown above.

## HTML functions

HTML functions can be used in any one of your `src/_html_parts/*.html` files such as `head.html` (most likely).

### Basic functions

Functions are always called with the syntax `{{fname pv1 pv2 ...}}` where `pv1 pv2 ...` are page variable names.
A few functions are available with the `{{fill ...}}` arguably the most likely to be of use.

@@lalign
| Format | Role |
| ------ | ---- |
| `{{fill vname}}` | place the value of page variable `vname`
| `{{insert fpath}}` | insert the content of the file at `fpath`
| `{{href  vname}}` | inserts a reference (_mostly internal use_)
| `{{toc}}` | places a table of content (_mostly internal use_)
@@

### Conditional blocks

Conditional blocks allow to specify which parts of the HTML template should be active depending on the value of some page variable.
The format follows this structure:

\esc{condblock}{
{{if vname}}
...
{{elseif vname2}}
...
{{else}}
...
{{end}}
}

where `vname` and `vname2` are expected to be page variable evaluating to a boolean.
Of course you don't have to specify the `{{elseif ...}}` or `{{else}}`.

For instance, you may want to include specific pieces of the HTML scaffolding depending on page variables. In your `index.html` you could have

\esc{condblock2}{
{{if hasmath}} {{insert head_katex.html}} {{end}}
}

where in the markdown of a specific page you would have

```
@def hasmath = true
```

Additionally, you can also use some dedicated conditional blocks:

@@lalign
| Format | Role |
| ------ | ---- |
| `{{ispage path/to/page}}` | whether the current page corresponds to the path
| `{{isnotpage path/to/page}}` | opposite of previous
| `{{isdef vname}}` | whether `vname` is defined
| `{{isnotdef vname}}` | opposite of previous
@@

The `{{ispage ...}}` and `{{isnotpage ...}}` accept a joker syntax such as `{{ispage pub/maths/*}}`.

As an example, this is useful if you want to highlight a menu item when you are on a subpage of that item.
This is used for the navbar of this very page in fact where the (simplified) HTML looks like:

\esch{exispage}{
  <li class="{{ispage pub/syntax/*}}active{{end}}">• Syntax
  <ul>
    <!-- ... -->
    <li class="{{ispage pub/syntax/page-variables}}active{{end}}">Page Variables
    <!-- ... -->
  </ul>
} <!--*-->

This allows a javascript-free way of having a menu that depends on which page is currently active.


## Local page variables



## Global page variables


and config



<!-- ## Page variables

Page variables are a way to interact with the HTML templating.
In essence, you can define variables in the markdown which can then be called or used in the HTML building blocks that are in `src/_html_parts/`.

!!! note

    Page variables are still somewhat rudimentary and while the syntax for declaring a variable will likely not change, the way they are used will almost certainly be refined in the future (see also [Templating](@ref)). -->

<!-- ### Local page variables

The syntax to define a page variable in markdown is to write on a new line:

```judoc
@def variable_name = ...
```

where whatever is after the `=` sign should be a valid Julia expression (Julia will try to parse it and will throw an error if it can't).
Multiline definitions are not (yet) allowed but if you have a need for that, please open an issue.
The idea is that these variables are likely to be rather simple: strings, bools, ints, dates, ...
I don't yet see a usecase for more involved things.

Once such a variable is defined you can use it with the templating syntax (see [Templating](@ref)).
For instance in your `src/index.md` you could have

```judoc
@def contributors = "Chuck Norris"
```

and in your `src/_html_parts/head.html` you could have

```html
{{isdef contributors}}
This page was written with the help of {{fill contributors}}
{{end}}
```

since `contributors` is a _local page variable_ that is defined in `src/index.md`, the corresponding `index.html` will show "_This page was written with the help of Chuck Norris_"; however on any other page, this will not show (unless, again, you define `@def contributors = ...` there).
See also [Templating](@ref) for how page variables can be used in the HTML.

#### Default variables

A few variables are already present and used in the basic templates (you can still modify their value though it has to match the type):

| Name      | Accepted types | Default value | Function |
| :-------- | :------------- | :------------ | :------- |
| `title`   | `Nothing`, `String` | `nothing` | title of the page (tab name)
| `hasmath` | `Bool` | `true` | if `true` the KaTeX stylesheet and script will be added to the page
| `hascode` | `Bool` | `false` | if `false` the highlight stylesheet and script will be added to the page
| `date`    | `String`, `Date`, `Nothing` | `Date(1)` | a date variable
| `lang`    | `String` | `"julia"` | the default language to use for code blocks
| `reflinks`| `Bool` | `true` | whether there may be referred links like like `[link][id]` and `[id]: some/url`, turn this to false if your code has patterns like `[...]: ...` which are **not** link definitions (see also [quirks](#Quirks-1))

Then there are some variables that are automatically assigned and that you should therefore **not** assign  yourself (but you can use them):

| Name | Type | Value | Function |
| :--- | :------------- | :------------ | :------- |
| `jd_ctime` | `Date` | `stat(file).ctime` | page creation date
| `jd_mtime` | `Date` | `stat(file).mtime` | last page modification date


### Global page variables

You can also define _global page variables_ by simply putting the definition in the `src/config.md` file.
For instance you may want to have a single main author across all pages and would then write

```judoc
@def author = "Septimia Zenobia"
```

in the `src/config.md` file.

You can overwrite global variables in any page by redefining it locally.
For instance you could set `hasmath` globally to `false` and `hascode` globally to `true` and then modify it locally as appropriate.

There are also a few pre-defined global variables:

| Name          | Accepted types | Default value | Function |
| :------------ | :------------- | :------------ | :------- |
| `author`      | `String`, `Nothing` | `THE AUTHOR` | author (e.g. may appear in footer)
| `date_format` | `String` | `U dd, yyyy` | a valid date format specifier
| `prepath`     | `String` | "" | if the website is meant to be a _project_ website on GitHub for instance corresponding to a repo `github.com/username/repo` as opposed to `github.com/username.github.io`, then all url paths should be prepended with `repo/` which you can do by specifying `@def prepath = "repo"` (see also [hosting the website as a project website](/man/workflow/#Hosting-the-website-as-a-project-website-1))| -->
