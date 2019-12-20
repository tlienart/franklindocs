@def hascode = true

<!--
reviewed: 23/11/19
-->

# Working with JuDoc

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
→ Use serve() from JuDoc to see the website in your browser.
```

There are a number of [simple templates](https://tlienart.github.io/JuDocTemplates.jl/) you can choose from and tweak.

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
├── assets/
├── libs/
└── src/
```

After running `serve` the first time, two additional folders are generated: `css/` and `pub/` along with the landing page `index.html`.
Among these folders:

* the **main folder** is `src/` and its subfolders, this is where the source files for your site are,
* you should *not modify* the `css/` and `pub/` folder as these are *generated* and any changes you do in there will be silently over-written whenever you modify files in `src/`; the same holds for `index.html`,
* the folders `assets/` and `libs/` contain *auxiliary files* supporting your site:
  * `assets/` will contain images, code snippets, etc.
  * `libs/` will contain javascript libraries.

### Source folder

The main folder you should care about is `src/`.
That folder has the following structure:

```plaintext
.
├── _css
│   ├── judoc.css
│   └── ...
├── _html_parts
│   ├── head.html
│   └── ...
├── config.md
├── index.md
└── pages
    ├── page1.md
    └── ...
```

In this folder,

* `index.md` will generate the site's landing page,
* `pages/page1.md` would correspond to pages on your website (you can have whatever subfolder structure you want in here)
* `_html_parts` contains the scaffolding of the pages which are assembled when the website HTML is generated. Among these files you will typically want to tweak `head.html` so that it calls the right `css` files etc.
* `_css` contains the `css` style sheets for your website.

\note{You can also write pages in plain HTML and place them in the `src/` folder. These files will be copied over to the `pub/` folder as they are. For instance you may prefer to directly write an `index.html` file instead of generating it via the `index.md`. You will still need to put it at the  exact same place (`src/index.html`) and let JuDoc copy the files appropriately.}

### Organising assets

Auxiliary assets such as images, pdf files etc. are recommended to go in the `assets/` folder and subfolders. The files that are located there will _not_ be tracked for change and will also not be copied around.

Alternatively, you could keep assets in `src/pages` and subfolders with the advantage that it may make the structure of the website simpler.
If you decide to do this, do bear in mind that whatever is in `src/pages` gets copied to the generated `pub/` folder during the initial generation pass.
While this will be imperceptible for a few light assets, it could incur a slowdown if you have heavy assets (e.g. a big PDF file).
In that case you'll  be better off with the recommended approach and putting the big file in `assets/`.

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

1. your website needs to be in a `public/` directory of the repository,
1. you need to specify a CI/CD script that tells GitLab how to deploy the website.

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

- applies an optional optimisation step (see below)
- does a `git add -A; git commit -am "jd-update"; git push`

### Optimisation step

The `optimize` function can

1. pre-render KaTeX and highlight.js code to HTML so that the pages don't have to load these javascript libraries,
1. minify all generated HTML and CSS.

See `?optimize` for options.

Those two steps may lead to faster loading pages.
Note that in order to run them, you will need a couple of external dependencies as mentioned in the [installation section](/index.html#installing_optional_extras).
