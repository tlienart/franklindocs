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
* the **main folder** is the top one and its subfolders, this is where the source files like `index.md` for your site are,
* you should *not modify* the content of `__site` as it's *generated* and any changes you do in there will be silently over-written whenever you modify files elsewhere,
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
* `config.md` allows to specify variables that help steer the page generation.
@@

\note{You can also write pages in plain HTML. For instance you may prefer to directly write an `index.html` file instead of generating it via the `index.md`. You will still need to put it at the exact same place and let Franklin copy the files appropriately.}

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

You can also verify that links on your website lead somewhere, to do so use the `verify_links()` function before deploying.
It will take a few second to verify all links on every pages but can be quite helpful to identify dead links or links with typos.

## Deploying your website

In this section we'll assume that you want to host your website on GitHub or GitLab, either on a personal page or a project page.
If you're using your own hosting server, you just need to copy/clone the content of your folder there.

Services like Netlify also provide an easy setup to link to a repo that contains your website.

### On GitHub

The first step is to create a repository for a personal or a project website:

* Follow the [guide on GitHub](https://pages.github.com/#user-site).

Once the repository is created, clone it on your computer, remove whatever GitHub added there for you and copy the content of your website folder.

If it's your personal website (base URL: `username.github.io/`) just use `publish()` and your website will be live in a matter of minutes.

If it's a project website (base URL: `username.github.io/MyProject/`) there is one extra step needed, add this line in your `src/config.md` file:

```markdown
@def prepath = "MyProject"
```

then use `publish()`.
This will make sure all links are adjusted to reflect the base URL.

### On GitLab

The first step is to create a repository for a personal or a project website:

* Follow the [guide on GitLab](https://about.gitlab.com/product/pages/).

Then there are two small differences with the GitHub process:
@@tlist
1. your website needs to be in a `public/` directory of the repository,
1. you need to specify a CI/CD script that tells GitLab how to deploy the website.
@@
Luckily both of these can be done in one shot, all you need to do is add the following script to the `.gitlab-ci.yml` file in your repository:

```yaml
pages:
  stage: deploy
  script:
    - mkdir .public
    - cp -r * .public
    - mv .public public
  artifacts:
    paths:
      - public
  only:
    - master
```

The `script:` section tells the GitLab runner to copy all your files in a "virtual" `public/` directory.
Note that this will not create a directory in your repo; it will just create one on GitLab in such a way that files can be rendered.

\note{If your repository is private and you would like to avoid for some files to be in the `public/` folder, just add lines like `rm public/path/to/file1` in the `script:` section or use `rsync` instead of `cp`.}


## Publication step

The `publish` function is an easy way to deploy your website after making some changes locally.
Basically it:
@@tlist
- applies an optional optimisation step (see below)
- does a `git add -A; git commit -am "franklin-update"; git push`
@@

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

### Final step

The `publish` function accepts a `final=` keyword to which you can pass any function `() -> nothing` which may do some final post-processing before pushing updates online.

For instance you can pass `final=lunr` where `lunr` is a function exported by Franklin which generates a Lunr search index (see [this tutorial](http://localhost:8000/pub/extras/lunr.html) for more details).
