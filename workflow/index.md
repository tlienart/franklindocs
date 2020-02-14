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

## Post-processing

### Verify links

Before deploying you may want to verify that links on your website lead somewhere, to do so use the `verify_links()`.
It will take a few second to verify all links on every generated pages but can be quite helpful to identify dead links or links with typos:

```julia-repl
julia> verify_links()
Verifying links... [you seem online ✓]
- internal link issue on page index.md: /menu3/.
```

then after fixing and re-generating pages:

```julia-repl
julia> verify_links()
All internal and external links verified ✓.
```

### Pre-rendering and compression

The `optimize` function can

@@tlist
* pre-render KaTeX and highlight.js code to HTML so that the pages don't have to load these javascript libraries,
* minify all generated HTML and CSS.
@@
See `?optimize` for options.

Those two steps may lead to faster loading pages.
Note that in order to run them, you will need a couple of external dependencies as mentioned in the [installation section](/index.html#installing_optional_extras).

The `optimize` function is called by default in the `publish` function which can be used to help deploy your website.

### Publish

Once you have synched your local folder with a remote repository (see instructions further below), the `publish` function can be called to deploy your website; it essentially:

@@tlist
- applies an optional optimisation step (see previous point),
- does a `git add -A; git commit -am "franklin-update"; git push`.
@@

See `?publish` for more information.

In any case, before deploying, if you're working on a _project website_ i.e. a website whose root URL will look like `username.gitlab.io/project/` then you should add the following line in your `config.md` file:

```markdown
@def prepath = "project"
```

the `publish` function will then ensure that all links are fixed before deploying your website.

Note also that the `publish` function accepts a `final=` keyword to which you can pass any function `() -> nothing` to do some final post-processing before pushing updates online.
For instance, you can use `final=lunr` where `lunr` is a function exported by Franklin which generates a Lunr search index (see [this tutorial](/extras/lunr.html) for more details).

## Deploying your website

Deploying the website is trivial on Gitlab and services like Netlify. On GitHub there are a few extra steps **especially if you want a user/org website**.
The full setup is detailed below and you should only have to do it once.

\note{If you have an existing website that predates Franklin 0.6, you will want to copy either [this GitHub action](https://github.com/tlienart/foosite4/blob/master/.github/workflows/deploy.yml) or [this GitLab CI](https://gitlab.com/tlienart/foo/-/blob/master/.gitlab-ci.yml) to your folder.}

### Deploying on GITHUB

**Warning**: the setup to synchronise your local folder and the remote repository is _different_ based on whether you want a user/org website (base URL looking like `username.github.io`) or a project website (base URL looking like `username.github.io/project/`). Make sure to follow the appropriate instructions!

#### Creating a repo on GitHub

Start by creating an empty GitHub repository

@@tlist
* for a personal (or org) website the repository **must** be named `username.github.io` (or `orgname.github.io`) see also [the github pages docs](https://pages.github.com/),
* for a project website the repo can be named anything you want.
@@

#### Adding access tokens

In order for the deployment action to work on GitHub, you need to set up an access token on GitHub. The steps are explained below but you [can read more on the topic here](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line).

There are two steps: first you need to create the token, then you need to tell your repo to use it.

**STEP 1**:

@@tlist
1. Go to the [tokens generation page](https://github.com/settings/tokens) in your *Settings > Developper settings > Personal access tokens*  and click on _Generate new token_.
1. Name the token `FRANKLIN` and toggle the `repo` scope; then scroll to the bottom and click on **Generate token**.
1. Click on the button to copy the key:
@@

![](/assets/img/generate_token.png)

\note{You may want to save that key somewhere safe as you will need it again if you create another Franklin repo and there will be no way of getting it again from GitHub.}

**STEP 2**:

@@tlist
* Go to the repository and select *Settings > Secrets* then click on **Add new secret**,
* Name the secret `FRANKLIN` and copy the key from the previous step. *Make sure that no whitespace is introduced before or after the key*.
@@

![](/assets/img/add_secret.png)

#### Synchronise your local folder [USER/ORG WEBSITE]

Now you need to synchronise your repository and your local website folder; to do so, go to your terminal, `cd` to the website folder and follow the steps below:

@@tlist
- `git init && git remote add origin URL_TO_YOUR_REPO`
- `git checkout -b dev`
- `git add -A && git commit -am "initial files"`
@@

It is **crucial** to change branch to `dev` (or any other name that you like that is not `master`). This is because a user/org site **must** be deployed from the `master` branch.

Now, in an editor, open the file `.github/workflows/` and change the `on` section to

```yaml
on:
  push:
    branches:
      - dev
```

change also the `BRANCH` line at the end to `BRANCH: master`:

```yaml
BRANCH: master
FOLDER: __site
```

With all this, if you push changes to `dev`, the GitHub action will be triggered and deploy the content of the `__site` folder to  the `master` branch. GitHub pages will then deploy the website from the master branch.

\note{It takes a couple of minutes for the whole process to complete and your site to be available online.}

#### Synchronise your local folder [PROJECT WEBSITE]

Now you need to synchronise your repository and your local website folder; to do so, go to your terminal, `cd` to the website folder and follow the steps below:

@@tlist
- `git init && git remote add origin URL_TO_YOUR_REPO`
- `git add -A && git commit -am "initial files"`
@@

That's it! when you push your updates to the `master` branch, the GitHub action will deploy the `__site` folder to  a `gh-pages` branch that GitHub Pages will then use to deploy your website.

\note{It takes a couple of minutes for the whole process to complete and your site to be available online.}

#### Troubleshooting

@@tlist
- Make sure you have set the access tokens properly,
- Make sure GitHub Pages is pointing at the right branch (see screenshot below),
- Open an issue on Franklin's GitHub or ask on the **#franklin** juliaslack channel.
@@

![](/assets/img/deploy_branch.png)

### Deploying on GITLAB

#### Creating a repo on GitLab

Start by creating an empty GitLab repository

@@tlist
* for a personal website the repository **must** be named `username.gitlab.io` see also [the gitlab pages docs](https://about.gitlab.com/stages-devops-lifecycle/pages/),
* for a project website the repo can be named anything you want.
@@

#### Synchronise your local folder

Now you need to synchronise your repository and your local website folder; to do so, go to your terminal, `cd` to the website folder and follow the steps below:

@@tlist
- `git init && git remote add origin URL_TO_YOUR_REPO`
- `git add -A && git commit -am "initial files"`
@@

That's it! when you push your updates to the `master` branch, the GitLab CI will copy the `__site` folder to a virtual `public` folder and deploy its content.

\note{It takes a couple of minutes for the whole process to complete and your site to be available online.}

### Deploying on Netlify

Synchronise your local website folder with a repository (e.g. a GitHub or GitLab repository) then select that repository on Netlify and indicate you want to deploy the `__site` folder. That's it!
