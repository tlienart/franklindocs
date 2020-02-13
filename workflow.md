@def hascode = true

<!--
reviewed: 22/12/19
-->

# Working with Franklin

\blurb{Set things up in minutes and focus on writing great content.}

\lineskip

\toc

## Creating your website

To get started, the easiest is to use the `newsite` function to generate a website folder which you can then modify to your heart's content.
The command takes one mandatory argument: the _name_ of the folder.
You can optionally specify a template:

```julia-repl
julia> newsite("TestWebsite"; template="vela")
✓ Website folder generated at "TestWebsite" (now the current directory).
→ Use serve() from Franklin to see the website in your browser.
```

There are a number of [simple templates](https://tlienart.github.io/FranklinTemplates.jl/) you can choose from and tweak.

\note{The templates are meant to be used as _starting points_ and will likely require some fixes to match what you want. Your help to make them better is very welcome.}

Once you have created a new website folder, you can start the live-rendering of your website with

```julia-repl
julia> serve()
→ Initial full pass...
→ Starting the server...
✓ LiveServer listening on http://localhost:8000/ ...
  (use CTRL+C to shut down)
```

and navigate in a browser to the corresponding address to preview the website.

### Folder structure

The initial call to `newsite` generates a folder with the following structure:

```plaintext
.
├── _assets/
├── _layout/
├── _libs/
├── _layout/
├── config.md
└── index.md
```

After running `serve` the first time, an additional folder is generated: `__site` which will contain your full generated website.
Among these folders:

@@tlist
* the files in the top folder such as `index.md` are the source files for the generated pages, you must have an `index.md` or `index.html` at the top level but can then use whatever folder structure you want (see further),
* you should **not** modify the content of `__site` as it's *generated* and any changes you do in there may be silently over-written whenever you modify files elsewhere,
* the folders `_assets/`, `_libs/`, `_layout` and  `_css` contain *auxiliary files* supporting your site:
  * `_assets/` will contain images, code snippets, etc.,
  * `_css/` will contain the style sheets,
  * `_libs/` will contain javascript libraries,
  * `_layout/` will contain bits of HTML scaffolding for the generated pages,
@@

### Top folder

In this folder,

@@tlist
* `index.md` will generate the site's landing page,
* `pages/page1.md` would correspond to pages on your website (you can have whatever subfolder structure you want in here),
* `config.md` allows to specify variables that help steer the page generation, you can also use it to declare global variables or definitions that can then be used on all pages.
@@

\note{You can also write pages in plain HTML. For instance you may want to write an `index.html` file instead of generating it via the `index.md`. You will still need to put it at the exact same place and let Franklin copy the files appropriately.}

Note that Franklin generates a folder structure in `__site` which allows to have URLs like `[website]/page1/`. The following rules are applied:

* the filename is `[path/]index.md` or `[path/]index.html`, it will be copied over "as is" to `__site/[path/]index.html`,
* the filename is `[path/]somepage.md` or `[path/]somepage.html`, it will be copied to `__site/[path/]somepage/index.html`.

So for instance if we ignore auxiliary files and you have

```
.
├── index.md
├── folder
│   └── subpage.md
└── page.md
```

it will lead to

```
__site
  ├── index.html
  ├── folder
  │   └── subpage
  │       └── index.html
  └── page
      └── index.html
```

which allows to have the following URLs:

@@tlist
* `[website]/`
* `[website]/page/`
* `[website]/folder/subpage/`
@@

### Reserved names

To avoid name clashes, refrain from using the following paths where `/` indicates the topdir (website folder):

@@tlist
* `/css/` or `/css.md`
* `/layout/` or `/layout.md`
* `/literate/` or `/literate.md`
@@

Also bear in mind that Franklin will ignore `README.md`, `LICENSE.md`, `Manifest.toml` and `Project.toml`.

### Editing and testing your website

The `serve` function can be used to launch a server which will track and render modifications.
There are a few useful options you can use beyond the barebone `serve()`, do `?serve` in your REPL for all options, we list a few noteworthy one below:

@@tlist
* `clear=true`, erases `__site` and starts from a blank slate,
* `single=false`, if set to `true`, does a single build pass generating all pages and does not start the server.
* `prerender=false`, if set to `true`, will prerender code blocks and maths (see the [optimisation step](#optimisation_step))
* `verb=false`, whether to show information about which page is being processed etc,
* `silent=false`, if set to `true`, will suppress any informative messages that could otherwise appear in  your console when editing your site, this goes one step further than `verb=false` as it also  applies for code evaluation,
* `eval_all=false`, if set to `true`, will re-evaluate all code blocks on all pages.
@@

### Verifying links

Before deploying you may want to verify that links on your website lead somewhere, to do so use the `verify_links()`.
It will take a few second to verify all links on every generated pages but can be quite helpful to identify dead links or links with typos.

## Deploying your website

In this section we'll assume that you want to host your website on GitHub or GitLab, either on a personal page or a project page.
If you're using your own hosting server, you just need to copy/clone the content of `__site` there.

Services like Netlify also provide an easy setup to link to a repo that contains your website.

### Setting up

If you haven't done so already, you need to make your website folder a git repository and link it with either a GitHub or GitLab repository; the steps below need to be done only once.

@@tlist
1. Create an empty repo on Git*; if you want a personal page you will need to  specify `username.github.io` or `username.gitlab.io` as the repo name (see [here for github](https://pages.github.com/), [here for gitlab](https://about.gitlab.com/stages-devops-lifecycle/pages/)).
1. (GitHub only) set up secrets (see next point)
1. In your local folder do
  - `git init && git add -A && git commit -am "initial files"`
  - `git remote add origin https://URL_TO_YOUR_REPO`
  - `git push -u origin master`
@@

and... that's it. The `newsite` command that you will have used initially also generated CI files for both GitHub and GitLab that, when pushed, will trigger a page deploy. In a few minutes your site will be online.

### Setting up access tokens on GitHub

In order for the deployment action to work on GitHub, you need to set up an access token on GitHub. The steps are explained below but you [can read more on the topic here](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line).

There are two steps: first you need to create the token, then you need to tell your site repo to use it.

**STEP 1**:

@@tlist
1. Go to the [tokens generation page](https://github.com/settings/tokens) in your *Settings > Developper settings > Personal access tokens*  and click on _Generate new token_.
1. Name the token `FRANKLIN` and click on the `repo` scope; then scroll to the bottom and click on **Generate token**.
1. Click on the button to copy the key:
@@

![](/assets/img/generate_token.png)

**STEP 2**:

@@tlist
* Go to the repository hosting your website and select *Settings > Secrets* then click on **Add new secret**,
* Name the secret `FRANKLIN` and copy the key from the previous step. *Make sure that no whitespace is introduce before or after the key*.
@@

![](/assets/img/add_secret.png)


### Updating your website

You essentially just need to commit and push changes. Franklin also provides a convenient `publish` function which:

@@tlist
- applies an optional optimisation step (see below)
- does a `git add -A; git commit -am "franklin-update"; git push`
@@

See `?publish` for more information.

### Verification

Before publishing, you may also want to verify that all links on your site are valid. For this use the function `verify_links`:

```julia-repl
julia> verify_links()
Verifying links... [you seem online ✓]
- internal link issue on page index.md: pub/menu3.html.
```

then after fixing and re-generating pages:

```julia-repl
julia> verify_links()
All internal and external links verified ✓.
```

### Optimisation step

The `optimize` function can
@@tlist
1. pre-render KaTeX and highlight.js code to HTML so that the pages don't have to load these javascript libraries,
1. minify all generated HTML and CSS.
@@
See `?optimize` for options.

Those two steps may lead to faster loading pages.
Note that in order to run them, you will need a couple of external dependencies as mentioned in the [installation section](/index.html#installing_optional_extras).

### Post-processing

The `publish` function accepts a `final=` keyword to which you can pass any function `() -> nothing` which may do some final post-processing before pushing updates online.

For instance you can pass `final=lunr` where `lunr` is a function exported by Franklin which generates a Lunr search index (see [this tutorial](http://localhost:8000/pub/extras/lunr.html) for more details).

## Summary

@@tlist
1. use `newsite` to generate a website folder,
1. use `serve` to build it and edit it,
1. create a repository on GitHub or GitLab, if on GitHub create access tokens as explained earlier,
1. initialise your website folder as a git repository and link it to the remote repository (you can use the git commands indicated earlier),
1. when appropriate, use the `publish` function to push updates and trigger a deployment of the website.
@@

\note{If the site is a **project** site with a root URL of the form `[base]/myProject/`, make sure to add the line `@def prepath = "myProject"` in your `config.md` before using `publish`.}

### Other providers

* **Netlify**: just specify  `__site` as the build directory and that's it.

\note{Help is welcome to complete these instructions}
