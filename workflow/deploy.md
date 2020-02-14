@def hascode = true

# Deploying your website

\blurb{Set it up once then don't think about it.}

\lineskip

\toc

\lineskip

Deploying the website is trivial on Gitlab and services like Netlify. On GitHub there are a few extra steps **especially if you want a user/org website**.

\note{If you have an existing website that predates Franklin 0.6, you will want to copy either [this GitHub action](https://github.com/tlienart/foosite4/blob/master/.github/workflows/deploy.yml) or [this GitLab CI](https://gitlab.com/tlienart/foo/-/blob/master/.gitlab-ci.yml) to your website folder.}

## Deploying on GitHub

**Warning**: the setup to synchronise your local folder and the remote repository is _different_ based on whether you want a user/org website (base URL looking like `username.github.io`) or a project website (base URL looking like `username.github.io/project/`). Make sure to follow the appropriate instructions!

### Creating a repo on GitHub

Start by creating an empty GitHub repository

@@tlist
* for a personal (or org) website the repository **must** be named `username.github.io` (or `orgname.github.io`) see also [the github pages docs](https://pages.github.com/),
* for a project website the repo can be named anything you want.
@@

### Adding access tokens

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

### Synchronise your local folder [User/Org website]

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

### Synchronise your local folder [Project website]

Now you need to synchronise your repository and your local website folder; to do so, go to your terminal, `cd` to the website folder and follow the steps below:

@@tlist
- `git init && git remote add origin URL_TO_YOUR_REPO`
- `git add -A && git commit -am "initial files"`
@@

That's it! when you push your updates to the `master` branch, the GitHub action will deploy the `__site` folder to  a `gh-pages` branch that GitHub Pages will then use to deploy your website.

\note{It takes a couple of minutes for the whole process to complete and your site to be available online.}

### Troubleshooting

@@tlist
- Make sure you have set the access tokens properly,
- Make sure GitHub Pages is pointing at the right branch (see screenshot below),
- Open an issue on Franklin's GitHub or ask on the **#franklin** juliaslack channel.
@@

![](/assets/img/deploy_branch.png)

## Deploying on GitLab

### Creating a repo on GitLab

Start by creating an empty GitLab repository

@@tlist
* for a personal website the repository **must** be named `username.gitlab.io` see also [the gitlab pages docs](https://about.gitlab.com/stages-devops-lifecycle/pages/),
* for a project website the repo can be named anything you want.
@@

### Synchronise your local folder

Now you need to synchronise your repository and your local website folder; to do so, go to your terminal, `cd` to the website folder and follow the steps below:

@@tlist
- `git init && git remote add origin URL_TO_YOUR_REPO`
- `git add -A && git commit -am "initial files"`
@@

That's it! when you push your updates to the `master` branch, the GitLab CI will copy the `__site` folder to a virtual `public` folder and deploy its content.

\note{It takes a couple of minutes for the whole process to complete and your site to be available online.}

## Deploying on Netlify

Synchronise your local website folder with a repository (e.g. a GitHub or GitLab repository) then select that repository on Netlify and indicate you want to deploy the `__site` folder.

That's it!
